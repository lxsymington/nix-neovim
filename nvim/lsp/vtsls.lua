-- If the lsp setup is taken over by other plugin, it is the same to call the counterpart setup function
vim.lsp.config('vtsls', {
	capabilities = require('lxs.lsp').make_client_capabilities(),
	on_attach = require('lxs.lsp').attach,
	settings = {
		typescript = {
			inlayHints = {
				parameterNames = { enabled = 'literals' },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				enumMemberValues = { enabled = true },
			},
		},
	},
})
