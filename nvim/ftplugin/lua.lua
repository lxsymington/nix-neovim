local lint = require('lint')
local lazydev = require('lazydev')
local icons = require('mini.icons')

vim.bo.comments = ':---,:--'

lint.linters_by_ft = {
	lua = { 'selene' },
}

local icon, _hl, _is_default = icons.get('file', vim.fn.expand('%'))
local ns = lint.get_namespace('selene')
vim.diagnostic.config(
	vim.tbl_deep_extend('force', vim.diagnostic.config(), {
		virtual_text = {
			suffix = string.format(' ⁅%s selene⁆', icon),
		},
	}),
	ns
)

lazydev.setup({
	library = {
		-- See the configuration section for more details
		-- Load luvit types when the `vim.uv` word is found
		{ path = 'luvit-meta/library', words = { 'vim%.uv' } },
	},
	enabled = function(root_dir)
		return not vim.uv.fs_stat(root_dir .. '/.luarc.json')
	end,
})
