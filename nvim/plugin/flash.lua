local Flash = require('flash')
local keymap = vim.keymap

Flash.setup({
	modes = {
		char = {
			jump_labels = true,
		},
	},
})

keymap.set({ 'n', 'x', 'o' }, '_j', function()
	require('flash').jump({
		matcher = function(win)
			---@param diag Diagnostic
			return vim.tbl_map(function(diag)
				return {
					pos = { diag.lnum + 1, diag.col },
					end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
				}
			end, vim.diagnostic.get(vim.api.nvim_win_get_buf(win)))
		end,
		action = function(match, state)
			vim.api.nvim_win_call(match.win, function()
				vim.api.nvim_win_set_cursor(match.win, match.pos)
				vim.diagnostic.open_float()
			end)
			state:restore()
		end,
	})
end, { desc = 'Flash' })

keymap.set({ 'n', 'x', 'o' }, '_t', function()
	require('flash').treesitter()
end, { desc = 'Flash Treesitter' })

keymap.set('o', '_', function()
	require('flash').remote()
end, { desc = 'Remote Flash' })

keymap.set({ 'o', 'x' }, 'm', function()
	require('flash').treesitter_search()
end, { desc = 'Treesitter Search' })

keymap.set({ 'c' }, '_T', function()
	require('flash').toggle()
end, { desc = 'Toggle Flash Search' })
