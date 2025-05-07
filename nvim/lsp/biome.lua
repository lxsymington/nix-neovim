vim.lsp.config('biome', {
	on_attach = require('lxs.lsp').attach,
	root_markers = { { 'biome.json', 'biome.jsonc' } },
	workspace_required = true,
})
