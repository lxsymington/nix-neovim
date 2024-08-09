local create_highlights = require('reactive.presets')

package.loaded['lxs.' .. vim.g.colors_name .. '.colours'] = nil
local colours = require('lxs.' .. vim.g.colors_name .. '.colours')

local dark = colours.dark
local modes = create_highlights('dark', dark)

return {
	name = 'crepuscular_dark',
	init = function()
		-- making our cursor to use `MyCursor` highlight group
		vim.opt_local.guicursor:append({
			['a'] = 'blinkwait700-blinkoff400-blinkon250-MyCursor/MylCursor',
		})
	end,
	lazy = true,
	modes = modes,
	static = {
		winhl = {
			active = {
				CursorLine = {
					bg = dark.standard.black.mix(dark.bright.grey, 20).hex,
				},
			},
			inactive = {
				CursorLine = {
					bg = dark.standard.black.mix(dark.bright.grey, 10).hex,
				},
			},
		},
		hl = {
			MyCursor = {
				bg = dark.standard.black.mix(dark.bright.grey, 40).hex,
			},
		},
	},
}
