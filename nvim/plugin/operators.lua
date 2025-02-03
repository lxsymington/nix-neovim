local dial_augend = require('dial.augend')
local dial_config = require('dial.config')
local dial_map = require('dial.map')
local keymap = vim.keymap

-- Operators ———————————————————————————————————————————————————————————
dial_config.augends:register_group({
	default = {
		dial_augend.integer.alias.decimal_int,
		dial_augend.integer.alias.hex,
		dial_augend.date.alias['%d/%m/%Y'],
		dial_augend.date.alias['%Y-%m-%d'],
		dial_augend.date.alias['%m/%d'],
		dial_augend.date.alias['%H:%M'],
		dial_augend.constant.alias.bool,
	},
})

keymap.set('n', '<C-a>', function()
	dial_map.manipulate('increment', 'normal')
end, { desc = 'Increment (dial.nvim)' })
keymap.set('n', '<C-x>', function()
	dial_map.manipulate('decrement', 'normal')
end, { desc = 'Decrement (dial.nvim)' })
keymap.set('n', 'g<C-a>', function()
	dial_map.manipulate('increment', 'gnormal')
end, { desc = 'Increment Linewise (dial.nvim)' })
keymap.set('n', 'g<C-x>', function()
	dial_map.manipulate('decrement', 'gnormal')
end, { desc = 'Decrement Linewise (dial.nvim)' })
keymap.set('v', '<C-a>', function()
	dial_map.manipulate('increment', 'visual')
end, { desc = 'Increment (dial.nvim)' })
keymap.set('v', '<C-x>', function()
	dial_map.manipulate('decrement', 'visual')
end, { desc = 'Decrement (dial.nvim)' })
keymap.set('v', 'g<C-a>', function()
	dial_map.manipulate('increment', 'gvisual')
end, { desc = 'Increment Linewise (dial.nvim)' })
keymap.set('v', 'g<C-x>', function()
	dial_map.manipulate('decrement', 'gvisual')
end, { desc = 'Decrement Linewise (dial.nvim)' })
