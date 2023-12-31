local lint = require('lint')
local ecmascript = require('lxs.ecmascript')

-- TypeScript Configuration ––––––––––––––––––––––––––––––––––––––––––––––––––––
ecmascript.start()
-- local tslint_parser = function(output, bufnr)
--   local json_results = string.match(output, '(.-)\n')
--   local results_ok, tslint_results = pcall(vim.json.decode, json_results)
--   if not results_ok then
--     return {}
--   end

--   local severity_map = {
--     ['ERROR'] = vim.diagnostic.severity.ERROR,
--     ['WARNING'] = vim.diagnostic.severity.WARN,
--   }

--   local diagnostics = {}

--   for _, lint_result in ipairs(tslint_results) do
--     table.insert(diagnostics, {
--       bufnr = bufnr,
--       lnum = lint_result.startPosition.line,
--       end_lnum = lint_result.endPosition.line,
--       col = lint_result.startPosition.character,
--       end_col = lint_result.endPosition.character,
--       severity = severity_map[lint_result.ruleSeverity],
--       message = lint_result.failure,
--       source = 'tslint',
--       code = lint_result.ruleName,
--     })
--   end

--   return diagnostics
-- end

-- lint.linters.tslint = function()
--   local tslint_config = vim.fn.findfile('tslint.json', vim.loop.cwd())

--   if not tslint_config then
--     return {}
--   end

--   local typescript_config = vim.fn.findfile('tsconfig.json', vim.loop.cwd())
--   local args = typescript_config and {
--     '--format',
--     'json',
--     '--project',
--     typescript_config,
--   } or { '--format', 'json' }

--   return {
--     cmd = 'tslint',
--     stdin = false,
--     args = args,
--     stream = 'both',
--     ignore_exitcode = true,
--     parser = tslint_parser,
--   }
-- end
