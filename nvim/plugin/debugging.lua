if vim.g.did_load_debugging_plugin then
	return
end

vim.g.did_load_debugging_plugin_plugin = true

local debugging = require('lxs.dap')

debugging.start()
debugging.keymaps()
