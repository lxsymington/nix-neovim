if vim.g.did_load_completion_plugin then
	return
end
vim.g.did_load_completion_plugin = true

local blink = require('blink.cmp')
local lspkind = require('lspkind')

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.completefunc = 'v:lua.require("blink").show()'

lspkind.init({
	symbol_map = {
		Copilot = '',
		TypeParameter = '󰅴',
	},
})

--- @type blink.cmp.AppearanceConfigPartial
local appearance = {
	nerd_font_variant = 'normal',
	kind_icons = {
		Copilot = '',
		Snippet = '✂️',
		TypeParameter = '󰅴',
	},
}

--- @type blink.cmp.CompletionConfigPartial
local completion = {
	accept = {
		auto_brackets = {
			enabled = true,
		},
	},
	documentation = {
		auto_show = true,
		window = {
			border = 'rounded',
			winblend = 15,
		},
	},
	ghost_text = {
		enabled = true,
	},
	keyword = {
		range = 'full',
	},
	list = {
		max_items = 30,
	},
	menu = {
		draw = {
			columns = {
				{ 'kind_icon' },
				{ 'label', 'label_description', gap = 1 },
				{ 'kind' },
				{ 'source_name' },
			},
			components = {
				kind_icon = {
					ellipsis = false,
					text = function(ctx)
						local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
						local padding = ctx.self.padding or 1
						local left_padding, right_padding =
							unpack(type(padding) == 'table' and padding or { padding, padding })
						return string.format(
							'%s%s%s',
							string.rep(' ', left_padding),
							kind_icon or ctx.kind_icon,
							string.rep(' ', right_padding)
						)
					end,
					-- (optional) use highlights from mini.icons
					highlight = function(ctx)
						local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
						return hl
					end,
				},
				kind = {
					ellipsis = false,
					width = { fill = true },
					text = function(ctx)
						local padding = ctx.self.padding or 1
						local left_padding, right_padding =
							unpack(type(padding) == 'table' and padding or { padding, padding })
						return string.format(
							'%s%s%s',
							string.rep(' ', left_padding),
							ctx.kind,
							string.rep(' ', right_padding)
						)
					end,
					-- (optional) use highlights from mini.icons
					highlight = function(ctx)
						local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
						return hl
					end,
				},

				label = {
					width = { fill = true, max = 60 },
				},

				label_description = {
					width = { fill = true, max = 30 },
					ellipsis = true,
				},
			},
			treesitter = { 'lsp' },
		},
	},
}

--- @type blink.cmp.FuzzyConfigPartial
local fuzzy = {
	implementation = 'prefer_rust_with_warning',
	prebuilt_binaries = {
		download = false,
	},
	sorts = {
		'exact',
		-- defaults
		'score',
		'sort_text',
	},
}

--- @type blink.cmp.KeymapConfig
local keymap = {
	preset = 'default',
	['<C-k>'] = { 'snippet_forward', 'fallback' },
	['<C-j>'] = { 'snippet_backward', 'fallback' },
}

--- @type blink.cmp.SignatureConfigPartial
local signature = {
	enabled = true,
	window = {
		border = 'rounded',
		winblend = 15,
	},
}

--- @type blink.cmp.SnippetsConfigPartial
local snippets = {
	preset = 'luasnip',
}

--- @type blink.cmp.SourceConfigPartial
local sources = {
	default = {
		'buffer',
		'codecompanion',
		'copilot',
		'git',
		'lsp',
		'snippets',
		'path',
	},
	per_filetype = {
		lua = {
			'buffer',
			'codecompanion',
			'copilot',
			'git',
			'lazydev',
			'lsp',
			'snippets',
			'path',
		},
		norg = {
			'buffer',
			'codecompanion',
			'copilot',
			'git',
			'lazydev',
			'lsp',
			'snippets',
			'neorg',
			'path',
		},
	},
	providers = {
		buffer = {
			name = 'Buffer',
			enabled = true,
			module = 'blink.cmp.sources.buffer',
			score_offset = 5,
		},
		copilot = {
			name = 'copilot',
			module = 'blink-copilot',
			enabled = true,
			max_items = 3,
			score_offset = 50,
			async = true,
			opts = {
				max_completions = 3,
				max_attempts = 4,
			},
		},
		git = {
			name = 'git',
			module = 'blink.compat.source',
			enabled = true,
			score_offset = 20,
		},
		lazydev = {
			name = 'LazyDev',
			enabled = true,
			module = 'lazydev.integrations.blink',
			fallbacks = { 'lsp' },
			score_offset = 70,
		},
		lsp = {
			name = 'LSP',
			enabled = true,
			module = 'blink.cmp.sources.lsp',
			score_offset = 60,
		},
		snippets = {
			name = 'Snippets',
			enabled = true,
			module = 'blink.cmp.sources.snippets',
			score_offset = 40,
		},
		neorg = {
			name = 'neorg',
			module = 'blink.compat.source',
			enabled = true,
		},
		path = {
			name = 'Path',
			enabled = true,
			module = 'blink.cmp.sources.path',
			score_offset = 10,
		},
		cmdline = {
			module = 'blink.cmp.sources.cmdline',
		},
		omni = {
			module = 'blink.cmp.sources.complete_func',
			enabled = function()
				return vim.bo.omnifunc ~= 'v:lua.vim.lsp.omnifunc'
			end,
			---@type blink.cmp.CompleteFuncOpts
			opts = {
				complete_func = function()
					return vim.bo.omnifunc
				end,
			},
		},
	},
}

blink.setup({
	appearance = appearance,
	completion = completion,
	fuzzy = fuzzy,
	keymap = keymap,
	signature = signature,
	snippets = snippets,
	sources = sources,
})
