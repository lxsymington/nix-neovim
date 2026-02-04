local tasks = require('lxs.tasks')
local keymap = vim.keymap

-- Tasks ———————————————————————————————————————————————————————————————————————
keymap.set('n', '<Leader>ot', function()
	tasks:toggle()
end, {
	desc = 'Tasks » Toggle',
	silent = true,
})
keymap.set('n', '<Leader>oa', function()
	tasks:action()
end, {
	desc = 'Overseer » Run Action',
	silent = true,
})
keymap.set('n', '<Leader>or', function()
	tasks:run()
end, {
	desc = 'Overseer » Run',
	silent = true,
})
keymap.set('n', '<Leader>co', function()
	tasks:compile()
end, {
	desc = 'Compiler » Open',
	silent = true,
})
