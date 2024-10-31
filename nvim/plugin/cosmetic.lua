local dressing = require('dressing')
local icons = require('mini.icons')
local hipatterns = require('mini.hipatterns')
local satellite = require('satellite')

-- Dressing ——————————————————————————————————————————————————————————————————
dressing.setup({
	input = {
		insert_only = false,
	},
})

-- Icons —————————————————————————————————————————————————————————————————————
icons.setup()
icons.mock_nvim_web_devicons()

-- Highlight Patterns ——————————————————————————————————————————————————————————
hipatterns.setup({
	highlighters = {
		-- Highlight hex color strings (`#rrggbb`) using that colour
		hex_color = hipatterns.gen_highlighter.hex_color({
			style = 'inline',
			inline_text = '⬤  ',
		}),
	},
})

-- Satellite —————————————————————————————————————————————————————————————————
satellite.setup({
	current_only = true,
})
