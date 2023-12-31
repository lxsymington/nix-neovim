vim.keymap.set('n', '<leader>glf', function()
	vim.cmd.DiffviewFileHistory(vim.api.nvim_buf_get_name(0))
end, { desc = '[diffview] file history (current buffer)' })
vim.keymap.set('n', '<leader>gld', vim.cmd.DiffviewOpen, { desc = '[diffview] open' })
vim.keymap.set('n', '<leader>gd', vim.cmd.DiffviewOpen, { desc = '[diffview] open' })
vim.keymap.set('n', '<leader>df', vim.cmd.DiffviewToggleFiles, { desc = '[diffview] toggle files' })
vim.keymap.set(
	'n',
	'<leader>gf',
	vim.cmd.DiffviewFileHistory,
	{ desc = '[diffview] file history (cwd)' }
)
