local ls = require('luasnip')
local c = ls.choice_node
local fmt = require('luasnip.extras.fmt').fmt
local i = ls.insert_node
local s = ls.snippet
local t = ls.test_node
local types = require('luasnip.util.types')

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
	override_builtin = true,
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

vim.keymap.set({ 'i', 's' }, '<c-;>', function()
	return vim.snippet.active({ direction = 1 }) and vim.snippet.jump(1)
end, { silent = true })

vim.keymap.set({ 'i', 's' }, '<c-,>', function()
	return vim.snippet.active({ direction = -1 }) and vim.snippet.jump(-1)
end, { silent = true })

ls.add_snippets('gitcommit', {
	-- All the snippets are defined in here
	s('gct', {
		t([[# Subject line (try to keep under 50 characters)]]),
		fmt([[⁅Ticket: #{}⁆ · {}]], {
			i(1, 'Ticket Number'),
			i(2, 'Subject Line'),
		}),
		t(),
		t([[# Describe the problem this commit addresses]]),
		i(3, 'Multi-line description of commit, feel free to be detailed.'),
		t(),
		t([[# Describe the changes or solutions implemented as part of this commit.]]),
		i(4, '- Change 1'),
		t(),
		c(5, {
			fmt([[Co-authored-by: {} <{}@{}.{}>]], {
				i(6, 'Co-author Name'),
				i(7, 'Co-author Email'),
				i(8, 'Co-author Domain'),
				i(9, 'Co-author TLD'),
			}),
			t(),
		}),
	}),
})
