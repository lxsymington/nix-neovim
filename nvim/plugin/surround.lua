if vim.g.did_load_surround_plugin then
	return
end
vim.g.did_load_surround_plugin = true

local surround = require('mini.surround')

-- Mini Surround ———————————————————————————————————————————————————————————————
surround.setup({
	highlight_duration = 750,
	search_method = 'cover_or_next',
})
