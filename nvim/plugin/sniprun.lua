vim.cmd.packadd({
	args = { 'sniprun' },
	bang = true,
})
local sniprun = require('sniprun')

sniprun.setup({
	borders = 'rounded',
	display = {
		'Terminal', -- "display results in the command-line  area
		'VirtualTextOk', -- "display ok results as virtual text (multiline is shortened)
	},
	live_mode_toggle = 'enable',
	live_display = {
		'Terminal', -- "display results in the command-line  area
		'VirtualTextOk', -- "display ok results as virtual text (multiline is shortened)
	},
})
