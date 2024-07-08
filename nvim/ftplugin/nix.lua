local lint = require('lint')
local lspconfig = require('lspconfig')

-- Exit if the language server isn't available
if vim.fn.executable('nil') ~= 1 then
	return
end

lspconfig.nil_ls.setup({
	name = 'nil_ls',
	capabilities = require('lxs.lsp').make_client_capabilities(),
})

lint.linters_by_ft = {
	nix = { 'deadnix', 'nix', 'statix' },
}

local deadnixNs = lint.get_namespace('deadnix')
vim.diagnostic.config({
	virtual_text = {
		suffix = ' 🚩 deadnix',
	},
}, deadnixNs)

local nixNs = lint.get_namespace('nix')
vim.diagnostic.config({
	virtual_text = {
		suffix = ' 🚩 nix',
	},
}, nixNs)

local statixNs = lint.get_namespace('statix')
vim.diagnostic.config({
	virtual_text = {
		suffix = ' 🚩 statix',
	},
}, statixNs)
