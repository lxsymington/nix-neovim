local wk = require('which-key')
local symbol_usage = require('symbol-usage')

wk.setup({
	preset = 'modern',
	spec = {
		{ lhs = '<leader>o', group = 'Command Runner', mode = 'n', desc = 'Command Runner (Overseer)' },
		{ lhs = '<leader>D', group = 'Debugger', mode = 'n', desc = 'Debugger (DAP)' },
		{ lhs = '<leader>G', group = 'Git Host', mode = 'n', desc = 'Git Host (GitHub - Octo)' },
		{ lhs = '<leader>g', group = 'Git', mode = 'n', desc = 'Git Client' },
		{ lhs = '<leader>h', group = 'Height', mode = 'n', desc = 'Window Height Operations' },
		{ lhs = '<leader>n', group = 'Notes', mode = 'n', desc = 'Note Taking' },
		{
			lhs = '<leader>r',
			group = 'Refactoring',
			mode = { 'n', 'v' },
			desc = 'Refactoring Operations',
		},
		{ lhs = '<leader>s', group = 'Sessions', mode = 'n', desc = 'Session Operations' },
		{ lhs = '<leader>t', group = 'Testing', mode = 'n', desc = 'Testing Operations' },
		{ lhs = '<leader>w', group = 'Width', mode = 'n', desc = 'Window Width Operations' },
		{
			lhs = '<leader>x',
			group = 'Console',
			mode = 'n',
			desc = 'Console aggregator - quickfix, references, diagnostics etc.',
		},
		{ lhs = '<leader>z', group = 'Zen', mode = 'n', desc = 'Focus / Zen mode' },
		{ lhs = '<leader>/', group = 'Search', mode = 'n', desc = 'Telescope Search' },
		{ lhs = 'ga', group = 'AI', mode = { 'n', 'v' }, desc = 'Chat with AI' },
		{ lhs = 'gr', group = 'Refactoring', mode = { 'n', 'v' }, desc = 'Refactoring' },
		{ lhs = 'gw', group = 'Workspace', mode = { 'n', 'v' }, desc = 'Workspace' },
	},
	win = {
		wo = {
			winblend = 15,
		},
	},
})

local function h(name)
	return vim.api.nvim_get_hl(0, { name = name })
end

-- hl-groups can have any name
vim.api.nvim_set_hl(0, 'SymbolUsageRounding', { fg = h('CursorLine').bg, italic = true })
vim.api.nvim_set_hl(
	0,
	'SymbolUsageContent',
	{ bg = h('CursorLine').bg, fg = h('Comment').fg, italic = true }
)
vim.api.nvim_set_hl(
	0,
	'SymbolUsageRef',
	{ fg = h('Function').fg, bg = h('CursorLine').bg, italic = true }
)
vim.api.nvim_set_hl(
	0,
	'SymbolUsageDef',
	{ fg = h('Type').fg, bg = h('CursorLine').bg, italic = true }
)
vim.api.nvim_set_hl(
	0,
	'SymbolUsageImpl',
	{ fg = h('@keyword').fg, bg = h('CursorLine').bg, italic = true }
)

local function text_format(symbol)
	local res = {}

	local round_start = { '▐', 'SymbolUsageRounding' }
	local round_end = { '▌', 'SymbolUsageRounding' }

	-- Indicator that shows if there are any other symbols in the same line
	local stacked_functions_content = symbol.stacked_count > 0
			and ('+%s'):format(symbol.stacked_count)
		or ''

	if symbol.references then
		local usage = symbol.references <= 1 and 'usage' or 'usages'
		local num = symbol.references == 0 and 'no' or symbol.references
		table.insert(res, round_start)
		table.insert(res, { '󰌹 ', 'SymbolUsageRef' })
		table.insert(res, { ('%s %s'):format(num, usage), 'SymbolUsageContent' })
		table.insert(res, round_end)
	end

	if symbol.definition then
		if #res > 0 then
			table.insert(res, { ' ', 'NonText' })
		end
		table.insert(res, round_start)
		table.insert(res, { '󰳽 ', 'SymbolUsageDef' })
		table.insert(res, { symbol.definition .. ' defs', 'SymbolUsageContent' })
		table.insert(res, round_end)
	end

	if symbol.implementation then
		if #res > 0 then
			table.insert(res, { ' ', 'NonText' })
		end
		table.insert(res, round_start)
		table.insert(res, { '󰡱 ', 'SymbolUsageImpl' })
		table.insert(res, { symbol.implementation .. ' impls', 'SymbolUsageContent' })
		table.insert(res, round_end)
	end

	if stacked_functions_content ~= '' then
		if #res > 0 then
			table.insert(res, { ' ', 'NonText' })
		end
		table.insert(res, round_start)
		table.insert(res, { ' ', 'SymbolUsageImpl' })
		table.insert(res, { stacked_functions_content, 'SymbolUsageContent' })
		table.insert(res, round_end)
	end

	return res
end

symbol_usage.setup({
	text_format = text_format,
})
