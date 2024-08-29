require('oil').setup({
	columns = {
		'icon',
		'permissions',
		'size',
		'mtime',
	},
	watch_for_changes = true,
})

vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
