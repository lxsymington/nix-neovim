local octo = require('octo')
local keymap = vim.keymap
local cmd = vim.cmd

-- Octo ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
octo.setup({
	ssh_aliases = {
		Seccl = 'github.com',
		Personal = 'github.com',
	},
})

keymap.set('n', '<Leader>Sr', function()
	cmd('Octo search is:pr review-requested:@me state:open')
end, {
	desc = 'Octo » Requested Reviews',
	silent = true,
})
