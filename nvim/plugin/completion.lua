if vim.g.did_load_completion_plugin then
	return
end
vim.g.did_load_completion_plugin = true

local blink = require('blink.cmp')
local utils = require('blink.cmp.utils')
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
		auto_brackets = {
			enabled = true,
		},
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
		autocomplete = {
			draw = {
				columns = {
					{ 'kind_icon', gap = 1 },
					{ 'label', 'label_description', gap = 1 },
					{ 'kind', gap = 1 },
				},
				components = {
					kind_icon = {
						ellipsis = false,
						text = function(ctx)
							local padding = ctx.self.padding or 1
							local left_padding, right_padding =
								type(padding) == 'table' and unpack(ctx.self.padding) or padding, padding
							return string.format(
								'%s%s%s%s',
								string.rep(' ', left_padding),
								ctx.kind_icon,
								string.rep(' ', right_padding),
								ctx.icon_gap
							)
						end,
						highlight = function(ctx)
							return utils.get_tailwind_hl(ctx) or 'BlinkCmpKind' .. ctx.kind
						end,
					},

					kind = {
						ellipsis = false,
						width = { fill = true },
						text = function(ctx)
							local padding = ctx.self.padding or 1
							local left_padding, right_padding =
								type(padding) == 'table' and unpack(ctx.self.padding) or padding, padding
							return string.format(
								'%s%s%s',
								string.rep(' ', left_padding),
								ctx.kind,
								string.rep(' ', right_padding)
							)
						end,
						highlight = function(ctx)
							return utils.get_tailwind_hl(ctx) or 'BlinkCmpKind' .. ctx.kind
						end,
					},

					label = {
						width = { fill = true, max = 60 },
						text = function(ctx)
							local padding = ctx.self.padding or 1
							local left_padding, right_padding =
								type(padding) == 'table' and unpack(ctx.self.padding) or padding, padding
							return string.format(
								'%s%s%s',
								string.rep(' ', left_padding),
								ctx.label,
								' ',
								ctx.label_detail,
								string.rep(' ', right_padding)
							)
						end,
						highlight = function(ctx)
							-- label and label details
							local highlights = {
								{
									0,
									#ctx.label,
									group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel',
								},
							}
							if ctx.label_detail then
								table.insert(
									highlights,
									{ #ctx.label, #ctx.label + #ctx.label_detail, group = 'BlinkCmpLabelDetail' }
								)
							end

							-- characters matched on the label by the fuzzy matcher
							for _, idx in ipairs(ctx.label_matched_indices) do
								table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
							end

							return highlights
						end,
					},

					label_description = {
						width = { max = 30 },
						ellipsis = true,
						text = function(ctx)
							local padding = ctx.self.padding or 1
							local left_padding, right_padding =
								type(padding) == 'table' and unpack(ctx.self.padding) or padding, padding
							return string.format(
								'%s%s%s',
								string.rep(' ', left_padding),
								ctx.label_description,
								string.rep(' ', right_padding)
							)
						end,
					},
				},
				gap = 0,
				padding = 1,
			},
		},
		documentation = {
			auto_show = true,
			border = 'none',
		},
		signature_help = {
			border = 'none',
			scrollbar = true,
		},
	},
})
