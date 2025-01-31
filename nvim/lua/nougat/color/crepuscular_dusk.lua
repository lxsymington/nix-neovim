local M = {}

local colours = require('lxs.crepuscular.colours')
local dark = colours.dark

function M.get()
	---@class nougat.color.crepuscular_dawn: nougat.color
	local color = {
		fg = dark.standard.foreground.hex,
		fg0 = dark.standard.foreground.hex,
		fg1 = dark.bright.grey.hex,
		fg2 = dark.standard.grey.hex,
		fg3 = dark.dim.grey.hex,
		fg4 = dark.dim.background.hex,
		bg = dark.standard.background.hex,
		bg0 = dark.standard.background.hex,
		bg1 = dark.dim.grey.hex,
		bg2 = dark.standard.grey.hex,
		bg3 = dark.bright.grey.hex,
		bg4 = dark.dim.foreground.hex,
		blue = dark.standard.blue.hex,
		cyan = dark.standard.cyan.hex,
		green = dark.standard.green.hex,
		magenta = dark.standard.purple.hex,
		yellow = dark.standard.yellow.hex,
		accent = {
			fg = dark.dim.foreground.hex,
			bg = dark.dim.background.hex,
			blue = dark.dim.blue.hex,
			cyan = dark.dim.cyan.hex,
			green = dark.dim.green.hex,
			magenta = dark.dim.purple.hex,
			red = dark.dim.red.hex,
			yellow = dark.dim.yellow.hex,
		},
	}

	-- set the values here
	return color
end

return M
