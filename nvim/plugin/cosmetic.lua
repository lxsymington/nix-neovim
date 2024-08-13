local dressing = require('dressing')
local icons = require('mini.icons')
local hipatterns = require('mini.hipatterns')

-- Dressing ——————————————————————————————————————————————————————————————————
dressing.setup({
	input = {
		insert_only = false,
	},
})

-- Icons —————————————————————————————————————————————————————————————————————
icons.setup()

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
