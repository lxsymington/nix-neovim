local reactive = require('reactive')
local api = vim.api
local cmd = vim.cmd
local g = vim.g
local opt = vim.opt

-- Reactive ————————————————————————————————————————————————————————————————————
opt.guicursor = {
	['n-v-c'] = 'block',
	['i-ci-ve'] = 'ver25',
	['r-cr'] = 'hor20',
	['o'] = 'hor50',
	['a'] = 'blinkwait700-blinkoff400-blinkon250-Cursor/lCursor',
	['sm'] = 'block-blinkwait175-blinkoff150-blinkon175',
}

local background = {
	current = vim.opt.background:get(),
}

reactive.setup({
	builtin = {
		modemsg = true,
	},
	configs = {
		crepuscular_dark = true,
		crepuscular_light = true,
	},
	load = { g.colors_name .. '_' .. opt.background:get() },
})

local reactive_group = api.nvim_create_augroup('Reactive', {
	clear = false,
})

api.nvim_create_autocmd({ 'OptionSet' }, {
	group = reactive_group,
	pattern = { 'background' },
	callback = function()
		cmd('Reactive disable ' .. g.colors_name .. '_' .. background.current)
		background.current = opt.background:get()
	end,
})

api.nvim_create_autocmd({ 'ColorScheme' }, {
	group = reactive_group,
	callback = function()
		reactive.setup({
			load = { g.colors_name .. '_' .. opt.background:get() },
		})
		cmd('Reactive enable ' .. g.colors_name .. '_' .. opt.background:get())
	end,
})
