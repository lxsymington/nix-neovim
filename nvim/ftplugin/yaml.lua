local lint = require('lint')

-- YAML Configuration ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

-- Add the `actionlint` linter if it is available
if vim.fn.executable('actionlint') == 1 then
	lint.linters_by_ft = {
		yaml = { 'actionlint' },
	}
end
