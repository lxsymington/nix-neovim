if vim.g.did_load_completion_plugin then
  return
end
vim.g.did_load_completion_plugin = true

local cmp = require('cmp')
local copilot_comparators = require('copilot_cmp.comparators')
local lspkind = require('lspkind')
local luasnip = require('luasnip')
local types = require('luasnip.util.types')

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.o.completefunc = 'v:lua.require("cmp").complete()'

lspkind.init({
	symbol_map = {
		Copilot = '',
	},
})

luasnip.config.set_config({
	history = true,
})

luasnip.config.setup({
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { '⦿', 'Orange' } },
			},
		},
		[types.insertNode] = {
			active = {
				virt_text = { { '●', 'LightBlue' } },
			},
		},
	},
})

local function has_words_before()
	local unpack_ = unpack or table.unpack
	local line, col = unpack_(vim.api.nvim_win_get_cursor(0))
	return col ~= 0
		and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

---@param source string|table
local function complete_with_source(source)
	if type(source) == 'string' then
		cmp.complete({ config = { sources = { { name = source } } } })
	elseif type(source) == 'table' then
		cmp.complete({ config = { sources = { source } } })
	end
end

cmp.setup({
	completion = {
		completeopt = 'menu,menuone,noinsert',
		autocomplete = {
			cmp.TriggerEvent.InsertEnter,
			cmp.TriggerEvent.TextChanged,
		},
	},
	formatting = {
		expandable_indicator = true,
		fields = { 'kind', 'abbr', 'menu' },
		format = function(entry, vim_item)
			local kind = lspkind.cmp_format({
				ellipsis_char = '…', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
				maxwidth = 50,
				mode = 'symbol_text',
				with_text = true,
			})(entry, vim_item)
			local strings = vim.split(kind.kind, '%s', { trimempty = true })
			kind.kind = ' ' .. (strings[1] or '') .. ' '
			kind.menu = '    (' .. (strings[2] or '') .. ')'

			return kind
		end,
	},
	preselect = cmp.PreselectMode.None,
	sorting = {
		priority_weight = 2,
		comparators = {
			-- Below is the default comparator list and order for nvim-cmp
			cmp.config.compare.offset,
			-- cmp.config.compare.scopes, --this is commented in nvim-cmp too
			cmp.config.compare.exact,
			copilot_comparators.prioritize,
			cmp.config.compare.score,
			cmp.config.compare.recently_used,
			cmp.config.compare.locality,
			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = {
		['<C-b>'] = cmp.mapping(function(_)
			if cmp.visible() then
				cmp.scroll_docs(-4)
			else
				complete_with_source('buffer')
			end
		end, { 'i', 'c', 's' }),
		['<C-f>'] = cmp.mapping(function(_)
			if cmp.visible() then
				cmp.scroll_docs(4)
			else
				complete_with_source('path')
			end
		end, { 'i', 'c', 's' }),
		['<C-n>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
				-- expand_or_jumpable(): Jump outside the snippet region
				-- expand_or_locally_jumpable(): Only jump inside the snippet region
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { 'i', 'c', 's' }),
		['<C-p>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 'c', 's' }),
		-- toggle completion
		['<C-e>'] = cmp.mapping(function(_)
			if cmp.visible() then
				cmp.close()
			else
				cmp.complete()
			end
		end, { 'i', 'c', 's' }),
		['<C-y>'] = cmp.mapping.confirm({
			select = true,
		}),
	},
	sources = cmp.config.sources({
		-- The insertion order influences the priority of the sources
		{ name = 'copilot', max_item_count = 2 },
		{ name = 'nvim_lsp', keyword_length = 3 },
		{ name = 'nvim_lsp_signature_help', keyword_length = 2 },
		{ name = 'luasnip' },
		{ name = 'buffer', keyword_length = 4 },
		{ name = 'path' },
	}),
	enabled = function()
		return vim.bo[0].buftype ~= 'prompt'
	end,
	experimental = {
		native_menu = false,
		ghost_text = true,
	},
	view = {
		docs = {
			auto_open = true,
		},
	},
	window = {
		completion = cmp.config.window.bordered({
			winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
			col_offset = -3,
			side_padding = 0,
		}),
		documentation = cmp.config.window.bordered(),
	},
})

cmp.setup.filetype('lua', {
	sources = cmp.config.sources({
		{ name = 'copilot', max_item_count = 2 },
		{ name = 'nvim_lua' },
		{ name = 'nvim_lsp', keyword_length = 3 },
		{ name = 'path' },
	}),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'nvim_lsp_document_symbol', keyword_length = 3 },
		{ name = 'buffer' },
		{ name = 'cmdline_history' },
		{ name = 'copilot', max_item_count = 2 },
	},
	view = {
		entries = { name = 'wildmenu', separator = ' ※ ' },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'cmdline' },
		{ name = 'cmdline_history' },
		{ name = 'path' },
		{ name = 'copilot', max_item_count = 2 },
	}),
})

vim.keymap.set(
	{ 'i', 'c', 's' },
	'<C-n>',
	cmp.complete,
	{ noremap = false, desc = '[cmp] complete' }
)
vim.keymap.set({ 'i', 'c', 's' }, '<C-f>', function()
	complete_with_source('path')
end, { noremap = false, desc = '[cmp] path' })
vim.keymap.set({ 'i', 'c', 's' }, '<C-o>', function()
	complete_with_source('nvim_lsp')
end, { noremap = false, desc = '[cmp] lsp' })
vim.keymap.set({ 'c' }, '<C-h>', function()
	complete_with_source('cmdline_history')
end, { noremap = false, desc = '[cmp] cmdline history' })
vim.keymap.set({ 'c' }, '<C-c>', function()
	complete_with_source('cmdline')
end, { noremap = false, desc = '[cmp] cmdline' })
