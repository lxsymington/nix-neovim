if vim.g.did_load_pairing_plugin then
	return
end
vim.g.did_load_pairing_plugin = true

local pairing = require('mini.pairs')

pairing.setup({})
