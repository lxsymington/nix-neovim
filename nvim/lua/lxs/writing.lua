local lint = require('lint')
local icons = require('mini.icons')
local M = {}

-- Writing —————————————————————————————————————————————————————————————————————

function M.start()
	lint.linters_by_ft = {
		markdown = { 'vale' },
		org = { 'vale' },
	}

	local icon, _hl, _is_default = icons.get('file', vim.fn.expand('%'))
	local ns = lint.get_namespace('vale')
	vim.diagnostic.config(
		vim.tbl_deep_extend('force', vim.diagnostic.config(), {
			virtual_text = {
				suffix = string.format(' ⁅%s vale⁆', icon),
			},
		}),
		ns
	)
end

return M
