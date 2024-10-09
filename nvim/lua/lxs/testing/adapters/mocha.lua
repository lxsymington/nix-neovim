local async = require('neotest.async')
local lib = require('neotest.lib')
local logger = require('neotest.logging')

local Fs = vim.fs
local Iter = vim.iter
local Json = vim.json
local List_contains = vim.list_contains
local List_extend = vim.list_extend
local Loop = vim.loop
local Split = vim.split

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
local function get_mocha_config(dir)
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
---@param dir string | nil
---@return string | nil
local find_package_root = function(dir)
	local package_json_ancestor = Fs.find('package.json', {
		limit = 1,
		path = dir or vim.loop.cwd(),
		stop = Loop.os_homedir(),
		type = 'file',
		upward = true,
	})[1]

	local package_root = Fs.dirname(package_json_ancestor) or nil

	return package_root
end

local get_cwd = find_package_root

--- Returns the path to the mocha command to be used.
---@param path string | nil the file path to search from
---@return string | nil the path to the mocha command
local function get_mocha_command(path)
	local package_root = Fs.root(path or 0, function(name, currentPath)
		local mocha_bin_path = Fs.join(currentPath, 'node_modules', '.bin', 'mocha')
		return async.fn.executable(mocha_bin_path) == 1
	end)

	local mocha_command = package_root and Fs.join(package_root, 'node_modules', '.bin', 'mocha')
		or 'npx mocha -- '

	logger.debug(vim.inspect({
		context = 'get_mocha_command',
		mocha_command = mocha_command,
		package_root = package_root,
	}))

	return mocha_command
end

local function getEnv(specEnv)
	return specEnv
end

local is_callable = function(obj)
	local callable_check = type(obj) == 'function' or (type(obj) == 'table' and obj.__call)

	return callable_check
end

---Find the project root directory given a current directory to work from.
---Should no root be found, the adapter can still be used in a non-project context if a test file matches.
---@async
---@param dir string @Directory to treat as cwd
---@return string | nil @Absolute root dir of test suite
function Adapter.root(dir)
	local configuration_file = get_mocha_config(dir)

	if configuration_file ~= nil then
		return Fs.dirname(configuration_file)
	end

	logger.error('No configuration file found')

	local package_root = find_package_root(dir)
	local ok, package = pcall(lib.files.read, package_root)

	if not ok then
		logger.error('Failed to read package.json')
		return nil
	end

	local package_details = async.fn.json_decode(package)
	local is_dependency = package_details['dependencies']
		and package_details['dependencies']['mocha'] ~= nil
	local is_dev_dependency = package_details['devDependencies']
		and package_details['devDependencies']['mocha'] ~= nil
	local scripts = package_details['scripts']
	local includes_mocha_script = Iter(scripts or {}):any(function(_, script)
		return script:find('(.*%s)?mocha(%s.*)?') ~= nil
	end)

	logger.debug(
		vim.inspect({
			context = 'Adapter.root',
			package_root = package_root,
			is_dependency = is_dependency,
			is_dev_dependency = is_dev_dependency,
			includes_mocha_script = includes_mocha_script,
		})
	)

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
	if List_contains(excluded, name) then
		return false
	end

	local full_path = Fs.normalize(Fs.joinpath(root, rel_path))

	local parent_iterator = Iter(Fs.parents(full_path))

	local within_excluded_directory = parent_iterator:any(function(parent)
		return List_contains(excluded, Fs.basename(parent))
	end)

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

--- A cache of test files for a project
---@class ProjectTestCache
---@field code? integer the exit code of the last test discovery command
---@field files? table<string> a list table of file paths that are test files within the project
local project_tests = setmetatable({}, {
	---The __index metamethod is used to lazily load the test files for a project
	---@async
	---@param self ProjectTestCache the project test cache
	---@param key string the key being accessed on the cache
	__index = function(self, key)
		-- TODO: invalidate this cache on a file system event within the project
		local actual = rawget(self, key)

		logger.debug(
			vim.inspect({
				context = 'ProjectTestCache.__index',
			  actual = actual or 'no `actual` found',
			  key = key
			}),
		)

		local cwd = get_cwd(vim.loop.cwd())
		local mocha_cmd = get_mocha_command(cwd)
		local cmd_elements = Iter(Split(mocha_cmd or '', '%s+', { trimempty = true }))
		local cmd = cmd_elements:next()
		local args = cmd_elements:totable()

		if List_contains({ 'code', 'files' }, key) and actual == nil then
			-- TODO: Make this configurable and use `unpack` to merge with defaults
			-- TODO: Cache this, it's expensive and run for every file in the project
			local mocha_dry_run_task = async.process.run({
				cmd = cmd,
				args = List_extend(args, {
					'--dry-run',
					'-R=json',
				}),
			})

			local mocha_dry_run_output = mocha_dry_run_task.stdout.read()
			local mocha_dry_run_error = mocha_dry_run_task.stderr.read()
			local mocha_dry_run_exit_code = mocha_dry_run_task.result(function()
				return true
			end)

			if mocha_dry_run_error ~= '' then
				logger.warn('Error received while running mocha dry run', mocha_dry_run_error)
			end

			rawset(self, 'code', mocha_dry_run_exit_code)

			if mocha_dry_run_exit_code ~= 0 then
				return rawget(self, key)
			end

			local ok, mocha_dry_run_json = pcall(Json.decode, mocha_dry_run_output)

			local test_iterator = Iter(mocha_dry_run_json.tests)
			local test_files = test_iterator:fold({}, function(dictionary, test)
				dictionary[Fs.normalize(test.file)] = test
				return dictionary
			end)

			logger.debug(
			  vim.inspect({
				context = 'ProjectTestCache.__index',
			    test_files = test_files
			  })
			)

			rawset(self, 'files', test_files)

			if not ok then
				rawset(self, 'code', 1)
				return rawget(self, key)
			end
		end

		return actual
	end,
})

