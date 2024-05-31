local hurl = require('hurl')
local keymap = vim.keymap

-- Hurl
hurl.setup({
	show_notification = true,
	mode = 'split',
	formatters = {
		json = { 'gojq' },
		html = {
			'prettier',
			'--parser',
			'html',
		},
	},
	split_position = 'right',
	split_size = 80,
})

keymap.set('n', '<Leader>ha', vim.cmd.HurlRunner, { desc = 'Run all requests' })
keymap.set('n', '<Leader>h.', vim.cmd.HurlRunnerAt, { desc = 'Run API request' })
keymap.set('n', '<Leader>he', vim.cmd.HurlRunnerToEntry, { desc = 'Run API request to entry' })
keymap.set('n', '<Leader>ht', vim.cmd.HurlToggleMode, { desc = 'Hurl toggle mode' })
keymap.set('n', '<Leader>hv', vim.cmd.HurlVerbose, { desc = 'Run API request in verbose mode' })
keymap.set('v', '<Leader>h', vim.cmd.HurlRunner, { desc = 'Hurl Runner' })
