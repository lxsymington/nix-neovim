vim.lsp.config('nixd', {
	capabilities = require('lxs.lsp').make_client_capabilities(),
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
})
