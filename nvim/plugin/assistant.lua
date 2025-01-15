local copilot = require('copilot')
local codecompanion = require('codecompanion')

local g = vim.g
local keymap = vim.keymap

-- Copilot –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
copilot.setup({
	suggestion = { enabled = true, auto_trigger = false },
	panel = { enabled = true },
})

-- Copilot Auto Suggestions –––––––––––––––––––––––––––––––––––––––––––––
g.copilot_no_tab_map = true
g.copilot_hide_during_completion = 0
g.copilot_proxy_strict_ssl = 0
codecompanion.setup({
	display = {
		action_pallete = {
			width = 80,
			height = 15,
			prompt = 'Prompt ', -- Prompt used for interactive LLM calls
			provider = 'telescope', -- default|telescope|mini_pick
			opts = {
				show_default_actions = true, -- Show the default actions in the action palette?
				show_default_prompt_library = true, -- Show the default prompt library in the action palette?
			},
		},
		chat = {
			window = {
				layout = 'vertical', -- float|vertical|horizontal|buffer
				border = 'single',
				height = 1,
				width = 80,
				opts = {
					breakindent = true,
					cursorcolumn = false,
					cursorline = false,
					foldcolumn = '0',
					linebreak = true,
					list = false,
					numberwidth = 1,
					signcolumn = 'no',
					spell = false,
					wrap = true,
				},
			},
		},
	},
	strategies = {
		inline = {
			keymaps = {
				accept_change = {
					modes = { n = 'gaa' },
					description = 'Accept the suggested change',
				},
				reject_change = {
					modes = { n = 'gar' },
					description = 'Reject the suggested change',
				},
			},
		},
	},
})

keymap.set({ 'n', 'v' }, 'gax', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true })
keymap.set(
	{ 'n', 'v' },
	'gat',
	'<cmd>CodeCompanionChat Toggle<cr>',
	{ noremap = true, silent = true }
)
keymap.set('v', 'gaa', '<cmd>CodeCompanionChat Add<cr>', { noremap = true, silent = true })

-- Expand 'chat' into 'CodeCompanion' in the command line
vim.cmd([[cab chat CodeCompanion]])
