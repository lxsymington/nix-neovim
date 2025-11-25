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
local fn = vim.fn
local fs = vim.fs
local uv = vim.uv

neotest.setup({
	adapters = {
		require('neotest-jest')({
			cwd = function(file)
				if file:find('/packages/') then
					local match = file:match('(.*/)integration')

					if match then
						vim.print(string.format('Found package: %s', match))

						return match
					end
				end

				vim.print('Using root directory')

				return vim.fn.getcwd()
			end,
			jest_test_discovery = false,
		}),
		require('neotest-mocha')({
			command = 'volta run npm run test:local --if-present --',
			command_args = function(context)
				-- The context contains:
				--   results_path: The file that json results are written to
				--   test_name_pattern: The generated pattern for the test
				--   path: The path to the test file
				return {
					'--full-trace',
					'--reporter=json',
					string.format('--reporter-options output=%s', context.results_path),
					'--grep=' .. context.test_name_pattern,
					string.format('%s', fs.relpath(uv.cwd(), context.path)),
				}
			end,
			env = { CI = true },
			cwd = function(path)
				return vim.fn.getcwd()
			end,
		}),
		require('neotest-vitest'),
	},
	consumers = {
		overseer = require('neotest.consumers.overseer'),
	},
	diagnostic = {
		enabled = true,
		severity = vim.diagnostic.severity.INFO,
	},
	icons = {
		running_animated = {
			'▁',
			'▃',
			'▄',
			'▅',
			'▆',
			'▇',
			'▆',
			'▅',
			'▄',
			'▃',
		},
	},
	jump = {
		enabled = true,
	},
	log_level = vim.log.levels.DEBUG,
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
		open = 'botright 80vsplit',
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
	neotest.run.run(vim.fn.expand('%'))
end, {
	desc = 'Test » Current File',
	silent = true,
})

keymap.set('n', '<Leader>td', function()
	neotest.run.run({ strategy = 'dap' })
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

keymap.set('n', ']T', function()
	neotest.jump.next()
end, {
	desc = 'Next » Test',
	silent = true,
})

keymap.set('n', ']t', function()
	neotest.jump.next({ status = 'failed' })
end, {
	desc = 'Next » Failing Test',
	silent = true,
})

keymap.set('n', '[T', function()
	neotest.jump.prev()
end, {
	desc = 'Previous » Test',
	silent = true,
})

keymap.set('n', '[t', function()
	neotest.jump.prev({ status = 'failed' })
end, {
	desc = 'Previous » Failing Test',
	silent = true,
})
