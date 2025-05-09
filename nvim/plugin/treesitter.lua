if vim.g.did_load_treesitter_plugin then
	return
end
vim.g.did_load_treesitter_plugin = true
vim.g.skip_ts_context_commentstring_module = true

local configs = require('nvim-treesitter.configs')

---@diagnostic disable-next-line: missing-fields
configs.setup({
	modules = {
		'highlight',
		'textobjects',
	},
	highlight = {
		enable = true,
		disable = function(_, buf)
			local max_filesize = 100 * 1024 -- 100 KiB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
	},
	textobjects = {
		select = {
			enable = true,
			-- Automatically jump forward to textobject, similar to targets.vim
			lookahead = true,
			keymaps = {
				['a/'] = '@comment.outer',
				['aC'] = '@call.outer',
				['aP'] = '@parameter.outer',
				['aa'] = '@assignment.outer',
				['ac'] = '@class.outer',
				['af'] = '@function.outer',
				['ai'] = '@conditional.outer',
				['al'] = '@loop.outer',
				['as'] = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
				['i/'] = '@comment.outer',
				['iC'] = '@call.inner',
				['iP'] = '@parameter.inner',
				['ia'] = '@assignment.inner',
				['ic'] = '@class.inner',
				['if'] = '@function.inner',
				['ii'] = '@conditional.outer',
				['il'] = '@loop.inner',
				['is'] = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
			},
			selection_modes = {
				['@parameter.outer'] = 'v', -- charwise
				['@function.outer'] = 'v', -- linewise
				['@class.outer'] = 'V', -- blockwise
			},
		},
		swap = {
			enable = true,
			swap_next = {
				['<leader>p'] = '@parameter.inner',
			},
			swap_previous = {
				['<leader>P'] = '@parameter.inner',
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				[']a'] = '@argument.outer',
				[']f'] = '@function.outer',
				[']m'] = '@method.outer',
				[']P'] = '@parameter.outer',
				[']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
				[']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
			},
			goto_next_end = {
				[']A'] = '@argument.outer',
				[']F'] = '@function.outer',
				[']M'] = '@method.outer',
				[']P'] = '@parameter.outer',
				[']S'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
				[']Z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
			},
			goto_previous_start = {
				['[a'] = '@argument.outer',
				['[f'] = '@function.outer',
				['[m'] = '@method.outer',
				['[P'] = '@parameter.outer',
				['[s'] = { query = '@scope', query_group = 'locals', desc = 'Previous scope' },
				['[z'] = { query = '@fold', query_group = 'folds', desc = 'Previous fold' },
			},
			goto_previous_end = {
				['[A'] = '@argument.outer',
				['[F'] = '@function.outer',
				['[M'] = '@method.outer',
				['[P'] = '@parameter.outer',
				['[S'] = { query = '@scope', query_group = 'locals', desc = 'Previous scope' },
				['[Z'] = { query = '@fold', query_group = 'folds', desc = 'Previous fold' },
			},
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
	},
})

require('treesitter-context').setup({
	max_lines = 5,
})

require('treesj').setup({})

pcall(vim.treesitter.language.register, 'terraform', 'terraform-vars')
