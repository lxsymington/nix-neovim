-- Aerial ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
require('aerial').setup({
	backends = { 'lsp', 'treesitter', 'markdown', 'man' },
	layout = {
		min_width = { 20, 0.1 },
	},
	ignore = {
		unlisted_buffers = false,
		filetypes = {},
		buftypes = 'special',
		wintypes = 'special',
	},
	link_folds_to_tree = true,
	link_tree_to_folds = true,
	-- optionally use on_attach to set keymaps when aerial has attached to a buffer
	on_attach = function(bufnr)
		-- Jump forwards/backwards with '{' and '}'
		vim.keymap.set('n', '[a', '<cmd>AerialPrev<CR>', { buffer = bufnr })
		vim.keymap.set('n', ']a', '<cmd>AerialNext<CR>', { buffer = bufnr })
	end,
	show_guides = true,
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
