local schemastore = require('schemastore')

-- JSON Configuration ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
local root_files = {
  '.git'
}

vim.lsp.start {
  name = 'jsonls',
  cmd = { 'vscode-json-language-server' },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  capabilities = require('lxs.lsp').make_client_capabilities(),
  settings = {
    json = {
      schemas = schemastore.json.schemas(),
      validate = { enable = true },
    }
  }
}
