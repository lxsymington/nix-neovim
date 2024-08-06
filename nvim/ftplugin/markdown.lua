local markview = require('markview')
local presets = require('markview.presets')
local cmd = vim.cmd

vim.opt_local.list = false

markview.setup({
	headings = presets.headings.glow_labels,
})

cmd('Markview enableAll')
