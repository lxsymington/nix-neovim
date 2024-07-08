local schemastore = require('schemastore')
local lspconfig = require('lspconfig')

-- JSON Configuration ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
if vim.fn.executable('vscode-json-languageserver') == 1 then
	lspconfig.json.setup({
		name = 'jsonls',
		capabilities = require('lxs.lsp').make_client_capabilities(),
		settings = {
			json = {
				schemas = schemastore.json.schemas(),
				validate = { enable = true },
			},
		},
	})
end
