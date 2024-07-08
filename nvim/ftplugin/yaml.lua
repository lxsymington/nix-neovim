local schemastore = require('schemastore')
local lspconfig = require('lspconfig')

-- YAML Configuration ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
lspconfig.yamlls.setup({
	name = 'yamlls',
	capabilities = require('lxs.lsp').make_client_capabilities(),
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
