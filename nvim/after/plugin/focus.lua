local vimade = require('vimade')
local screenkey = require('screenkey')
local truezen = require('true-zen')
package.loaded['lxs.crepuscular.colours'] = nil
local colours = require('lxs.crepuscular.colours')

local keymap = vim.keymap

local dim_foreground_rgb = colours.dim.foreground.rgb
local dim_background_rgb = colours.dim.background.rgb

-- Vimade
-- ——————————————————————————————————————————————————————————————————————
vimade.setup({
	recipe = { 'default', { animate = true } },
	fade_level = 0.3,
	basebg = {
		dim_background_rgb.r,
		dim_background_rgb.g,
		dim_background_rgb.b,
	},
	groupdiff = true,
	groupscrollbind = true,
	tint = {
		fg = {
			rgb = {
				dim_foreground_rgb.r,
				dim_foreground_rgb.g,
				dim_foreground_rgb.b,
			},
			intensity = 0.1,
		},
		bg = {
			rgb = {
				dim_background_rgb.r,
				dim_background_rgb.g,
				dim_background_rgb.b,
			},
			intensity = 0.5,
		},
		sp = {
			rgb = {
				dim_background_rgb.r,
				dim_background_rgb.g,
				dim_background_rgb.b,
			},
			intensity = 0.1,
		},
	},
	enablefocusfading = true,
	blocklist = {
		default = {
			buf_name = {
				'Neotest Summary',
			},
		},
		link = {

			buf_name = {
				'DAP Breakpoints',
				'DAP Scopes',
				'DAP Stacks',
				'DAP Watches',
			},
		},
	},
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
			vim.notify_once('enabled', vim.log.levels.INFO, {
				title = 'Focus Mode',
				timeout = 500,
			})
		end)
	end)
end

callbacks.open_pos = function()
	vim.cmd.Screenkey('toggle')
	vim.cmd.VimadeFocus()
end
callbacks.close_pre = function()
	vim.cmd.Screenkey('toggle')
	vim.cmd.VimadeFocus()
end

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
			vim.notify_once('disabled', vim.log.levels.INFO, {
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
