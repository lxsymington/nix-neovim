local screenkey = require('screenkey')
local twilight = require('twilight')
local truezen = require('true-zen')

local keymap = vim.keymap

-- Twilight ————————————————————————————————————————————————————————————————————
twilight.setup({
	dimming = {
		alpha = 0.25, -- amount of dimming
		-- we try to get the foreground from the highlight groups or fallback color
		color = { 'Normal', '#ffffff' },
	},
	context = 30, -- amount of lines we will try to show around the current line
	treesitter = true, -- use treesitter when available for the filetype
	-- treesitter is used to automatically expand the visible text,
	-- but you can further control the types of nodes that should always be fully expanded
	expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
		'function',
		'method',
		'table',
		'if_statement',
	},
	exclude = {}, -- exclude these filetypes
})

-- Zen Mode ————————————————————————————————————————————————————————————————————
local callbacks = {}
function callbacks.open_pre()
	vim.system({
		'alacritty',
		'msg',
		'config',
		'font.size=20',
	}, {}, function()
		vim.system({
			'tmux',
			'resize-pane',
			'-Z',
		}, {}, function()
			vim.notify_once('enabled', 'info', {
				title = 'Focus Mode',
				timeout = 500,
			})
		end)
	end)
end

callbacks.open_pos = screenkey.toggle
callbacks.close_pre = screenkey.toggle

callbacks.close_pos = function()
	vim.system({
		'alacritty',
		'msg',
		'config',
		'-r',
	}, {}, function()
		vim.system({
			'tmux',
			'resize-pane',
			'-Z',
		}, {}, function()
			vim.notify_once('disabled', 'info', {
				title = 'Focus Mode',
				timeout = 500,
			})
		end)
	end)
end

truezen.setup({
	modes = {
		ataraxis = {
			shade = vim.opt.background:get(),
			backdrop = 0.5,
			minimum_writing_area = {
				width = 80,
				height = 30,
			},
			callbacks = callbacks,
		},
		minimalist = {
			callbacks = callbacks,
		},
	},
	integrations = {
		kitty = {
			enabled = true,
			font = '+4',
		},
		tmux = true,
		twilight = true,
	},
})

keymap.set('n', '<leader>zn', function()
	local first = 0
	local last = vim.api.nvim_buf_line_count(0)
	truezen.narrow(first, last)
end, {
	desc = 'True[z]en [n]arrow',
	noremap = true,
})
keymap.set('v', '<leader>zn', function()
	local first = vim.fn.line('v')
	local last = vim.fn.line('.')
	truezen.narrow(first, last)
end, {
	desc = 'True[z]en [n]arrow',
	noremap = true,
})
keymap.set('n', '<leader>zf', truezen.focus, {
	desc = 'True[z]en [f]ocus',
	noremap = true,
})
keymap.set('n', '<leader>zm', truezen.minimalist, {
	desc = 'True[z]en [m]inimalist',
	noremap = true,
})
keymap.set('n', '<leader>za', truezen.ataraxis, {
	desc = 'True[z]en [a]taraxis',
	noremap = true,
})

-- ScreenKey ———————————————————————————————————————————————————————————————————
screenkey.setup({
	group_mappings = true,
	show_leader = true,
})
