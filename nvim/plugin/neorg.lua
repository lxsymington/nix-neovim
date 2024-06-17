local neorg = require('neorg')

neorg.setup({
	load = {
		['core.defaults'] = {}, -- Load all the default modules
		['core.completion'] = {
			config = {
				engine = 'nvim-cmp',
			},
		},
		['core.concealer'] = {}, -- Allows for use of icons
		['core.dirman'] = { -- Manage your directories with Neorg
			config = {
				workspaces = {
					notes = '~/Development/Notes',
				},
				default_workspace = 'notes',
			},
		},
	},
})
