local copilot = require('copilot')
local copilot_cmp = require('copilot_cmp')
local chat = require('CopilotChat')
local actions = require('CopilotChat.actions')
local select = require('CopilotChat.select')
local integration = require('CopilotChat.integrations.telescope')

local api = vim.api
local g = vim.g
local keymap = vim.keymap
local opt_local = vim.opt_local
local ui = vim.ui

-- Copilot –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
copilot.setup({
	suggestion = { enabled = true, auto_trigger = false },
	panel = { enabled = true },
})

copilot_cmp.setup()

-- Copilot Auto Suggestions –––––––––––––––––––––––––––––––––––––––––––––
g.copilot_no_tab_map = true
g.copilot_hide_during_completion = 0
g.copilot_proxy_strict_ssl = 0

chat.setup({
	log_level = 'warn',
	question_header = string.format(' %s ', '👤'),
	answer_header = string.format(' %s ', '🤖'),
	error_header = string.format('⟩ %s ', '⚠'),
	context = 'buffer',
	selection = select.visual,
	mappings = {
		reset = {
			normal = '',
			insert = '',
		},
	},
	prompts = {
		Explain = {
			mapping = 'gae',
			description = 'AI Explain',
		},
		Review = {
			mapping = 'gar',
			description = 'AI Review',
		},
		Tests = {
			mapping = 'gat',
			description = 'AI Tests',
		},
		Fix = {
			mapping = 'gaf',
			description = 'AI Fix',
		},
		Optimize = {
			mapping = 'gao',
			description = 'AI Optimize',
		},
		Docs = {
			mapping = 'gad',
			description = 'AI Documentation',
		},
		Commit = {
			mapping = 'gac',
			description = 'AI Generate Commit',
		},
	},
	window = {
		layout = 'vertical',
		width = 80,
	},
})

local copilot_chat = api.nvim_create_augroup('BufEnter', { clear = true })

api.nvim_create_autocmd('BufEnter', {
	pattern = 'copilot-*',
	group = copilot_chat,
	callback = function()
		opt_local.number = false
		opt_local.relativenumber = false

		-- Remove the signcolumn
		opt_local.signcolumn = 'no'

		-- Remove the foldcolumn
		opt_local.foldcolumn = '0'
	end,
})

keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })
keymap.set({ 'n' }, 'gaa', chat.toggle, { desc = 'AI Toggle' })
keymap.set({ 'v' }, 'gaa', chat.open, { desc = 'AI Open' })
keymap.set({ 'n', 'v' }, 'gax', chat.reset, { desc = 'AI Reset' })
keymap.set({ 'n', 'v' }, 'gas', chat.stop, { desc = 'AI Stop' })
keymap.set({ 'n', 'v' }, 'gap', function()
	integration.pick(actions.prompt_actions())
end, { desc = 'AI Prompts' })
keymap.set({ 'n', 'v' }, 'gaq', function()
	ui.input({
		prompt = 'AI Question> ',
	}, function(input)
		if input and input ~= '' then
			chat.ask(input)
		end
	end)
end, { desc = 'AI Quick Chat' })
