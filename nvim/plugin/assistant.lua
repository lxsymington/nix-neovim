local copilot = require('copilot')
local codecompanion = require('codecompanion')
local mcphub = require('mcphub')

local g = vim.g
local keymap = vim.keymap

-- Copilot –————————————————————————————————————————————————————————————————————
copilot.setup({
	suggestion = { enabled = true, auto_trigger = false },
	panel = { enabled = true },
})

-- MCP Hub –————————————————————————————————————————————————————————————————————
mcphub.setup({
	ui = {
		window = {
			width = 120, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
			height = 60, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
		},
	},
})

-- Copilot Auto Suggestions –———————————————————————————————————————————————————
g.copilot_no_tab_map = true
g.copilot_hide_during_completion = 0
g.copilot_proxy_strict_ssl = 0
codecompanion.setup({
	display = {
		action_pallete = {
			width = 100,
			height = 30,
			provider = 'telescope', -- default|telescope|mini_pick
			opts = {
				show_preset_actions = true, -- Show the default actions in the action palette?
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
	extensions = {
		mcphub = {
			callback = 'mcphub.extensions.codecompanion',
			opts = {
				show_result_in_chat = true, -- Show mcp tool results in chat
				-- CC v19 compatibility
				make_vars = false, -- Convert resources to #variables
				make_slash_commands = true, -- Add prompts as /slash commands
			},
		},
		spinner = {},
	},
	interactions = {
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

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
vim.cmd([[cab cca CodeCompanionActions]])
vim.cmd([[cab ccc CodeCompanionChat]])
