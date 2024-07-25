local keymap = vim.keymap

-- Aerial ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
require('aerial').setup({
	backends = { 'lsp', 'treesitter', 'markdown', 'man' },
	layout = {
		min_width = { 40, 0.2 },
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
		keymap.set('n', '[a', '<cmd>AerialPrev<CR>', { buffer = bufnr, desc = 'Outline previous item' })
		keymap.set('n', ']a', '<cmd>AerialNext<CR>', { buffer = bufnr, desc = 'Outline next item' })
	end,
	show_guides = true,
})

-- You probably also want to set a keymap to toggle aerial
keymap.set('n', '<leader>at', '<cmd>AerialToggle!<CR>', { desc = 'Toggle Aerial' })
