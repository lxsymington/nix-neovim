---@mod lxs.typescript
---
---@brief [[
---TypeScript related functions
---@brief ]]
local lint = require('lint')
local tsc = require('tsc')
local diagnostic = vim.diagnostic
local json = vim.json
local fn = vim.fn
local loop = vim.loop

-- TypeScript Tooling ––––––––––––––––––––––––––––––––––––––––––––––––––––
local M = {}

function M.start()
	tsc.setup({
		auto_start_watch_mode = true,
		use_diagnostics = true,
		spinner = {
			'◜',
			'◠',
			'◝',
			'◞',
			'◡',
			'◟',
		},
	})

	local tslint_parser = function(output, bufnr)
		local json_results = string.match(output, '(.-)\n')
		local results_ok, tslint_results = pcall(json.decode, json_results)
		if not results_ok then
			return {}
		end

		local severity_map = {
			['ERROR'] = diagnostic.severity.ERROR,
			['WARNING'] = diagnostic.severity.WARN,
		}

		local diagnostics = {}

		for _, lint_result in ipairs(tslint_results) do
			table.insert(diagnostics, {
				bufnr = bufnr,
				lnum = lint_result.startPosition.line,
				end_lnum = lint_result.endPosition.line,
				col = lint_result.startPosition.character,
				end_col = lint_result.endPosition.character,
				severity = severity_map[lint_result.ruleSeverity],
				message = lint_result.failure,
				source = 'tslint',
				code = lint_result.ruleName,
			})
		end

		return diagnostics
	end

	lint.linters.tslint = function()
		local tslint_config = fn.findfile('tslint.json', loop.cwd())

		if not tslint_config then
			return {}
		end

		local typescript_config = fn.findfile('tsconfig.json', loop.cwd())
		local args = typescript_config
				and {
					'--format',
					'json',
					'--project',
					typescript_config,
				}
			or { '--format', 'json' }

		return {
			cmd = 'tslint',
			stdin = false, -- or false if it doesn't support content input via stdin. In that case the filename is automatically added to the arguments.
			append_fname = true, -- Automatically append the file name to `args` if `stdin = false` (default: true)
			args = args, -- list of arguments. Can contain functions with zero arguments that will be evaluated once the linter is used.
			stream = 'both', -- ('stdout' | 'stderr' | 'both') configure the stream to which the linter outputs the linting result.
			ignore_exitcode = true, -- set this to true if the linter exits with a code != 0 and that's considered normal.
			env = nil, -- custom environment table to use with the external process. Note that this replaces the *entire* environment, it is not additive.
			parser = tslint_parser,
		}
	end

	local ns = lint.get_namespace('tslint')
	diagnostic.config({
		virtual_text = {
			suffix = ' 🚩 tslint',
		},
	}, ns)
end

return M
