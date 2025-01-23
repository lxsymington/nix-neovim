local M = {}

package.loaded['lxs.crepuscular.colours'] = nil
local colours = require('lxs.crepuscular.colours')
local dark = colours.dark

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
		foreground = dark.standard.foreground.hex,
		background = dark.standard.background.hex,
		blue = dark.standard.blue.hex,
		cyan = dark.standard.cyan.hex,
		green = dark.standard.green.hex,
		magenta = dark.standard.purple.hex,
		yellow = dark.standard.yellow.hex,
		accent = {
			foreground = dark.standard.foreground.hex,
			background = dark.bright.background.hex,
			blue = dark.bright.blue.hex,
			cyan = dark.bright.cyan.hex,
			green = dark.bright.green.hex,
			magenta = dark.bright.purple.hex,
			red = dark.bright.red.hex,
			yellow = dark.bright.yellow.hex,
		},
	}
	-- set the values here
	return color
end

return M
