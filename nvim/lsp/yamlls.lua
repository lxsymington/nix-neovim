local schemastore = require('schemastore')

vim.lsp.config('yamlls', {
	on_attach = require('lxs.lsp').attach,
	settings = {
		yaml = {
			schemaStore = {
				-- You must disable built-in schemaStore support if you want to use
				-- this plugin and its advanced options like `ignore`.
				enable = false,
				-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
				url = '',
			},
			schemas = schemastore.yaml.schemas(),
		},
	},
})
