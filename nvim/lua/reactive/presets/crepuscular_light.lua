local create_highlights = require('reactive.presets')

package.loaded['lxs.' .. vim.g.colors_name .. '.colours'] = nil
local colours = require('lxs.' .. vim.g.colors_name .. '.colours')

local light = colours.light
local modes = create_highlights(light)

return {
	name = 'crepuscular_light',
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
					bg = light.standard.white.mix(light.bright.grey, 20).hex,
				},
			},
			inactive = {
				CursorLine = {
					bg = light.standard.white.mix(light.bright.grey, 10).hex,
				},
			},
		},
		hl = {
			MyCursor = {
				bg = light.standard.white.mix(light.bright.grey, 40).hex,
			},
		},
	},
}
