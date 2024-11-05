local lint = require('lint')
local lspconfig = require('lspconfig')
local icons = require('mini.icons')

-- Exit if the language server isn't available
if vim.fn.executable('nil') ~= 1 then
	return
end

lspconfig.nixd.setup({
	name = 'nixd',
	capabilities = require('lxs.lsp').make_client_capabilities(),
	settings = {
		nixd = {
			nixpkgs = {
				expr = 'import <nixpkgs> { }',
			},
			formatting = {
				command = { 'nixfmt' },
			},
		},
	},
})

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
