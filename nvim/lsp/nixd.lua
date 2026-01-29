---@type vim.lsp.Config
return {
	on_attach = require('lxs.lsp').attach,
	settings = {
		nixd = {
			nixpkgs = {
				expr = 'import <nixpkgs> { }',
			},
			formatting = {
				command = { 'alejandra' },
			},
		},
	},
}
