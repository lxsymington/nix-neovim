local schemastore = require('schemastore')

vim.lsp.config('jsonls', {
	capabilities = require('lxs.lsp').make_client_capabilities(),
	on_attach = require('lxs.lsp').attach,
	settings = {
		json = {
			schemas = schemastore.json.schemas(),
			validate = { enable = true },
		},
	},
})
