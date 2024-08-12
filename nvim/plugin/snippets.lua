local ls = require('luasnip')
local c = ls.choice_node
local fmt = require('luasnip.extras.fmt').fmt
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
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

keymap.set({ 'n', 'i', 's' }, '<C-k>', function()
	return vim.snippet.active({ direction = 1 }) and vim.snippet.jump(1)
end, { desc = 'Jump to next snippet slot', expr = true, remap = true })

keymap.set({ 'n', 'i', 's' }, '<C-j>', function()
	return vim.snippet.active({ direction = -1 }) and vim.snippet.jump(-1)
end, { desc = 'Jump to previous snippet slot', expr = true, remap = true })

keymap.set({ 'n', 'i', 's' }, '<C-l>', function()
	return select_choice()
end, { desc = 'Expand snippet', expr = true, remap = true })

local commit_header = fmt(
	[[
# Subject line (try to keep under 50 characters)
⁅Ticket: #{}⁆ · {}
]],
	{

		i(1, 'Ticket Number'),
		i(2, 'Subject Line'),
	}
)

local commit_description = fmt(
	[[
# Describe the problem this commit addresses
{}
]],
	{
		i(3, 'Multi-line description of commit, feel free to be detailed.'),
	}
)

local commit_changes = fmt(
	[[
# Describe the changes or solutions implemented as part of this commit.
{}
]],
	{

		i(4, '- Change 1'),
	}
)

local commit_coauthor = fmt([[Co-authored-by: {} <{}@{}.{}>]], {
	i(6, 'Co-author Name'),
	i(7, 'Co-author Email'),
	i(8, 'Co-author Domain'),
	i(9, 'Co-author TLD'),
})

local commit_snippet = s(
	{
		trig = 'commit',
		name = 'git commit template',
	},
	c(1, {
		sn(1, {
			commit_header,
			commit_description,
		}),
		sn(2, {
			commit_header,
			commit_changes,
		}),
		sn(3, {
			commit_header,
		}),
		sn(4, {
			commit_header,
			commit_description,
			commit_changes,
		}),
		sn(1, {
			commit_header,
			commit_description,
			commit_coauthor,
		}),
		sn(2, {
			commit_header,
			commit_changes,
			commit_coauthor,
		}),
		sn(3, {
			commit_header,
			commit_coauthor,
		}),
		sn(4, {
			commit_header,
			commit_description,
			commit_changes,
			commit_coauthor,
		}),
	})
)

ls.add_snippets('all', {
	commit_snippet,
})
