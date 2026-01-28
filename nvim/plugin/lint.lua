local api = vim.api
local lint = require('lint')

-- Linting –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
local lint_group = api.nvim_create_augroup('lint', { clear = true })
api.nvim_create_autocmd({
	'FileReadPost',
	'InsertLeave',
	'BufWritePost',
	'TextChanged',
	'ModeChanged',
	'FocusGained',
}, {
	group = lint_group,
	callback = function()
		lint.try_lint()
	end,
})
