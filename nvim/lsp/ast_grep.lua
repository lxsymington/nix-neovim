---@type vim.lsp.Config
return {
	on_attach = require('lxs.lsp').attach,
	root_markers = { { 'sgconfig.yml' } },
	workspace_required = true,
}
