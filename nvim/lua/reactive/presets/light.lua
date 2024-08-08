local create_highlights = require('reactive.presets')

package.loaded['lxs.' .. vim.g.colors_name .. '.colours'] = nil
local colours = require('lxs.' .. vim.g.colors_name .. '.colours')

local light = colours.light
local modes = create_highlights(light), 
vim.print(modes)

return {
	name = 'light',
	init = function()
		-- making our cursor to use `MyCursor` highlight group
		vim.opt_local.guicursor:append({
			['a'] = 'blinkwait700-blinkoff400-blinkon250-MyCursor/MylCursor',
		})
	end,
	lazy = true,
	modes = modes,
}
