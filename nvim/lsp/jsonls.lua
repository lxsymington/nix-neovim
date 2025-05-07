local schemastore = require('schemastore')

vim.lsp.config('jsonls', {
	on_attach = require('lxs.lsp').attach,
	settings = {
		json = {
			schemas = schemastore.json.schemas(),
			validate = { enable = true },
		},
	},
})
