local lint = require('lint')
local icons = require('mini.icons')

-- Exit if the language server isn't available
if vim.fn.executable('nixd') ~= 1 then
	return
end

lint.linters_by_ft = {
	nix = { 'deadnix', 'nix', 'statix' },
}

local icon, _hl, _is_default = icons.get('file', vim.fn.expand('%'))
local deadnixNs = lint.get_namespace('deadnix')
vim.diagnostic.config(
	vim.tbl_deep_extend('force', vim.diagnostic.config(), {
		virtual_text = {
			suffix = string.format(' ⁅%s deadnix⁆', icon),
		},
	}),
	deadnixNs
)

local nixNs = lint.get_namespace('nix')
vim.diagnostic.config(
	vim.tbl_deep_extend('force', vim.diagnostic.config(), {
		virtual_text = {
			suffix = string.format(' ⁅%s nix⁆', icon),
		},
	}),
	nixNs
)

local statixNs = lint.get_namespace('statix')
vim.diagnostic.config(
	vim.tbl_deep_extend('force', vim.diagnostic.config(), {
		virtual_text = {
			suffix = string.format(' ⁅%s statix⁆', icon),
		},
	}),
	statixNs
)
