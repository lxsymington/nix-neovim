local M = {}

local colours = require('lxs.crepuscular.colours')
local light = colours.light

function M.get()
	---@class nougat.color.crepuscular_dawn: nougat.color
	local color = {
		fg = light.standard.foreground.hex,
		fg0 = light.standard.foreground.hex,
		fg1 = light.dim.grey.hex,
		fg2 = light.standard.grey.hex,
		fg3 = light.bright.grey.hex,
		fg4 = light.dim.background.hex,
		bg = light.standard.background.hex,
		bg0 = light.standard.background.hex,
		bg1 = light.bright.grey.hex,
		bg2 = light.standard.grey.hex,
		bg3 = light.dim.grey.hex,
		bg4 = light.dim.foreground.hex,
		blue = light.standard.blue.hex,
		cyan = light.standard.cyan.hex,
		green = light.standard.green.hex,
		magenta = light.standard.purple.hex,
		yellow = light.standard.yellow.hex,
		accent = {
			fg = light.standard.foreground.hex,
			bg = light.dim.background.hex,
			blue = light.dim.blue.hex,
			cyan = light.dim.cyan.hex,
			green = light.dim.green.hex,
			magenta = light.dim.purple.hex,
			red = light.dim.red.hex,
			yellow = light.dim.yellow.hex,
		},
	}
	-- set the values here
	return color
end

return M
