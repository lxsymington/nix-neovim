local demicolon = require('demicolon')
local eyeliner = require('eyeliner')

local keymap = vim.keymap
local list_contains = vim.list_contains

-- Movements ———————————————————————————————————————————————————————————————————
eyeliner.setup({
	highlight_on_key = true,
	dim = true,
	default_keymaps = false,
})

demicolon.setup({
	keymaps = {
		horizontal_motions = false,
		repeat_motions = false,
	},
})

local function eyeliner_jump(key)
	local forward = list_contains({ 't', 'f' }, key)
	return function()
		eyeliner.highlight({ forward = forward })
		return require('demicolon.jump').horizontal_jump(key)()
	end
end

local ts_repeatable_move = require('nvim-treesitter.textobjects.repeatable_move')

local modes = { 'n', 'x', 'o' }
local opts = { expr = true }

keymap.set(modes, 'f', eyeliner_jump('f'), opts)
keymap.set(modes, 'F', eyeliner_jump('F'), opts)
keymap.set(modes, 't', eyeliner_jump('t'), opts)
keymap.set(modes, 'T', eyeliner_jump('T'), opts)
keymap.set(modes, ';', ts_repeatable_move.repeat_last_move)
keymap.set(modes, ',', ts_repeatable_move.repeat_last_move_opposite)
