local reactive = require('reactive')
local api = vim.api
local cmd = vim.cmd
local opt = vim.opt

-- Reactive ————————————————————————————————————————————————————————————————————
--[[ opt.guicursor = {
	['n-v-c'] = 'block',
	['i-ci-ve'] = 'ver25',
	['r-cr'] = 'hor20',
	['o'] = 'hor50',
	['a'] = 'blinkwait700-blinkoff400-blinkon250-Cursor/lCursor',
	['sm'] = 'block-blinkwait175-blinkoff150-blinkon175',
} ]]

local preset = setmetatable({
	current = opt.background:get() == 'dark' and 'crepuscular_dusk' or 'crepuscular_dawn',
}, {
	__index = function(self, key)
		if key ~= 'next' then
			return rawget(self, key)
		end

		return opt.background:get() == 'dark' and 'crepuscular_dusk' or 'crepuscular_dawn'
	end,
})

reactive.setup({
	builtin = {
		modemsg = true,
	},
	configs = {
		crepuscular_dawn = true,
		crepuscular_dusk = true,
	},
	load = {
		preset.next,
	},
})

local reactive_group = api.nvim_create_augroup('Reactive', {
	clear = false,
})

api.nvim_create_autocmd({ 'OptionSet' }, {
	group = reactive_group,
	pattern = { 'background' },
	callback = function()
		cmd('Reactive disable ' .. preset.current)
		preset.current = preset.next
	end,
})

api.nvim_create_autocmd({ 'ColorScheme' }, {
	group = reactive_group,
	callback = function()
		reactive.setup({
			load = {
				preset.next,
			},
		})
		cmd('Reactive enable ' .. preset.next)
	end,
})
