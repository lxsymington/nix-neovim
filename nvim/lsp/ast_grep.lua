vim.lsp.config('ast_grep', {
	on_attach = require('lxs.lsp').attach,
	root_markers = { { 'sgconfig.yml' } },
	workspace_required = true,
})
