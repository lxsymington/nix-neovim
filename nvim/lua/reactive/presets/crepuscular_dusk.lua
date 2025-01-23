local create_highlights = require('reactive.presets')

package.loaded['lxs.crepuscular.colours'] = nil
local colours = require('lxs.crepuscular.colours')

local dark = colours.dark
local modes = create_highlights(dark)

return {
	name = 'crepuscular_dusk',
	init = function()
		-- making our cursor to use `MyCursor` highlight group
		vim.opt_local.guicursor:append({
			['a'] = 'MyCursor/MylCursor',
		})
	end,
	lazy = true,
	modes = modes,
	static = {
		winhl = {
			active = {
				CursorLine = {
					bg = dark.standard.background.mix(dark.bright.grey, 20).hex,
				},
			},
			inactive = {
				CursorLine = {
					bg = dark.standard.background.mix(dark.bright.grey, 10).hex,
				},
			},
		},
		hl = {
			MyCursor = {
				bg = dark.standard.background.mix(dark.bright.grey, 40).hex,
			},
		},
	},
}
