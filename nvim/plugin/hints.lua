local wk = require('which-key')

wk.setup({
	preset = 'modern',
	spec = {
		{ '<leader>o', group = 'Overseer', mode = 'n', desc = 'Command Runner' },
		{ '<leader>D', group = 'DAP', mode = 'n', desc = 'Debugger' },
		{ '<leader>g', group = 'Git', mode = 'n', desc = 'Git Client' },
		{ '<leader>h', group = 'Height', mode = 'n', desc = 'Window Height Operations' },
		{ '<leader>n', group = 'Notes', mode = 'n', desc = 'Note Taking' },
		{ '<leader>r', group = 'Refactoring', mode = 'n', desc = 'Refactoring Operations' },
		{ '<leader>s', group = 'Sessions', mode = 'n', desc = 'Session Operations' },
		{ '<leader>t', group = 'Testing', mode = 'n', desc = 'Testing Operations' },
		{ '<leader>w', group = 'Width', mode = 'n', desc = 'Window Width Operations' },
		{
			'<leader>x',
			group = 'Console',
			mode = 'n',
			desc = 'Console aggregator - quickfix, references, diagnostics etc.',
		},
		{ '<leader>z', group = 'Zen', mode = 'n', desc = 'Focus / Zen mode' },
		{ '<leader>/', group = 'Search', mode = 'n', desc = 'Telescope Search' },
	},
	win = {
		wo = {
			winblend = 15,
		},
	},
})
