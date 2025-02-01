local markview = require('markview')
local presets = require('markview.presets')
local checkboxes = require('markview.extras.checkboxes')
local writing = require('lxs.writing')

vim.opt_local.list = false

markview.setup({
	preview = {
		filetypes = { 'codecompanion', 'markdown' },
		render_distance = { 60, 60 },
	},
	markdown = {
		headings = presets.headings.marker,
		tables = presets.tables.rounded,
	},
})

-- Load the checkboxes module.
checkboxes.setup()

writing.start()
