local dbee = require('dbee')
local keymap = vim.keymap

-- TODO: work out if it is possible to setup connections
dbee.setup()

keymap.set('n', '<Leader>Dt', dbee.toggle, {
	desc = 'Toggle database explorer',
	noremap = true,
})

keymap.set('n', '<Leader>De', function()
	-- TODO: pull the query in the current buffer and execute it
	dbee.execute()
end, {
	desc = 'Toggle database explorer',
	noremap = true,
})
