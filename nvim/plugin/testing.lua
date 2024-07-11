-- TODO: These aren't doing much at the moment. As they always get loaded. Figure out the best time to load them.
vim.cmd.packadd({
	args = { 'overseer.nvim' },
	bang = true,
})
vim.cmd.packadd({
	args = { 'neotest' },
	bang = true,
})
local neotest = require('neotest')
local keymap = vim.keymap

neotest.setup({
	adapters = {
		require('neotest-jest')({
			jestCommand = 'npm test -- ',
			jest_test_discovery = true,
		}),
		require('neotest-vim-test')({}),
	},
	consumers = {
		overseer = require('neotest.consumers.overseer'),
	},
	diagnostic = {
		enabled = true,
		severity = vim.diagnostic.severity.INFO,
	},
	icons = {
		failed = '✘',
		passed = '✔',
		running = '➜',
		skipped = '',
		unknown = '',
	},
	jump = {
		enabled = true,
	},
	log_level = vim.log.levels.INFO,
	output = {
		enabled = true,
		open_on_run = true,
	},
	run = {
		enabled = true,
	},
	status = {
		enabled = true,
		signs = true,
		virtual_text = true,
	},
	strategies = {
		integrated = {
			width = 100,
		},
	},
	summary = {
		enabled = true,
		expand_errors = true,
		follow = true,
		mappings = {
			attach = 'a',
			clear_marked = 'M',
			expand = { '<CR>', '<2-LeftMouse>' },
			expand_all = 'e',
			jumpto = 'i',
			mark = 'm',
			output = 'o',
			run = 'r',
			run_marked = 'R',
			short = 'O',
			stop = 'u',
			watch = 'W',
		},
		width = 80,
	},
})

keymap.set('n', '<Leader>tn', neotest.run.run, {
	desc = 'Test » Nearest',
	silent = true,
})

keymap.set('n', '<Leader>tl', neotest.run.run_last, {
	desc = 'Test » Last',
	silent = true,
})

keymap.set('n', '<Leader>tf', function()
	require('neotest').run.run(vim.fn.expand('%'))
end, {
	desc = 'Test » Current File',
	silent = true,
})

keymap.set('n', '<Leader>td', function()
	require('neotest').run.run({ strategy = 'dap' })
end, {
	desc = 'Test » Debug Nearest',
	silent = true,
})

keymap.set('n', '<Leader>t!', neotest.run.stop, {
	desc = 'Test » Stop',
	silent = true,
})

keymap.set('n', '<Leader>ts', neotest.summary.toggle, {
	desc = 'Test » Summary',
	silent = true,
})

keymap.set('n', '<Leader>to', neotest.output_panel.open, {
	desc = 'Test » Output',
	silent = true,
})

keymap.set('n', '<Leader>tO', neotest.output.open, {
	desc = 'Test » Output',
	silent = true,
})

keymap.set('n', '<Leader>ta', neotest.run.attach, {
	desc = 'Test » Attach',
	silent = true,
})

keymap.set('n', ']t', function()
	require('neotest').jump.next({ status = 'failed' })
end, {
	desc = 'Next » Failing Test',
	silent = true,
})

keymap.set('n', '[t', function()
	require('neotest').jump.prev({ status = 'failed' })
end, {
	desc = 'Previous » Failing Test',
	silent = true,
})
