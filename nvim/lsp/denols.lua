vim.lsp.config('denols', {
	on_attach = require('lxs.lsp').attach,
	root_markers = { { 'deno.json', 'deno.jsonc' } },
	workspace_required = true,
})
