local marks = require('marks')
local recall = require('recall')
local fn = vim.fn
local keymap = vim.keymap

-- Marks ———————————————————————————————————————————————————————————————————————
marks.setup({
	default_mappings = true,
	builtin_marks = { '.', '<', '>', '^' },
	cyclic = true,
	force_write_shada = false,
	refresh_interval = 250,
	sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
	excluded_filetypes = {},
	excluded_buftypes = {},
	bookmark_0 = { sign = '⚑', virt_text = '🔖: 0', annotate = true },
	bookmark_1 = { sign = '⚑', virt_text = '🔖: 1', annotate = true },
	bookmark_2 = { sign = '⚑', virt_text = '🔖: 2', annotate = true },
	bookmark_3 = { sign = '⚑', virt_text = '🔖: 3', annotate = true },
	bookmark_4 = { sign = '⚑', virt_text = '🔖: 4', annotate = true },
	bookmark_5 = { sign = '⚑', virt_text = '🔖: 5', annotate = true },
	bookmark_6 = { sign = '⚑', virt_text = '🔖: 6', annotate = true },
	bookmark_7 = { sign = '⚑', virt_text = '🔖: 7', annotate = true },
	bookmark_8 = { sign = '⚑', virt_text = '🔖: 8', annotate = true },
	bookmark_9 = { sign = '⚑', virt_text = '🔖: 9', annotate = true },
})

-- Recall ——————————————————————————————————————————————————————————————————————
recall.setup({
	sign = '',
	sign_highlight = '@comment.note',

	telescope = {
		autoload = true,
		mappings = {
			unmark_selected_entry = {
				normal = 'dd',
				insert = '<M-d>',
			},
		},
	},

	wshada = fn.has('nvim-0.10') == 0,
})

keymap.set('n', 'gmm', recall.toggle, { noremap = true, silent = true })
keymap.set('n', 'gmn', recall.goto_next, { noremap = true, silent = true })
keymap.set('n', 'gmp', recall.goto_prev, { noremap = true, silent = true })
keymap.set('n', 'gmc', recall.clear, { noremap = true, silent = true })
keymap.set('n', 'gml', ':Telescope recall theme=ivy<CR>', { noremap = true, silent = true })
