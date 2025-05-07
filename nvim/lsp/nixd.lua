vim.lsp.config('nixd', {
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
