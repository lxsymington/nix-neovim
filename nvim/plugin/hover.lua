local hover = require('hover')

local keymap = vim.keymap
local o = vim.o

hover.setup({
	init = function()
		-- Require providers
		require('hover.providers.lsp')
		require('hover.providers.gh')
		require('hover.providers.gh_user')
		-- require('hover.providers.jira')
		require('hover.providers.dap')
		require('hover.providers.fold_preview')
		require('hover.providers.diagnostic')
		require('hover.providers.man')
		require('hover.providers.dictionary')
		require('hover.providers.highlight')
	end,
	preview_opts = {
		border = 'rounded',
	},
	--[[ providers = {
		-- Require providers
		'hover.providers.lsp',
		'hover.providers.gh',
		'hover.providers.gh_user',
		-- 'hover.providers.jira',
		'hover.providers.dap',
		'hover.providers.fold_preview',
		'hover.providers.diagnostic',
		'hover.providers.man',
		'hover.providers.dictionary',
	}, ]]
	-- Whether the contents of a currently open hover window should be moved
	-- to a :h preview-window when pressing the hover keymap.
	preview_window = false,
	title = true,
	mouse_providers = {
		'LSP',
	},
	mouse_delay = 1000,
})

-- Setup keymaps
vim.keymap.set('n', 'K', hover.hover, { desc = 'hover.nvim' })
vim.keymap.set('n', 'gK', hover.hover_select, { desc = 'hover.nvim (select)' })
vim.keymap.set('n', '<C-p>', function()
	hover.hover_switch('previous')
end, { desc = 'hover.nvim (previous source)' })
vim.keymap.set('n', '<C-n>', function()
	hover.hover_switch('next')
end, { desc = 'hover.nvim (next source)' })

-- Mouse support
keymap.set('n', '<MouseMove>', hover.hover_mouse, {
	desc = 'hover.nvim (mouse)',
})

o.mousemoveevent = true
