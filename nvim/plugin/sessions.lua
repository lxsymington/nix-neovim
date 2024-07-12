if vim.g.did_load_session_plugin then
	return
end
vim.g.did_load_session_plugin = true

local session = require('mini.sessions')
local keymap = vim.keymap

session.setup({
	autoread = true,
})

keymap.set('n', '<Leader>sw', function()
	session.select('write')
end, { desc = 'Session Write' })
keymap.set('n', '<Leader>ss', function()
	session.select('read')
end, { desc = 'Session Read' })
