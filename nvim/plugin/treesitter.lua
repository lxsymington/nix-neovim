if vim.g.did_load_treesitter_plugin then
	return
end
vim.g.did_load_treesitter_plugin = true
vim.g.skip_ts_context_commentstring_module = true

local ntto = require('nvim-treesitter-textobjects')
local ntto_select = require('nvim-treesitter-textobjects.select')
local ntto_move = require('nvim-treesitter-textobjects.move')
local ntto_repeat_move = require('nvim-treesitter-textobjects.repeatable_move')

ntto.setup({
	select = {
		enable = true,
		include_surrounding_whitespace = false,
		-- Automatically jump forward to textobject, similar to targets.vim
		lookahead = true,
		selection_modes = {
			['@parameter.outer'] = 'v', -- charwise
			['@function.outer'] = 'v', -- linewise
			['@class.outer'] = 'V', -- blockwise
		},
	},
	swap = {
		enable = true,
	},
	move = {
		enable = true,
		set_jumps = true, -- whether to set jumps in the jumplist
	},
	lsp_interop = {
		enable = true,
		border = 'rounded',
		floating_preview_opts = {},
		peek_definition_code = {
			['<leader>fo'] = '@function.outer',
			['<leader>Fo'] = '@class.outer',
		},
	},
})

-- keymaps
-- You can use the capture groups defined in `textobjects.scm`
vim.keymap.set({ 'x', 'o' }, 'a/', function()
	ntto_select.select_textobject('@comment.outer', 'textobjects')
end, { desc = 'Select outer comment' })
vim.keymap.set({ 'x', 'o' }, 'aC', function()
	ntto_select.select_textobject('@call.outer', 'textobjects')
end, { desc = 'Select outer call' })
vim.keymap.set({ 'x', 'o' }, 'aP', function()
	ntto_select.select_textobject('@parameter.outer', 'textobjects')
end, { desc = 'Select outer parameter' })
vim.keymap.set({ 'x', 'o' }, 'aa', function()
	ntto_select.select_textobject('@assignment.outer', 'textobjects')
end, { desc = 'Select outer assignment' })
vim.keymap.set({ 'x', 'o' }, 'ac', function()
	ntto_select.select_textobject('@class.outer', 'textobjects')
end, { desc = 'Select outer class' })
vim.keymap.set({ 'x', 'o' }, 'af', function()
	ntto_select.select_textobject('@function.outer', 'textobjects')
end, { desc = 'Select outer function' })
vim.keymap.set({ 'x', 'o' }, 'ai', function()
	ntto_select.select_textobject('@conditional.outer', 'textobjects')
end, { desc = 'Select outer conditional' })
vim.keymap.set({ 'x', 'o' }, 'al', function()
	ntto_select.select_textobject('@loop.outer', 'textobjects')
end, { desc = 'Select outer loop' })
vim.keymap.set({ 'x', 'o' }, 'aS', function()
	require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals')
end, { desc = 'Select local scope' })

vim.keymap.set({ 'x', 'o' }, 'i/', function()
	ntto_select.select_textobject('@comment.inner', 'textobjects')
end, { desc = 'Select inner comment' })
vim.keymap.set({ 'x', 'o' }, 'iC', function()
	ntto_select.select_textobject('@call.inner', 'textobjects')
end, { desc = 'Select inner call' })
vim.keymap.set({ 'x', 'o' }, 'iP', function()
	ntto_select.select_textobject('@parameter.inner', 'textobjects')
end, { desc = 'Select inner parameter' })
vim.keymap.set({ 'x', 'o' }, 'ia', function()
	ntto_select.select_textobject('@assignment.inner', 'textobjects')
end, { desc = 'Select inner assignment' })
vim.keymap.set({ 'x', 'o' }, 'ic', function()
	ntto_select.select_textobject('@class.inner', 'textobjects')
end, { desc = 'Select inner class' })
vim.keymap.set({ 'x', 'o' }, 'if', function()
	ntto_select.select_textobject('@function.inner', 'textobjects')
end, { desc = 'Select inner function' })
vim.keymap.set({ 'x', 'o' }, 'ii', function()
	ntto_select.select_textobject('@conditional.inner', 'textobjects')
end, { desc = 'Select inner conditional' })
vim.keymap.set({ 'x', 'o' }, 'il', function()
	ntto_select.select_textobject('@loop.inner', 'textobjects')
end, { desc = 'Select inner loop' })

vim.keymap.set({ 'n', 'x', 'o' }, ';', ntto_repeat_move.repeat_last_move)
vim.keymap.set({ 'n', 'x', 'o' }, ',', ntto_repeat_move.repeat_last_move_opposite)

vim.keymap.set('n', '<leader>p', function()
	require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
end, { desc = 'Swap parameter with next' })
vim.keymap.set('n', '<leader>P', function()
	require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.outer')
end, { desc = 'Swap parameter with previous' })

vim.keymap.set({ 'n', 'x', 'o' }, ']a', function()
	ntto_move.goto_next_start('@argument.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
	ntto_move.goto_next_start('@function.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
	ntto_move.goto_next_start('@method.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, ']p', function()
	ntto_move.goto_next_start('@parameter.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, ']s', function()
	ntto_move.goto_next_start('@local.scope', 'locals')
end)
vim.keymap.set({ 'n', 'x', 'o' }, ']z', function()
	ntto_move.goto_next_start('@fold', 'folds')
end)

vim.keymap.set({ 'n', 'x', 'o' }, ']A', function()
	ntto_move.goto_next_end('@argument.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, ']F', function()
	ntto_move.goto_next_end('@function.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
	ntto_move.goto_next_end('@method.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, ']P', function()
	ntto_move.goto_next_end('@parameter.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, ']S', function()
	ntto_move.goto_next_end('@local.scope', 'locals')
end)
vim.keymap.set({ 'n', 'x', 'o' }, ']Z', function()
	ntto_move.goto_next_end('@fold', 'folds')
end)

vim.keymap.set({ 'n', 'x', 'o' }, '[a', function()
	ntto_move.goto_previous_start('@argument.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
	ntto_move.goto_previous_start('@function.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
	ntto_move.goto_previous_start('@method.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[p', function()
	ntto_move.goto_previous_start('@parameter.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[s', function()
	ntto_move.goto_previous_start('@local.scope', 'locals')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[z', function()
	ntto_move.goto_previous_start('@fold', 'folds')
end)

vim.keymap.set({ 'n', 'x', 'o' }, '[A', function()
	ntto_move.goto_previous_end('@argument.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[F', function()
	ntto_move.goto_previous_end('@function.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
	ntto_move.goto_previous_end('@method.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[P', function()
	ntto_move.goto_previous_end('@parameter.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[S', function()
	ntto_move.goto_previous_end('@local.scope', 'locals')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[Z', function()
	ntto_move.goto_previous_end('@fold', 'folds')
end)

require('treesitter-context').setup({
	max_lines = 5,
})

require('treesj').setup({})

vim.keymap.set('n', '[C', function()
	require('treesitter-context').go_to_context(vim.v.count1)
end, { desc = 'Previous context', silent = true })

vim.keymap.set('n', '<leader>ct', '<Cmd>TSContext toggle<CR>', { desc = 'Context Toggle' })

pcall(vim.treesitter.language.register, 'terraform', 'terraform-vars')
