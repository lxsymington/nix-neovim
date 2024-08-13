local ls = require('luasnip')
local c = ls.choice_node
local fmt = require('luasnip.extras.fmt').fmt
local s = ls.snippet
local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
local types = require('luasnip.util.types')
local select_choice = require('luasnip.extras.select_choice')
local keymap = vim.keymap

vim.snippet.expand = ls.lsp_expand

---@diagnostic disable-next-line: duplicate-set-field
vim.snippet.active = function(filter)
	filter = filter or {}
	filter.direction = filter.direction or 1

	if filter.direction == 1 then
		return ls.expand_or_jumpable()
	else
		return ls.jumpable(filter.direction)
	end
end

---@diagnostic disable-next-line: duplicate-set-field
vim.snippet.jump = function(direction)
	if direction == 1 then
		if ls.expandable() then
			return ls.expand_or_jump()
		else
			return ls.jumpable(1) and ls.jump(1)
		end
	else
		return ls.jumpable(-1) and ls.jump(-1)
	end
end

vim.snippet.stop = ls.unlink_current

ls.config.set_config({
	history = true,
	updateevents = 'TextChanged,TextChangedI',
})

ls.config.setup({
	ext_opts = {
		[types.snippet] = {
			active = {
				virt_text = { { '✂️', 'SnippetVirtTextSnippet' } },
			},
			passive = {
				virt_text = { { '🪨', 'DimGrey' } },
			},
			visited = {
				virt_text = { { '🏖️', 'DimGrey' } },
			},
			unvisited = {
				virt_text = { { '🛫', 'DimGrey' } },
			},
			snippet_passive = {
				virt_text = { { '🛏️', 'DimGrey' } },
			},
		},
		[types.choiceNode] = {
			active = {
				virt_text = { { '⦿', 'SnippetVirtTextChoice' } },
			},
		},
		[types.insertNode] = {
			active = {
				virt_text = { { '●', 'SnippetVirtTextInsert' } },
			},
		},
	},
})

keymap.set({ 'i', 's' }, '<C-k>', function()
	return vim.snippet.active({ direction = 1 }) and vim.snippet.jump(1)
end, { desc = 'Jump to next snippet slot', expr = true, remap = true })

keymap.set({ 'i', 's' }, '<C-j>', function()
	return vim.snippet.active({ direction = -1 }) and vim.snippet.jump(-1)
end, { desc = 'Jump to previous snippet slot', expr = true, remap = true })

keymap.set({ 'i', 's' }, '<C-l>', function()
	return select_choice()
end, { desc = 'Expand snippet', expr = true, remap = true })

local function commit_header()
	return fmt(
		[[
# Subject line (try to keep under 50 characters)
⁅Ticket: #{}⁆ · {}
{}
]],
		{
			i(nil, 'Ticket Number'),
			i(nil, 'Subject Line'),
			t(''),
		}
	)
end

local function commit_description()
	return fmt(
		[[
{}
# Describe the problem this commit addresses
{}
{}
]],
		{
			t(''),
			i(nil, 'Multi-line description of commit, feel free to be detailed.'),
			t(''),
		}
	)
end

local function commit_changes()
	return fmt(
		[[
{}
# Describe the changes or solutions implemented as part of this commit.
{}
{}
]],
		{
			t(''),
			i(nil, '- Change 1'),
			t(''),
		}
	)
end

local function commit_coauthor()
	return fmt([[Co-authored-by: {} <{}@{}.{}>]], {
		i(nil, 'Co-author Name'),
		i(nil, 'Co-author Email'),
		i(nil, 'Co-author Domain'),
		i(nil, 'Co-author TLD'),
	})
end

local commit_snippet = s(
	{
		trig = 'commit',
		name = 'git commit template',
	},
	c(1, {
		sn(nil, {
			sn(nil, commit_header()),
		}, { key = 'Header' }),
		sn(nil, {
			sn(nil, commit_header()),
			sn(nil, commit_description()),
		}, { key = 'Header » Description' }),
		sn(nil, {
			sn(nil, commit_header()),
			sn(nil, commit_description()),
			sn(nil, commit_changes()),
		}, { key = 'Header » Description » Changes' }),
		sn(nil, {
			sn(nil, commit_header()),
			sn(nil, commit_description()),
			sn(nil, commit_changes()),
			sn(nil, commit_coauthor()),
		}, { key = 'Header » Description » Changes » Coauthor' }),
	})
)

ls.add_snippets('all', {
	commit_snippet,
})

-- TODO: Figure out how to make this work with Neogit
-- ls.add_snippets('gitcommit', {
-- 	commit_snippet,
-- })

-- ls.filetype_extend('gitcommit', {
-- 	'NeogitCommitMessage',
-- })
