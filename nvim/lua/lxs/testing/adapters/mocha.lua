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

---Find the project root directory given a current directory to work from.
---Should no root be found, the adapter can still be used in a non-project context if a test file matches.
---@async
---@param dir string @Directory to treat as cwd
---@return string | nil @Absolute root dir of test suite
function neotest_mocha.Adapter.root(dir)
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

	if configuration_file ~= nil then
		return vim.fs.dirname(configuration_file)
	end

	local package_root = vim.fs.find('package.json', {
		limit = 1,
		path = dir,
		stop = vim.loop.os_homedir(),
		type = 'file',
		upward = true,
	})[1]

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
end

---@async
---@param spec neotest.RunSpec
---@param result neotest.StrategyResult
---@param tree neotest.Tree
---@return table<string, neotest.Result>
function neotest_mocha.Adapter.results(spec, result, tree) end
