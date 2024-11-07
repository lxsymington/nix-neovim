if vim.g.did_load_completion_plugin then
	return
end
vim.g.did_load_completion_plugin = true

local blink = require('blink.cmp')
local copilot_comparators = require('copilot_cmp.comparators')
local lspkind = require('lspkind')

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
-- vim.o.completefunc = 'v:lua.require("cmp").complete()'

lspkind.init({
	symbol_map = {
		Copilot = '',
		TypeParameter = '󰅴',
	},
})

blink.setup({
	accept = {
		enabled = true,
	},
	fuzzy = {
		prebuilt_binaries = {
			download = false,
		},
	},
	keymap = {
		preset = 'default',
		['<C-k>'] = { 'snippet_forward', 'fallback' },
		['<C-j>'] = { 'snippet_backward', 'fallback' },
	},
	sources = {
		completion = {
			enabled_providers = {
				'buffer',
				'copilot',
				'git',
				'lazydev',
				'lsp',
				'luasnip',
				'neorg',
				'path',
				'snippets',
			},
		},
		providers = {
			copilot = {
				name = 'copilot',
				module = 'blink.compat.source',
				enabled = true,
				max_items = 3,
				opts = {
					comparator = copilot_comparators.default,
				},
			},
			git = {
				name = 'git',
				module = 'blink.compat.source',
				enabled = true,
			},
			lazydev = {
				name = 'LazyDev',
				module = 'lazydev.integrations.blink',
			},
			lsp = {
				fallback_for = { 'lazydev' },
			},
			luasnip = {
				name = 'luasnip',
				module = 'blink.compat.source',
				enabled = true,
			},
			neorg = {
				name = 'neorg',
				module = 'blink.compat.source',
				enabled = true,
			},
			nvim_lua = {
				name = 'nvim lua',
				module = 'blink.compat.source',
				enabled = true,
			},
		},
	},
	trigger = {
		signature_help = {
			enabled = true,
		},
	},
	windows = {
		documentation = {
			auto_show = true,
		},
		signature_help = {
			scrollbar = true,
		},
	},
})
