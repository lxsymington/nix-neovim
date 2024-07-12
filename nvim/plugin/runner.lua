vim.cmd.packadd({
	args = { 'sniprun' },
	bang = true,
})
local sniprun = require('sniprun')

sniprun.setup({
	borders = 'rounded',
	display = {
		'VirtualText', -- "display results as virtual text (multiline is shortened)
		'TerminalOk', -- "display ok results in the command-line  area
	},
	live_mode_toggle = 'enable',
	live_display = {
		'VirtualText', -- "display results as virtual text (multiline is shortened)
		'TerminalOk', -- "display ok results in the command-line  area
	},
	selected_interpreters = { 'JS_TS_deno' },
	repl_enable = { 'JS_TS_deno' },
})
