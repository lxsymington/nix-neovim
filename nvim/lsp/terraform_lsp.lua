vim.lsp.config('terraform_lsp', {
	capabilities = require('lxs.lsp').make_client_capabilities(),
	on_attach = require('lxs.lsp').attach,
})
