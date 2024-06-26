local ls = require('luasnip')
local c = ls.choice_node
local fmt = require('luasnip.extras.fmt').fmt
local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node
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
				virt_text = { { '✂️', 'LightGreen' } },
			},
		},
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

keymap.set({ 'i', 's' }, '<C-k>', function()
	return vim.snippet.active({ direction = 1 }) and vim.snippet.jump(1)
end, { desc = 'Jump to next snippet slot', expr = true, remap = true })

keymap.set({ 'i', 's' }, '<C-j>', function()
	return vim.snippet.active({ direction = -1 }) and vim.snippet.jump(-1)
end, { desc = 'Jump to previous snippet slot', expr = true, remap = true })

keymap.set({ 'i', 's' }, '<C-l>', function()
	return select_choice()
end, { desc = 'Expand snippet', expr = true, remap = true })

local commit_snippet = s(
	{
		trig = 'commit',
		name = 'git commit template',
	},
	fmt(
		[[
# Subject line (try to keep under 50 characters)
⁅Ticket: #{}⁆ · {}

# Describe the problem this commit addresses
{}

# Describe the changes or solutions implemented as part of this commit.
{}

{}
]],
		{
			i(1, 'Ticket Number'),
			i(2, 'Subject Line'),
			i(3, 'Multi-line description of commit, feel free to be detailed.'),
			i(4, '- Change 1'),
			c(
				5,
				fmt([[Co-authored-by: {} <{}@{}.{}>]], {
					i(6, 'Co-author Name'),
					i(7, 'Co-author Email'),
					i(8, 'Co-author Domain'),
					i(9, 'Co-author TLD'),
				}),
				t('')
			),
		}
	)
)

ls.add_snippets('all', {
	commit_snippet,
})
