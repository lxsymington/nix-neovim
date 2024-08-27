local async = require('neotest.async')
local lib = require('neotest.lib')

local neotest_mocha = {}

---@class neotest.Adapter
---@field name string
neotest_mocha.Adapter = {
	name = 'neotest-mocha',
}

local configuration_files = {
	'.mocharc.js',
	'.mocharc.cjs',
	'.mocharc.yaml',
	'.mocharc.yml',
	'.mocharc.json',
	'.mocharc.jsonc',
}

local function find_nearest_configuration_file(dir)
	local configuration_file = vim.fs.find(configuration_files, {
		limit = 1,
		path = dir,
		stop = vim.loop.os_homedir(),
		type = 'file',
		upward = true,
	})[1] or vim.fs.find(configuration_files, {
		limit = 1,
		path = dir,
		type = 'file',
	})[1]

	return configuration_file
end

local find_package_root = function(dir)
	return vim.fs.find('package.json', {
		limit = 1,
		path = dir,
		stop = vim.loop.os_homedir(),
		type = 'file',
		upward = true,
	})[1]
end

---Find the project root directory given a current directory to work from.
---Should no root be found, the adapter can still be used in a non-project context if a test file matches.
---@async
---@param dir string @Directory to treat as cwd
---@return string | nil @Absolute root dir of test suite
function neotest_mocha.Adapter.root(dir)
	local configuration_file = find_nearest_configuration_file(dir)

	if configuration_file ~= nil then
		return vim.fs.dirname(configuration_file)
	end

	vim.notify_once('No mocha configuration file found', vim.log.levels.DEBUG)

	local package_root = find_package_root(dir)
	local ok, package = pcall(lib.files.read, package_root)

	if not ok then
		error('Failed to read package.json')
		return nil
	end

	local package_details = vim.fn.json_decode(package)
	local is_dependency = package_details['dependencies']
		and package_details['dependencies']['mocha'] ~= nil
	local is_dev_dependency = package_details['devDependencies']
		and package_details['devDependencies']['mocha'] ~= nil
	local scripts = package_details['scripts']
	local includes_mocha_script = vim.iter(scripts or {}):any(function(_, script)
		return script:find('(.*%s)?mocha(%s.*)?') ~= nil
	end)

	if is_dependency or is_dev_dependency or includes_mocha_script then
		return vim.fs.dirname(package_root)
	end
end

---Filter directories when searching for test files
---@async
---@param name string Name of directory
---@param rel_path string Path to directory, relative to root
---@param root string Root directory of project
---@return boolean
function neotest_mocha.Adapter.filter_dir(name, rel_path, root)
	if name == 'node_modules' then
		return false
	end

	local is_within_node_modules = vim.fs.find('node_modules', {
		limit = 1,
		path = vim.fs.normalize(rel_path),
		stop = vim.fs.normalize(root),
		type = 'directory',
		upward = true,
	})[1] ~= nil

	return not is_within_node_modules
end

local file_extensions = {
	'.js',
	'.jsx',
	'.ts',
	'.tsx',
}

local testing_namespaces = {
	'e2e',
	'integration',
	'regression',
	'spec',
	'test',
}

---@async
---@param file_path string
---@return boolean
function neotest_mocha.Adapter.is_test_file(file_path)
	if file_path == nil then
		return false
	end

	-- TODO: Make this configurable and use `unpack` to merge with defaults
	-- TODO: Consider using `nio` via `neotest.async` to make this asynchronous
	-- TODO: Consider using `json-stream` reporter - not compatible with `--parallel`
	local mocha_dry_run_output = vim
		.system({
			'npx',
			'mocha',
			'--parallel',
			'--dry-run',
			'-R=json',
		}, { text = true })
		:wait()

	if mocha_dry_run_output.code ~= 0 then
		vim.print('Failed to run mocha --dry-run')
		vim.print(mocha_dry_run_output.stderr)

		local suffixes = vim
			.iter(file_extensions)
			:map(function(ext)
				return vim.iter(testing_namespaces):map(function(ns)
					return string.format('.%s.%s$', ns, ext)
				end)
			end)
			:flatten()

		return suffixes:any(function(suffix)
			return file_path:find(suffix) ~= nil
		end)
	end

	local mocha_dry_run_json = vim.json.decode(mocha_dry_run_output.stdout)

	return vim.iter(mocha_dry_run_json.tests):any(function(tests)
		return vim.fs.normalize(tests.file) == vim.fs.normalize(file_path)
	end)
end

