if vim.g.did_load_session_plugin then
	return
end
vim.g.did_load_session_plugin = true

local session = require('mini.sessions')

session.setup()
