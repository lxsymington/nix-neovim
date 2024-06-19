local screenkey = require('screenkey')
local twilight = require('twilight')
local zenmode = require('zen-mode')
local api = vim.api
local cmd = vim.cmd

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
zenmode.setup({
	window = {
		backdrop = 0.5, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
		-- height and width can be:
		-- * an absolute number of cells when > 1
		-- * a percentage of the width / height of the editor when <= 1
		-- * a function that returns the width or the height
		width = 100, -- width of the Zen window
		height = 1, -- height of the Zen window
		-- by default, no options are changed for the Zen window
		-- uncomment any of the options below, or add other vim.wo options you want to apply
		options = {
			signcolumn = false, -- disable signcolumn
			number = false, -- disable number column
			relativenumber = false, -- disable relative numbers
			cursorline = false, -- disable cursorline
			cursorcolumn = false, -- disable cursor column
			foldcolumn = true, -- disable fold column
			list = true, -- disable whitespace characters
		},
	},
	plugins = {
		-- disable some global vim options (vim.o...)
		-- comment the lines to not apply the options
		options = {
			enabled = true,
			ruler = true, -- disables the ruler text in the cmd line area
			showcmd = true, -- disables the command in the last line of the screen
			-- you may turn on/off statusline in zen mode by setting 'laststatus'
			-- statusline will be shown only if 'laststatus' == 3
			laststatus = 0, -- turn off the statusline in zen mode
		},
		twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
		gitsigns = { enabled = false }, -- disables git signs
		tmux = { enabled = true }, -- disables the tmux statusline
		-- this will change the font size on kitty when in zen mode
		-- to make this work, you need to set the following kitty options:
		-- - allow_remote_control socket-only
		-- - listen_on unix:/tmp/kitty
		kitty = {
			enabled = true,
			font = '+4', -- font size increment
		},
		-- this will change the font size on alacritty when in zen mode
		-- requires  Alacritty Version 0.10.0 or higher
		-- uses `alacritty msg` subcommand to change font size
		alacritty = {
			enabled = true,
			font = '16', -- font size
		},
	},
	on_open = function()
		screenkey.toggle()
	end,
	on_close = function()
		screenkey.toggle()
	end,
})

-- ScreenKey ———————————————————————————————————————————————————————————————————
screenkey.setup({
	group_mappings = true,
	show_leader = true,
})
