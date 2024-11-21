--[[ local neorg = require('neorg')
local neorg_callbacks = require('neorg.core.callbacks')

local keymap = vim.keymap

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
		['core.keybinds'] = {
			config = {
				default_keybinds = true,
				preset = 'neorg',
			},
		},
		['core.integrations.telescope'] = {
			config = {
				insert_file_link = {
					show_title_preview = true,
				},
			},
		},
		['core.integrations.treesitter'] = {
			config = {
				configure_parsers = true,
				install_parsers = false,
			},
		},
		['core.presenter'] = {
			config = {
				zen_mode = 'truezen',
			},
		},
	},
})

neorg_callbacks.on_event('core.keybinds.events.enable_keybinds', function(_, keybinds)
	-- Map all the below keybinds only when the "norg" mode is active
	keybinds.map_event_to_mode('norg', {
		n = { -- Bind keys in normal mode
			{ '<C-s>', 'core.integrations.telescope.find_linkable' },
		},

		i = { -- Bind in insert mode
			{ '<C-l>', 'core.integrations.telescope.insert_link' },
		},
	}, {
		silent = true,
		noremap = true,
	})
end)

keymap.set('n', '<leader>ni', '<Cmd>Neorg index<CR>') ]]
