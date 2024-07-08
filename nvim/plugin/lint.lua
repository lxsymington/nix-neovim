local api = vim.api
local lint = require('lint')

-- Linting –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
local lint_group = api.nvim_create_augroup('lint', { clear = true })
api.nvim_create_autocmd({
	'FileReadPost',
	'InsertLeave',
	'BufWritePost',
	'TextChanged',
	'ModeChanged',
	'FocusGained',
}, {
	group = lint_group,
	callback = function()
		lint.try_lint()
	end,
})

if vim.fn.executable('biome') == 1 then
	require('lspconfig').biome.setup({
		name = 'biome',
		capabilities = require('lxs.lsp').make_client_capabilities(),
	})
end
