local recorder = require('recorder')

recorder.setup({
	-- Named registers where macros are saved (single lowercase letters only).
	-- The first register is the default register used as macro-slot after
	-- startup.
	slots = {
		'a',
		'b',
		'c',
		'd',
		'e',
		'f',
		'g',
		'h',
		'i',
		'j',
		'k',
		'l',
		'm',
		'n',
		'o',
		'p',
		'q',
		'r',
		's',
		't',
		'u',
		'v',
		'w',
		'x',
		'y',
		'z',
	},
	dynamicSlots = 'rotate',
	mapping = {
		startStopRecording = 'q',
		playMacro = 'Q',
		switchSlot = '<C-q>',
		editMacro = 'cq',
		deleteAllMacros = 'dq',
		yankMacro = 'yq',
		-- ⚠️ this should be a string you don't use in insert mode during a macro
		addBreakPoint = '##',
	},
	clear = false,
	logLevel = vim.log.levels.INFO, -- :help vim.log.levels
	useNerdfontIcons = true,
})
