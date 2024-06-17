vim.cmd.packadd({
	args = { 'overseer.nvim' },
	bang = true,
})
local overseer = require('overseer')
local keymap = vim.keymap
local cmd = vim.cmd
-- Overseer ————————————————————————————————————————————————————————————————————
overseer.setup({
	component_aliases = {
		default_neotest = {
			'on_output_summarize',
			'on_exit_set_status',
			'on_complete_notify',
			'on_complete_dispose',
		},
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
