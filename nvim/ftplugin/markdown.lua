local markview = require('markview')
local presets = require('markview.presets')
local writing = require('lxs.writing')

vim.opt_local.list = false

markview.setup({
	headings = presets.headings.glow_labels,
})

writing.start()
