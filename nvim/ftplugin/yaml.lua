local schemastore = require('schemastore')

-- YAML Configuration ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
local root_files = {
	'.git',
}

vim.lsp.start({
	name = 'yamlls',
	cmd = { 'yaml-language-server' },
	root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
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
			schemas = require('schemastore').yaml.schemas(),
		},
	},
})
