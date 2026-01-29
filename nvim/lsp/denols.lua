---@type vim.lsp.Config
return {
	on_attach = require('lxs.lsp').attach,
	root_markers = { { 'deno.json', 'deno.jsonc' } },
	workspace_required = true,
}
