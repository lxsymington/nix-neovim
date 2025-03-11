if vim.g.did_load_git_integration_plugin then
	return
end
vim.g.did_load_git_integration_plugin = true

local git = require('mini.git')
local gitsigns = require('gitsigns')
local cmd = vim.cmd
local fn = vim.fn
local keymap = vim.keymap
local wo = vim.wo

git.setup()

gitsigns.setup({
	signs = {
		add = { text = '│' },
		change = { text = '┊' },
		delete = { text = '┌' },
		topdelete = { text = '└' },
		changedelete = { text = '┤' },
		untracked = { text = '╎' },
	},
	signs_staged = {
		add = { text = '┃' },
		change = { text = '┋' },
		delete = { text = '┏' },
		topdelete = { text = '┗' },
		changedelete = { text = '┫' },
		untracked = { text = '╏' },
	},
	signs_staged_enable = true,
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
	diff_opts = {
		internal = true,
	},
	word_diff = true, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = {
		follow_files = true,
	},
	auto_attach = true,
	attach_to_untracked = false,
	current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = true,
		virt_text_priority = 100,
	},
	current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
	sign_priority = 50,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000, -- Disable if file is longer than this (in lines)
	preview_config = {
		-- Options passed to nvim_open_win
		border = 'rounded',
		style = 'minimal',
		relative = 'cursor',
		row = 0,
		col = 1,
		title = 'Diff Preview',
		title_pos = 'right',
	},
	on_attach = function(bufnr)
		-- Navigation
		keymap.set('n', ']c', function()
			if wo.diff then
				cmd.normal({ ']c', bang = true })
			else
				gitsigns.nav_hunk('next')
			end
		end, { buffer = bufnr, desc = 'Next git hunk' })

		keymap.set('n', '[c', function()
			if wo.diff then
				cmd.normal({ '[c', bang = true })
			else
				gitsigns.nav_hunk('prev')
			end
		end, { buffer = bufnr, desc = 'Previous git hunk' })

		-- Actions
		keymap.set('n', '<leader>hs', gitsigns.stage_hunk, { buffer = bufnr, desc = 'Stage hunk' })
		keymap.set('n', '<leader>hr', gitsigns.reset_hunk, { buffer = bufnr, desc = 'Reset hunk' })
		keymap.set('v', '<leader>hs', function()
			gitsigns.stage_hunk({ fn.line('.'), fn.line('v') })
		end, { buffer = bufnr, desc = 'Stage hunk' })
		keymap.set('v', '<leader>hr', function()
			gitsigns.reset_hunk({ fn.line('.'), fn.line('v') })
		end, { buffer = bufnr, desc = 'Reset hunk' })
		keymap.set('n', '<leader>hS', gitsigns.stage_buffer, { buffer = bufnr, desc = 'Stage buffer' })
		keymap.set('n', '<leader>hR', gitsigns.reset_buffer, { buffer = bufnr, desc = 'Reset buffer' })
		keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { buffer = bufnr, desc = 'Preview hunk' })
		keymap.set('n', '<leader>hb', function()
			gitsigns.blame_line({ full = true })
		end, { buffer = bufnr, desc = 'Line - full git blame' })
		keymap.set(
			'n',
			'<leader>hB',
			gitsigns.toggle_current_line_blame,
			{ buffer = bufnr, desc = 'Toggle current line blame' }
		)
		keymap.set('n', '<leader>hd', gitsigns.diffthis, { buffer = bufnr, desc = 'Diff this file' })
		keymap.set('n', '<leader>hD', function()
			gitsigns.diffthis('~')
		end, { buffer = bufnr, desc = 'Diff this file against HEAD~' })
		keymap.set(
			'n',
			'<leader>hP',
			gitsigns.preview_hunk_inline,
			{ buffer = bufnr, desc = 'Preview hunk inline' }
		)

		-- Text object
		keymap.set(
			{ 'o', 'x' },
			'ih',
			':<C-U>Gitsigns select_hunk<CR>',
			{ buffer = bufnr, desc = 'Select hunk' }
		)
	end,
})
