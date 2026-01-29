local schemastore = require('schemastore')

---@type vim.lsp.Config
return {
	on_attach = require('lxs.lsp').attach,
	settings = {
		json = {
			schemas = schemastore.json.schemas(),
			validate = { enable = true },
		},
	},
}
