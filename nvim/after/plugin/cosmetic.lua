local reactive = require('reactive')

-- Reactive ————————————————————————————————————————————————————————————————————
package.loaded['lxs.' .. vim.g.colors_name .. '.colours'] = nil
local colours = require('lxs.' .. vim.g.colors_name .. '.colours')
local theme = vim.opt.background:get()

local dark = colours.dark
local light = colours.light

vim.opt.guicursor = {
	['n-v-c'] = 'block',
	['i-ci-ve'] = 'ver25',
	['r-cr'] = 'hor20',
	['o'] = 'hor50',
	['a'] = 'blinkwait700-blinkoff400-blinkon250-Cursor/lCursor',
	['sm'] = 'block-blinkwait175-blinkoff150-blinkon175',
}

local function create_highlights(variant)
	return {
		n = {
			winhl = {
				CursorLine = {
					bg = variant.standard.black.mix(variant.bright.purple, 20).hex,
				},
			},
			hl = {
				MyCursor = {
					bg = variant.standard.black.mix(variant.bright.purple, 40).hex,
				},
			},
		},
		no = {
			winhl = {},
			hl = {},
			operators = {
				d = {
					winhl = {
						CursorLine = {
							bg = variant.standard.black.mix(variant.bright.red, 20).hex,
						},
					},
					hl = {
						MyCursor = {
							bg = variant.standard.black.mix(variant.bright.red, 20).hex,
						},
					},
				},
				y = {
					winhl = {
						CursorLine = {
							bg = variant.standard.black.mix(variant.bright.yellow, 20).hex,
						},
					},
					hl = {
						MyCursor = {
							bg = variant.standard.black.mix(variant.bright.yellow, 40).hex,
						},
					},
				},
			},
		},
		i = {
			winhl = {
				CursorLine = {
					bg = variant.standard.black.mix(variant.bright.green, 20).hex,
				},
			},
			hl = {
				MyCursor = {
					bg = variant.standard.black.mix(variant.bright.green, 40).hex,
				},
			},
		},
		[{ 's', 'S', '\x13' }] = {
			winhl = {
				CursorLine = {
					bg = variant.standard.black.mix(variant.bright.orange, 20).hex,
				},
			},
			hl = {
				MyCursor = {
					bg = variant.standard.black.mix(variant.bright.orange, 40).hex,
				},
			},
		},
		[{ 'v', 'V', '\x16' }] = {
			winhl = {
				CursorLine = {
					bg = variant.standard.black.mix(variant.bright.cyan, 20).hex,
				},
			},
			hl = {
				MyCursor = {
					bg = variant.standard.black.mix(variant.bright.cyan, 40).hex,
				},
			},
		},
	}
end

reactive.add_preset({
	name = 'dark',
	init = function()
		-- making our cursor to use `MyCursor` highlight group
		vim.opt_local.guicursor:append({
			['a'] = 'blinkwait700-blinkoff400-blinkon250-MyCursor/MylCursor',
		})
	end,
	modes = create_highlights(dark),
})

reactive.add_preset({
	name = 'light',
	init = function()
		-- making our cursor to use `MyCursor` highlight group
		vim.opt_local.guicursor:append({
			['a'] = 'blinkwait700-blinkoff400-blinkon250-MyCursor/MylCursor',
		})
	end,
	modes = create_highlights(light),
})

reactive.setup({
	builtin = {
		cursorline = true,
		cursor = true,
		modemsg = true,
	},
	configs = {
		dark = theme == 'dark',
		light = theme == 'light',
	},
})