---Given a file path, parse all the tests within it.
---@async
---@param file_path string Absolute file path
---@return neotest.Tree | nil
function neotest_mocha.Adapter.discover_positions(file_path)
	local query = [[
    ; -- Namespaces --
    ; Matches: `describe('context', () => {})`
    ; Matches: `describe('context', function() {})`
    ((call_expression
      function: (identifier) @func_name (#eq? @func_name "describe")
      arguments: (arguments (string (string_fragment) @namespace.name) [(arrow_function) (function_expression)])
    )) @namespace.definition
    ; Matches: `describe.only('context', () => {})`
    ; Matches: `describe.only('context', function() {})`
    ((call_expression
      function: (member_expression
        object: (identifier) @func_name (#any-of? @func_name "describe")
      )
      arguments: (arguments (string (string_fragment) @namespace.name) [(arrow_function) (function_expression)])
    )) @namespace.definition

    ; -- Tests --
    ; Matches: `it('test')`
    ((call_expression
      function: (identifier) @func_name (#eq? @func_name "it")
      arguments: (arguments (string (string_fragment) @test.name) [(arrow_function) (function_expression)])
    )) @test.definition
    ; Matches: it.only('test')`
    ((call_expression
      function: (member_expression
        object: (identifier) @func_name (#eq? @func_name "it")
      )
      arguments: (arguments (string (string_fragment) @test.name) [(arrow_function) (function_expression)])
    )) @test.definition
  ]]

	return lib.treesitter.parse_positions(file_path, query, { nested_namespaces = true })
end

local function sanitise_test_name(name)
	return name:gsub("([%(%)%[%]%*%+%-%?%$%^%/%'])", '%%\\%1')
end

-- Note: this function is almost entirely taken from https://github.com/nvim-neotest/neotest/blob/master/lua/neotest/lib/file/init.lua#L93-L144
-- The only difference is that neotest function reads only new lines and this one reads and returns the whole file
--- Streams data from a file, watching for new data over time
--- Each time new data arrives function reads whole file and returns its content
--- Useful for watching a file which is written to by another process.
---@async
---@param file_path string
---@return (fun(): string, fun()) Iterator and callback to stop streaming
local function stream(file_path)
	local queue = async.control.queue()
	local read_semaphore = async.control.semaphore(1)

	local open_err, file_fd = async.uv.fs_open(file_path, 'r', 438)
	assert(not open_err, open_err)

	local exit_future = async.control.future()
	local read = function()
		read_semaphore.with(function()
			local stat_err, stat = async.uv.fs_fstat(file_fd)
			assert(not stat_err, stat_err)
			local read_err, data = async.uv.fs_read(file_fd, stat.size, 0)
			assert(not read_err, read_err)
			queue.put(data)
		end)
	end

	read()
	local event = vim.loop.new_fs_event()
	event:start(file_path, {}, function(err, _, _)
		assert(not err)
		async.run(read)
	end)

	local function stop()
		exit_future.wait()
		event:stop()
		local close_err = async.uv.fs_close(file_fd)
		assert(not close_err, close_err)
	end

	async.run(stop)

	return queue.get, exit_future.set
end

---@param args neotest.RunArgs
---@return nil | neotest.RunSpec | neotest.RunSpec[]
function neotest_mocha.Adapter.build_spec(args)
	local results_path = async.fn.tempname() .. '.json'
	local tree = args.tree

	if not tree then
		return
	end

	local pos = args.tree:data()
	local testNamePattern = "'.*'"

	vim.print({ pos = pos })
	if pos.type == 'test' or pos.type == 'namespace' then
		-- pos.id in form "path/to/file::Describe text::test text"
		local testName = string.sub(pos.id, string.find(pos.id, '::') + 2)
		testName, _ = string.gsub(testName, '::', ' ')
		testNamePattern = sanitise_test_name(testName)
		testNamePattern = "'^" .. testNamePattern
		if pos.type == 'test' then
			testNamePattern = testNamePattern .. "$'"
		else
			testNamePattern = testNamePattern .. "'"
		end
	end

	-- TODO: Make this configurable
	local binary = 'npx mocha'
	-- TODO: Make this configurable and use a smarter default
	local config = '.mocharc.js'
	local command = vim.split(binary, '%s+')
	if util.path.exists(config) then
		-- only use config if available
		table.insert(command, '--config=' .. config)
	end

	vim.list_extend(command, {
		'--full-trace',
		'--reporter=json',
		'--reporter-option=' .. results_path,
		'-grep=' .. testNamePattern,
		'--exit',
		sanitise_test_name(vim.fs.normalize(pos.path)),
	})

	local cwd = find_package_root(pos.path)

	-- creating empty file for streaming results
	lib.files.write(results_path, '')
	local stream_data, stop_stream = stream(results_path)

	return {
		command = command,
		cwd = cwd,
		context = {
			results_path = results_path,
			file = pos.path,
			stop_stream = stop_stream,
		},
		stream = function()
			return function()
				local new_results = stream_data()
				local ok, parsed = pcall(vim.json.decode, new_results, { luanil = { object = true } })

				if not ok or not parsed.testResults then
					return {}
				end

				return parsed_json_to_results(parsed, results_path, nil)
			end
		end,
		strategy = getStrategyConfig(
			get_default_strategy_config(args.strategy, command, cwd) or {},
			args
		),
		env = getEnv(args[2] and args[2].env or {}),
	}
end

---@async
---@param spec neotest.RunSpec
---@param result neotest.StrategyResult
---@param tree neotest.Tree
---@return table<string, neotest.Result>
function neotest_mocha.Adapter.results(spec, result, tree) end
