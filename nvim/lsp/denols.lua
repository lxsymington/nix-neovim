vim.lsp.config('denols', {
	capabilities = require('lxs.lsp').make_client_capabilities(),
	on_attach = require('lxs.lsp').attach,
	root_markers = { 'deno.json', 'deno.jsonc' },
})
