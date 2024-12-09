if vim.g.did_load_csv_view_plugin then
	return
end

vim.g.did_load_csv_view_plugin = true

vim.cmd.packadd({
	args = { 'csvview' },
	bang = true,
})

local csvview = require('csvview')

csvview.setup({
	view = {
		display_mode = 'border',
	},
})

if not csvview.is_enabled() then
	csvview.enable()
end
