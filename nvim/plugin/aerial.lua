-- Aerial ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
require('aerial').setup({
	ignore = {
		-- Ignore unlisted buffers. See :help buflisted
		unlisted_buffers = false,

		-- List of filetypes to ignore.
		filetypes = {},

		-- Ignored buftypes.
		-- Can be one of the following:
		-- false or nil - No buftypes are ignored.
		-- "special"    - All buffers other than normal, help and man page buffers are ignored.
		-- table        - A list of buftypes to ignore. See :help buftype for the
		--                possible values.
		-- function     - A function that returns true if the buffer should be
		--                ignored or false if it should not be ignored.
		--                Takes two arguments, `bufnr` and `buftype`.
		buftypes = 'special',

		-- Ignored wintypes.
		-- Can be one of the following:
		-- false or nil - No wintypes are ignored.
		-- "special"    - All windows other than normal windows are ignored.
		-- table        - A list of wintypes to ignore. See :help win_gettype() for the
		--                possible values.
		-- function     - A function that returns true if the window should be
		--                ignored or false if it should not be ignored.
		--                Takes two arguments, `winid` and `wintype`.
		wintypes = 'special',
	},
	-- optionally use on_attach to set keymaps when aerial has attached to a buffer
	on_attach = function(bufnr)
		-- Jump forwards/backwards with '{' and '}'
		vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
		vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
	end,
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
