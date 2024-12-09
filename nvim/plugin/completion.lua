if vim.g.did_load_completion_plugin then
	return
end
vim.g.did_load_completion_plugin = true

local blink = require('blink.cmp')
local copilot_comparators = require('copilot_cmp.comparators')
local lspkind = require('lspkind')
local luasnip = require('luasnip')

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
-- vim.o.completefunc = 'v:lua.require("cmp").complete()'

lspkind.init({
	symbol_map = {
		Copilot = '',
		TypeParameter = '󰅴',
	},
})

blink.setup({
	completion = {
		accept = {
			auto_brackets = {
				enabled = true,
			},
		},
		documentation = {
			auto_show = true,
			border = 'rounded',
		},
		list = {
			max_items = 30,
		},
		menu = {
			draw = {
				columns = {
					{ 'kind_icon' },
					{ 'label', 'label_description', fill = true, gap = 1 },
					{ 'kind' },
					{ 'source_name' },
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
			},
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
	signature = {
		enabled = true,
		window = {
			border = 'rounded',
		},
	},
	snippets = {
		expand = function(snippet)
			luasnip.lsp_expand(snippet)
		end,
		active = function(filter)
			if filter and filter.direction then
				return luasnip.jumpable(filter.direction)
			end
			return luasnip.in_snippet()
		end,
		jump = function(direction)
			luasnip.jump(direction)
		end,
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
				-- 'neorg',
				'path',
			},
		},
		providers = {
			copilot = {
				name = 'copilot',
				module = 'blink.compat.source',
				enabled = true,
				max_items = 3,
				score_offset = -2,
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
			--[[ neorg = {
				name = 'neorg',
				module = 'blink.compat.source',
				enabled = true,
			}, ]]
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
})
