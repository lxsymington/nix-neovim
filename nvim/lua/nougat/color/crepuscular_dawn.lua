local M = {}

package.loaded['lxs.crepuscular.colours'] = nil
local colours = require('lxs.crepuscular.colours')
local light = colours.light

--[[ color.red
color.accent.blue
color.accent.cyan
color.accent.green
color.accent.magenta
color.accent.red
color.accent.yellow
color.blue
color.cyan
color.green
color.magenta
color.yellow

color.bg
color.accent.bg
color.bg0
color.bg1
color.bg2
color.bg3
color.bg4

color.fg
color.accent.fg
color.fg0
color.fg1
color.fg2
color.fg3
color.fg4 ]]

function M.get()
	---@class nougat.color.crepuscular_dawn: nougat.color
	local color = {
		foreground = light.standard.foreground.hex,
		background = light.standard.background.hex,
		blue = light.standard.blue.hex,
		cyan = light.standard.cyan.hex,
		green = light.standard.green.hex,
		magenta = light.standard.purple.hex,
		yellow = light.standard.yellow.hex,
		accent = {
			foreground = light.standard.foreground.hex,
			background = light.bright.background.hex,
			blue = light.bright.blue.hex,
			cyan = light.bright.cyan.hex,
			green = light.bright.green.hex,
			magenta = light.bright.purple.hex,
			red = light.bright.red.hex,
			yellow = light.bright.yellow.hex,
		},
	}
	-- set the values here
	return color
end

return M
