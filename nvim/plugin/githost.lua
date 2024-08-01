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

-- https://docs.github.com/en/search-github/searching-on-github/searching-issues-and-pull-requests
keymap.set('n', '<Leader>Gm', function()
	cmd('Octo search type:pr involves:@me state:open')
end, {
	desc = 'Octo » PRs involving me',
	silent = true,
})

keymap.set('n', '<Leader>Gs', function()
	cmd(
		'Octo search type:pr review:required state:open (review-requested:@me OR team-review-requested:SecclTech/wrappers)'
	)
end, {
	desc = 'Octo » PRs requiring my review',
	silent = true,
})