---Determines whether the provided file is a test file associated with the adapter.
---This should only return a positive result for mocha test files.
---@async
---@param file_path string
---@return boolean
function Adapter.is_test_file(file_path)
	if file_path == nil then
		return false
	end

	local code = project_tests.code

	logger.debug(
	  vim.inspect({
      context = 'Adapter.is_test_file',
	    code = code or 'no `code` found'
	  })
	)

	if code ~= 0 then
		local suffixes = Iter(file_extensions):map(function(ext)
			return Iter(testing_namespaces):map(function(ns)
				return string.format('.%s.%s$', ns, ext)
			end):totable()
		end):flatten()

		return suffixes:any(function(suffix)
			return file_path:find(suffix) ~= nil
		end)
	end

	local normalized_file_path = Fs.normalize(file_path)
	local files = project_tests.files

	logger.debug(
	  vim.inspect({
      context = 'Adapter.is_test_file',
      files = files or 'no `files` found'
    })
	)

	return files[normalized_file_path] ~= nil
end

--- A helper function to determine the type of match from a treesitter query
---@param captured_nodes unknown The nodes captured by the query
local function get_match_type(captured_nodes)
	if captured_nodes['test.name'] then
		return 'test'
	end
	if captured_nodes['namespace.name'] then
		return 'namespace'
	end
end

--- Construct position data from a treesitter query match
---@param file_path string The path to the file
---@param source string The source code of the match
---@param captured_nodes unknown The nodes captured by the query
---@return table<string, unknown> | nil a test position object
function Adapter.build_position(file_path, source, captured_nodes)
	local match_type = get_match_type(captured_nodes)

	if not match_type then
		return
	end

	-- TODO: Something is wrong here take a look at the neotest logs which can be found at
	-- `~/.local/state/nvim/neotest.log`

	---@type string
	local name = vim.treesitter.get_node_text(captured_nodes[match_type .. '.name'], source)
	local definition = captured_nodes[match_type .. '.definition']

	logger.debug(
		vim.inspect({
			context = 'build_position',
		  match_type = match_type,
		  name = name,
		  definition = definition
		})
	)

	return {
		type = match_type,
		path = file_path,
		name = name,
		range = { definition:range() },
	}
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

	local positions = lib.treesitter.parse_positions(file_path, query, {
		nested_namespaces = true,
		nested_tests = false,
		build_position = require('lxs.testing.adapters.mocha').build_position,
	})

	return positions
end

