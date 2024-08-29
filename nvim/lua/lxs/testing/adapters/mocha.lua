local async = require('neotest.async')
local lib = require('neotest.lib')
local logger = require('neotest.logging')

local Fn = vim.fn
local Fs = vim.fs
local Iter = vim.iter
local Json = vim.json
local List_extend = vim.list_extend
local Log = vim.log
local Loop = vim.loop
local Notify_once = vim.notify_once
local Split = vim.split
local System = vim.system

---@class neotest.MochaOptions
---@field mochaCommand? string|fun(): string
---@field mochaConfigFile? string|fun(): string
---@field env? table<string, string>|fun(): table<string, string>
---@field cwd? string|fun(): string
---@field strategy_config? table<string, unknown>|fun(): table<string, unknown>

---@class neotest.Adapter
---@field name string
local Adapter = {
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

---Search for the nearest configuration file starting from a directory.
---First, search upwards from the directory until the user's home
---directory. If no configuration file is found, search downwards from
---the directory. If a configuration file is still not found, return
---`nil`. If a configuration file is found, return its path.
---@param dir string
---@return string | nil
local function getMochaConfig(dir)
	local configuration_file = Fs.find(configuration_files, {
		limit = 1,
		path = dir,
		stop = Loop.os_homedir(),
		type = 'file',
		upward = true,
	})[1] or Fs.find(configuration_files, {
		limit = 1,
		path = dir,
		type = 'file',
	})[1]

	return configuration_file
end

---Search upwards from a directory for a `package.json` file. If found,
---return its path. If not found, return `nil`. Stops at the user's home
---directory.
---@param dir string
---@return string | nil
local find_package_root = function(dir)
	return Fs.find('package.json', {
		limit = 1,
		path = dir,
		stop = Loop.os_homedir(),
		type = 'file',
		upward = true,
	})[1]
end

--- Returns the path to the mocha command to be used.
---@param path string the file path to search from
---@return string | nil the path to the mocha command
local function getMochaCommand(path)
	local package_root = Fs.root(path or 0, function(name, path)
		local mocha_bin_path = Fs.join(path, 'node_modules', '.bin', 'mocha')
		return Fn.executable(mocha_bin_path) == 1
	end)

	return package_root and Fs.join(package_root, 'node_modules', '.bin', 'mocha') or 'npx mocha'
end

local function getEnv(specEnv)
	return specEnv
end

local function getCwd()
	return nil
end

local is_callable = function(obj)
	return type(obj) == 'function' or (type(obj) == 'table' and obj.__call)
end

---Find the project root directory given a current directory to work from.
---Should no root be found, the adapter can still be used in a non-project context if a test file matches.
---@async
---@param dir string @Directory to treat as cwd
---@return string | nil @Absolute root dir of test suite
function Adapter.root(dir)
	local configuration_file = getMochaConfig(dir)

	if configuration_file ~= nil then
		return Fs.dirname(configuration_file)
	end

	Notify_once('No mocha configuration file found', Log.levels.DEBUG)

	local package_root = find_package_root(dir)
	local ok, package = pcall(lib.files.read, package_root)

	if not ok then
		error('Failed to read package.json')
		return nil
	end

	local package_details = Fn.json_decode(package)
	local is_dependency = package_details['dependencies']
		and package_details['dependencies']['mocha'] ~= nil
	local is_dev_dependency = package_details['devDependencies']
		and package_details['devDependencies']['mocha'] ~= nil
	local scripts = package_details['scripts']
	local includes_mocha_script = Iter(scripts or {}):any(function(_, script)
		return script:find('(.*%s)?mocha(%s.*)?') ~= nil
	end)

	if is_dependency or is_dev_dependency or includes_mocha_script then
		return Fs.dirname(package_root)
	end
end

---Filter directories when searching for test files
---@async
---@param name string Name of directory
---@param rel_path string Path to directory, relative to root
---@param root string Root directory of project
---@return boolean
function Adapter.filter_dir(name, rel_path, root)
	local excluded = { 'coverage', 'node_modules' }
	if vim.list_contains(excluded, name) then
		return false
	end

	local full_path = Fs.normalize(Fs.joinpath(root, rel_path))

	local parent_iterator = Iter(Fs.parents(full_path))

	local within_excluded_directory = parent_iterator:any(function(parent)
		return vim.list_contains(excluded, Fs.basename(parent))
	end)

	vim.print(vim.inspect({
		name = name,
		rel_path = rel_path,
		root = root,
		full_path = full_path,
		within_excluded_directory = within_excluded_directory,
	}))

	return not within_excluded_directory
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

---Determines whether the provided file is a test file associated with the adapter.
---This should only return a positive result for mocha test files.
---@async
---@param file_path string
---@return boolean
function Adapter.is_test_file(file_path)
	if file_path == nil then
		return false
	end

	-- TODO: Make this configurable and use `unpack` to merge with defaults
	-- TODO: Consider using `nio` via `neotest.async` to make this asynchronous
	-- TODO: Consider using `json-stream` reporter - not compatible with `--parallel`
	local mocha_dry_run_output = System({
		'npx',
		'mocha',
		'--',
		'--parallel',
		'--dry-run',
		'-R=json',
	}, { text = true }):wait()

	if mocha_dry_run_output.code ~= 0 then
		local suffixes = Iter(file_extensions):map(function(ext)
			return Iter(testing_namespaces):map(function(ns)
				return string.format('.%s.%s$', ns, ext)
			end):totable()
		end):flatten()

		return suffixes:any(function(suffix)
			return file_path:find(suffix) ~= nil
		end)
	end

	local mocha_dry_run_json = Json.decode(mocha_dry_run_output.stdout)

	local normalized_file_path = Fs.normalize(file_path)
	local test_iterator = Iter(mocha_dry_run_json.tests)

	local file_is_test_file = test_iterator:any(function(tests)
		return Fs.normalize(tests.file) == normalized_file_path
	end)

	vim.print({ file_path = file_path, file_is_test_file = file_is_test_file })

	return file_is_test_file
end

---Given a file path, parse all the tests within it.
---@async
---@param file_path string Absolute file path
---@return neotest.Tree | nil
function Adapter.discover_positions(file_path)
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

	local positions = lib.treesitter.parse_positions(file_path, query, { nested_namespaces = true })

	vim.print(vim.inspect({ positions = positions }))

	return positions
end

--- Escape special characters in test name for use in a regular expression
---@param name string non-sanitised test name
---@return string, integer sanitised test name
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
	local event = Loop.new_fs_event()
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

--- Accepts parsed JSON data from mocha and returns a table of results
---@param data any not sure yet UPDATE ME
---@param output_file any not sure yet UPDATE ME
---@param consoleOut any not sure yet UPDATE ME
local function parsed_json_to_results(data, output_file, consoleOut)
	vim.print(vim.inspect({ data = data, output_file = output_file, consoleOut = consoleOut }))
end

local function get_default_strategy_config(strategy, command, cwd)
	vim.print(vim.inspect({ strategy = strategy, command = command, cwd = cwd }))
	local config = {
		dap = function()
			return {
				name = 'Debug Mocha Tests',
				type = 'pwa-node',
				request = 'launch',
				args = { unpack(command, 2) },
				runtimeExecutable = command[1],
				console = 'integratedTerminal',
				internalConsoleOptions = 'neverOpen',
				rootPath = '${workspaceFolder}',
				cwd = cwd or '${workspaceFolder}',
			}
		end,
	}
	if config[strategy] then
		return config[strategy]()
	end
end

local function get_strategy_config(default_strategy_config, args)
	return default_strategy_config
end

---@param args neotest.RunArgs
---@return nil | neotest.RunSpec | neotest.RunSpec[]
function Adapter.build_spec(args)
	local results_path = async.fn.tempname() .. '.json'
	local tree = args.tree

	vim.print(vim.inspect({ args = args }))

	if not tree then
		return
	end

	local pos = args.tree:data()
	local testNamePattern = "'.*'"

	vim.print(vim.inspect({ pos = pos }))
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
	local binary = 'npx mocha --'
	-- TODO: Make this configurable and use a smarter default
	local config = '.mocharc.js'
	local command = Split(binary, '%s+')
	if Fn.filereadable(Fs.normalize(config)) then
		-- only use config if available
		table.insert(command, '--config=' .. config)
	end

	List_extend(command, {
		'--full-trace',
		'--reporter=json',
		'--reporter-option=' .. results_path,
		'-grep=' .. testNamePattern,
		'--exit',
		sanitise_test_name(Fs.normalize(pos.path)),
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
				local ok, parsed = pcall(Json.decode, new_results, { luanil = { object = true } })

				if not ok or not parsed.testResults then
					return {}
				end

				return parsed_json_to_results(parsed, results_path, nil)
			end
		end,
		strategy = get_strategy_config(
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
function Adapter.results(spec, result, tree)
	spec.context.stop_stream()

	local output_file = spec.context.results_path

	local success, data = pcall(lib.files.read, output_file)

	if not success then
		vim.print('No test output file found', output_file)
		logger.error('No test output file found', output_file)
		return {}
	end

	local ok, parsed = pcall(Json.decode, data, { luanil = { object = true } })

	if not ok then
		vim.print('Failed to parse test output json', output_file)
		logger.error('Failed to parse test output json', output_file)
		return {}
	end

	local results = parsed_json_to_results(parsed, output_file, result.output)

	return results
end

setmetatable(Adapter, {
	---@param opts neotest.MochaOptions
	__call = function(self, opts)
		if is_callable(opts.mochaCommand) then
			getMochaCommand = opts.mochaCommand
		elseif opts.mochaCommand then
			getMochaCommand = function()
				return opts.mochaCommand
			end
		end
		if is_callable(opts.mochaConfigFile) then
			getMochaConfig = opts.mochaConfigFile
		elseif opts.mochaConfigFile then
			getMochaConfig = function()
				return opts.mochaConfigFile
			end
		end
		if is_callable(opts.env) then
			getEnv = opts.env
		elseif opts.env then
			getEnv = function(specEnv)
				return vim.tbl_extend('force', opts.env, specEnv)
			end
		end
		if is_callable(opts.cwd) then
			getCwd = opts.cwd
		elseif opts.cwd then
			getCwd = function()
				return opts.cwd
			end
		end
		if is_callable(opts.strategy_config) then
			get_strategy_config = opts.strategy_config
		elseif opts.strategy_config then
			get_strategy_config = function()
				return opts.strategy_config
			end
		end

		if opts.mocha_test_discovery then
			self.mocha_test_discovery = true
		end

		return self
	end,
})

return Adapter
