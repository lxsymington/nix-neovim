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
	cmd('Octo search is:pr involves:@me state:open -author:app/dependabot')
end, {
	desc = 'Octo » PRs involving me',
	silent = true,
})

keymap.set('n', '<Leader>Gd', function()
	cmd('Octo search is:pr involves:@me state:open author:app/dependabot')
end, {
	desc = 'Octo » Dependabot PRs involving me',
	silent = true,
})

keymap.set('n', '<Leader>Grm', function()
	cmd('Octo search is:pr review:required state:open review-requested:@me -author:app/dependabot')
end, {
	desc = 'Octo » PRs requiring my review',
	silent = true,
})

keymap.set('n', '<Leader>Grt', function()
	cmd(
		'Octo search is:pr review:required state:open team-review-requested:SecclTech/reporting-squad -author:app/dependabot'
	)
end, {
	desc = 'Octo » PRs requiring a review from my team',
	silent = true,
})
