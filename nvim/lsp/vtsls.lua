return {
	cmd = 'vtsls',
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
	root_markers = { 'tsconfig.json', 'package.json' },
	workspace_required = true,
}
