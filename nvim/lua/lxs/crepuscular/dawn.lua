package.loaded['lxs.crepuscular.colours'] = nil
local colours = require('lxs.crepuscular.colours')

package.loaded['lxs.crepuscular.theme'] = nil
local theme = require('lxs.crepuscular.theme')

local palette_metatable = {
	__index = function(self, key)
		if key == 'foreground' then
			return rawget(self, 'black')
		end

		if key == 'background' then
			return rawget(self, 'white')
		end

		return rawget(self, key)
	end,
}

local bright = setmetatable(colours.light.bright, palette_metatable)
local dim = setmetatable(colours.light.dim, palette_metatable)
local standard = setmetatable(colours.light.standard, palette_metatable)

return theme(bright, dim, standard)
