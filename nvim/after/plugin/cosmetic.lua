local reactive = require('reactive')

-- Reactive ————————————————————————————————————————————————————————————————————
vim.opt.guicursor = {
	['n-v-c'] = 'block',
	['i-ci-ve'] = 'ver25',
	['r-cr'] = 'hor20',
	['o'] = 'hor50',
	['a'] = 'blinkwait700-blinkoff400-blinkon250-Cursor/lCursor',
	['sm'] = 'block-blinkwait175-blinkoff150-blinkon175',
}

reactive.setup({
	builtin = {
		cursorline = true,
		cursor = true,
		modemsg = true,
	},
	configs = {
		dark = true,
		light = true,
	},
	load = { vim.opt.background:get() },
})

vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
	group = vim.api.nvim_create_augroup('Reactive', {
		clear = false,
	}),
	callback = function()
		reactive.setup({
			load = { vim.opt.background:get() },
		})
	end,
})
