vim.cmd.packadd({
	args = { 'overseer.nvim' },
	bang = true,
})
vim.cmd.packadd({
	args = { 'compiler.nvim' },
	bang = true,
})
local overseer = require('overseer')
local compiler = require('compiler')
local keymap = vim.keymap
local cmd = vim.cmd

-- Overseer ————————————————————————————————————————————————————————————————————
overseer.setup({
	component_aliases = {
		default = {
			{ 'display_duration', detail_level = 2 },
			'on_output_summarize',
			'on_exit_set_status',
			{ 'on_complete_notify', system = 'always' },
			{ 'on_complete_dispose', require_view = { 'SUCCESS', 'FAILURE' } },
		},
		default_neotest = {
			'on_output_summarize',
			'on_exit_set_status',
			'on_complete_notify',
			'on_complete_dispose',
		},
	},
	task_list = {
		default_detail = 2,
		separator = '▰▰▰▰▰▰▰▰▰▰',
		min_width = { 60, 0.15 },
		max_height = { 20, 0.2 },
		min_height = 12,
	},
})

keymap.set('n', '<Leader>Ot', cmd.OverseerToggle, {
	desc = 'Overseer » Toggle',
	silent = true,
})
keymap.set('n', '<Leader>Ob', cmd.OverseerBuild, {
	desc = 'Overseer » Builder',
	silent = true,
})
keymap.set('n', '<Leader>Oa', cmd.OverseerTaskAction, {
	desc = 'Overseer » Run Action',
	silent = true,
})
keymap.set('n', '<Leader>Or', cmd.OverseerRun, {
	desc = 'Overseer » Run',
	silent = true,
})

compiler.setup({})
