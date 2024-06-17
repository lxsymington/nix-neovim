local lint = require('lint')

-- Exit if the language server isn't available
if vim.fn.executable('nil') ~= 1 then
	return
end

local root_files = {
	'flake.nix',
	'default.nix',
	'shell.nix',
	'.git',
}

vim.lsp.start({
	name = 'nil_ls',
	cmd = { 'nil' },
	root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
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
