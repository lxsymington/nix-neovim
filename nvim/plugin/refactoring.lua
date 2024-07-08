local refactoring = require('refactoring')
local lspconfig = require('lspconfig')

-- Refactoring –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
require('refactoring').setup({})

-- prompt for a refactor to apply when the remap is triggered
vim.keymap.set({ 'n', 'x' }, '<leader>rr', function()
	refactoring.select_refactor()
end, { desc = 'Select refactor' })
-- Note that not all refactor support both normal and visual mode

if vim.fn.executable('ast-grep') == 1 then
	lspconfig.ast_grep.setup({
		name = 'ast_grep',
		capabilities = require('lxs.lsp').make_client_capabilities(),
	})
end
