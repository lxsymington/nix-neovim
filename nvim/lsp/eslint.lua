---@type vim.lsp.Config
return {
	on_attach = require('lxs.lsp').attach,
	root_markers = {
		{
			'eslint.config.js',
			'eslint.config.mjs',
			'eslint.config.cjs',
			'eslint.config.ts',
			'eslint.config.mts',
			'eslint.config.cts',
		},
		'.eslintrc.yaml',
		'.eslintrc.yml',
		'.eslintrc.json',
	},
	workspace_required = true,
}
