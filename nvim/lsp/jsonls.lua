local schemastore = require('schemastore')

return {
	cmd = 'jsonls',
	on_attach = require('lxs.lsp').attach,
	settings = {
		json = {
			schemas = schemastore.json.schemas(),
			validate = { enable = true },
		},
	},
}