--- Escape special characters in test name for use in a regular expression
---@param name string non-sanitised test name
---@return string sanitised test name
local function sanitise_test_name(name)
	local file_name = name:gsub("([%(%)%[%]%*%+%-%?%$%^%/%'])", '%%\\%1')
	logger.debug(
	  vim.inspect({
      context = 'sanitise_test_name',
	    name = name,
	    file_name = file_name
	  })
	)

	return name
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

			logger.debug(
			  vim.inspect({
          context = 'stream',
			    data = data
			  })
			)

			queue.put(data)
		end)
	end

	read()
	local event = Loop.new_fs_event()
	event:start(file_path, {}, function(err, two, three)
		logger.debug(
		  vim.inspect({
        context = 'stream',
		    err = err,
		    two = two,
		    three = three
		  })
		)
		assert(not err, err)
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

---@class MochaStatistics
---@field duration number The total execution time of the test run in milliseconds
---@field end string A timestamp of when the test run ended
---@field failures number The number of failed tests
---@field passes number The number of passed tests
---@field pending number The number of pending tests
---@field start string A timestamp of when the test run started
---@field suites number The total number of suites
---@field tests number The total number of tests

---@class MochaError
---@field message string The error message
---@field operator string The operator that failed
---@field showDiff boolean Whether to show the diff
---@field stack string The stack trace of the error
---@field actual? string The actual value
---@field expected? string The expected value

---@class MochaTestPending
---@field currentRetry number The current retry count
---@field err table vim.empty_dict(),
---@field file string The file path of the test
---@field fullTitle string The full title of the test including all parent suites
---@field title string The title of the test

---@class MochaTestResult: MochaTestPending
---@field duration number The execution time of the test in milliseconds
---@field speed string The speed of the test

---@class MochaTestPass: MochaTestResult

---@class MochaTestFail: MochaTestResult
---@field err MochaError The error that caused the test to fail

---@class MochaTest: MochaTestPass | MochaTestFail | MochaTestPending

---@class MochaResult
---@field stats MochaStatistics
---@field pending MochaTestPending[]
---@field failures MochaTestFail[]
---@field tests MochaTest[]
---@field passes MochaTestPass[]

--- Accepts parsed JSON data from mocha and returns a table of results
---@param data MochaResult parsed JSON data from mocha
---@param output_file string path to JSON output file
---@param consoleOut? string path to console output file
---@return table<string, neotest.Result>
local function parsed_json_to_results(data, output_file, consoleOut)
	local pending_test_iterator = Iter(data.pending)
	local failing_test_iterator = Iter(data.failures)
	local passing_test_iterator = Iter(data.passes)

	local pending_results = pending_test_iterator:fold({}, function(result_dictionary, test)
		result_dictionary[test.fullTitle] = {
			status = 'skipped',
			name = test.title,
		}

		return result_dictionary
	end)

	local failing_results = failing_test_iterator:fold({}, function(result_dictionary, test)
		local diff = test.err.showDiff and vim.diff(test.err.actual, test.err.expected, {}) or nil

		logger.debug(
		  vim.inspect({
        context = 'parsed_json_to_results',
		    diff = diff
		  })
		)

		result_dictionary[test.fullTitle] = {
			status = 'failed',
			name = test.title,
		}

		return result_dictionary
	end)

	local passing_results = passing_test_iterator:fold({}, function(result_dictionary, test)
		result_dictionary[test.fullTitle] = {
			status = 'passed',
			name = test.title,
		}

		return result_dictionary
	end)

	--[[ local tests = {}

	for _, testResult in pairs(data.testResults) do
		local testFn = testResult.name
		for _, assertionResult in pairs(testResult.assertionResults) do
			local status, name = assertionResult.status, assertionResult.title

			if name == nil then
				logger.error('Failed to find parsed test result ', assertionResult)
				return {}
			end

			local keyid = testFn

			for _, value in ipairs(assertionResult.ancestorTitles) do
				keyid = keyid .. '::' .. value
			end

			keyid = keyid .. '::' .. name

			if status == 'pending' then
				status = 'skipped'
			end

			tests[keyid] = {
				status = status,
				short = name .. ': ' .. status,
				output = consoleOut,
				location = assertionResult.location,
			}

			if not vim.tbl_isempty(assertionResult.failureMessages) then
				local errors = {}

				for i, failMessage in ipairs(assertionResult.failureMessages) do
					local msg = cleanAnsi(failMessage)
					local errorLine, errorColumn = findErrorPosition(testFn, msg)

					errors[i] = {
						line = (errorLine or assertionResult.location.line) - 1,
						column = (errorColumn or 1) - 1,
						message = msg,
					}

					tests[keyid].short = tests[keyid].short .. '\n' .. msg
				end

				tests[keyid].errors = errors
			end
		end
	end

	return tests ]]

	return vim.tbl_extend('force', {}, pending_results, failing_results, passing_results)
end

local function get_default_strategy_config(strategy, command, cwd)
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

	if not tree then
		return
	end

	local pos = args.tree:data()
	local testNamePattern = "'.*'"

	logger.debug(
	  vim.inspect({
      context = 'Adapter.build_spec',
	    id = pos.id,
	    type = pos.type
	  })
	)

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
	local binary = get_mocha_command()
	-- TODO: Make this configurable and use a smarter default
	local config = '.mocharc.js'
	local command = Split(binary, '%s+')
	if async.fn.filereadable(Fs.normalize(config)) then
		-- only use config if available
		table.insert(command, '--config=' .. config)
	end

	List_extend(command, {
		'--full-trace',
		'--reporter=json',
		string.format('--reporter-option="output=%s"', results_path),
		'--grep=' .. testNamePattern,
		'--exit',
		sanitise_test_name(Fs.normalize(pos.path)),
	})

	local cwd = get_cwd(pos.path)

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

				logger.debug(
				  vim.inspect({
            context = 'Adapter.build_spec.stream',
				    ok = ok,
				    parsed = parsed
				  })
				)

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
			get_mocha_command = opts.mochaCommand
		elseif opts.mochaCommand then
			get_mocha_command = function()
				return opts.mochaCommand
			end
		end
		if is_callable(opts.mochaConfigFile) then
			get_mocha_config = opts.mochaConfigFile
		elseif opts.mochaConfigFile then
			get_mocha_config = function()
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
			get_cwd = opts.cwd
		elseif opts.cwd then
			get_cwd = function(...)
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
