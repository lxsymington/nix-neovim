if vim.g.did_load_surround_plugin then
	return
end
vim.g.did_load_surround_plugin = true

local surround = require('mini.surround')

-- Mini Surround ———————————————————————————————————————————————————————————————
surround.setup()
