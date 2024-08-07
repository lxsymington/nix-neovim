local dressing = require('dressing')
local noice = require('noice')
local icons = require('mini.icons')
local hipatterns = require('mini.hipatterns')

-- Dressing ——————————————————————————————————————————————————————————————————
dressing.setup({
	input = {
		insert_only = false,
	},
})

-- Noice —————————————————————————————————————————————————————————————————————
noice.setup({
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			['vim.lsp.util.convert_input_to_markdown_lines'] = true,
			['vim.lsp.util.stylize_markdown'] = true,
			['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
		},
	},
	-- you can enable a preset for easier configuration
	presets = {
		bottom_search = true, -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = true, -- add a border to hover docs and signature help
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
