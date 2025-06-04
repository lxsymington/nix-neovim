local copilot = require('copilot')
local codecompanion = require('codecompanion')
local adapters = require('codecompanion.adapters')
local config = require('codecompanion.config')
local constants = config.config.constants
local mcp_hub = require('mcphub')
local assistant_progress = require('lxs.assistant_progress')

local g = vim.g
local keymap = vim.keymap

-- Copilot –————————————————————————————————————————————————————————————————————
copilot.setup({
	suggestion = { enabled = true, auto_trigger = false },
	panel = { enabled = true },
})

-- MCP Hub –————————————————————————————————————————————————————————————————————
mcp_hub.setup({
	ui = {
		window = {
			width = 120, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
			height = 60, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
			align = 'center', -- "center", "top-left", "top-right", "bottom-left", "bottom-right", "top", "bottom", "left", "right"
			relative = 'editor',
			zindex = 50,
			border = 'rounded', -- "none", "single", "double", "rounded", "solid", "shadow"
		},
		wo = { -- window-scoped options (vim.wo)
			winhl = 'Normal:MCPHubNormal,FloatBorder:MCPHubBorder',
		},
	},
})

-- Copilot Auto Suggestions –———————————————————————————————————————————————————
g.copilot_no_tab_map = true
g.copilot_hide_during_completion = 0
g.copilot_proxy_strict_ssl = 0
codecompanion.setup({
	adapters = {
		copilot = function()
			return adapters.extend('copilot', {
				schema = {
					model = {
						default = 'claude-3.7-sonnet',
					},
				},
			})
		end,
	},
	display = {
		action_pallete = {
			width = 100,
			height = 30,
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
	extensions = {
		mcp_hub = {
			callback = 'mcphub.extensions.codecompanion',
			opts = {
				show_result_in_chat = true, -- Show mcp tool results in chat
				make_vars = true, -- Convert resources to #variables
				make_slash_commands = true, -- Add prompts as /slash commands
			},
		},
	},
	prompt_library = {
		['Code workflow'] = {
			strategy = 'workflow',
			description = 'Use a workflow to guide an LLM in writing code',
			opts = {
				index = 4,
				is_default = true,
				short_name = 'cw',
			},
			prompts = {
				{
					-- We can group prompts together to make a workflow
					-- This is the first prompt in the workflow
					-- Everything in this group is added to the chat buffer in one batch
					{
						role = constants.SYSTEM_ROLE,
						content = function(context)
							return string.format(
								"You carefully provide accurate, factual, thoughtful, nuanced answers, and are brilliant at reasoning. If you think there might not be a correct answer, you say so. Always spend a few sentences explaining background context, assumptions, and step-by-step thinking BEFORE you try to answer a question. Don't be verbose in your answers, but do provide details and examples where it might help the explanation. You are an expert software engineer for the %s language",
								context.filetype
							)
						end,
						opts = {
							visible = false,
						},
					},
					{
						role = constants.USER_ROLE,
						content = 'I want you to ',
						opts = {
							auto_submit = false,
						},
					},
				},
				-- This is the second group of prompts
				{
					{
						role = constants.USER_ROLE,
						content = "Great. Now let's consider your code. I'd like you to check it carefully for correctness, style, and efficiency, and give constructive criticism for how to improve it.",
						opts = {
							auto_submit = false,
						},
					},
				},
				-- This is the final group of prompts
				{
					{
						role = constants.USER_ROLE,
						content = "Thanks. Now let's revise the code based on the feedback, without additional explanations.",
						opts = {
							auto_submit = false,
						},
					},
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

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
vim.cmd([[cab cca CodeCompanionActions]])
vim.cmd([[cab ccc CodeCompanionChat]])

assistant_progress:init()
