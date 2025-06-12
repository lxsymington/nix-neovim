if vim.g.did_load_keymaps_plugin then
	return
end
vim.g.did_load_keymaps_plugin = true

local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local keymap = vim.keymap
local diagnostic = vim.diagnostic

-- Convenient normal mode
keymap.set('i', 'jj', '<esc>', { silent = true, desc = 'Return to normal mode' })

-- Buffer list navigation
keymap.set('n', '[b', vim.cmd.bprevious, { silent = true, desc = 'previous [b]uffer' })
keymap.set('n', ']b', vim.cmd.bnext, { silent = true, desc = 'next [b]uffer' })
keymap.set('n', '[B', vim.cmd.bfirst, { silent = true, desc = 'first [B]uffer' })
keymap.set('n', ']B', vim.cmd.blast, { silent = true, desc = 'last [B]uffer' })

-- Toggle the quickfix list (only opens if it is populated)
local function toggle_qf_list()
	local qf_exists = false
	for _, win in pairs(fn.getwininfo() or {}) do
		if win['quickfix'] == 1 then
			qf_exists = true
		end
	end
	if qf_exists == true then
		vim.cmd.cclose()
		return
	end
	if not vim.tbl_isempty(vim.fn.getqflist()) then
		vim.cmd.copen()
	end
end

keymap.set('n', '\\q', toggle_qf_list, { desc = 'toggle quickfix list' })

-- Remap Esc to switch to normal mode and Ctrl-Esc to pass Esc to terminal
keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'switch to normal mode' })
keymap.set('t', '<C-Esc>', '<Esc>', { desc = 'send Esc to terminal' })

-- Shortcut for expanding to current buffer's directory in command mode
keymap.set('c', '%%', function()
	if fn.getcmdtype() == ':' then
		return fn.expand('%:h') .. '/'
	else
		return '%%'
	end
end, { expr = true, desc = "expand to current buffer's directory" })

local severity = diagnostic.severity

keymap.set('n', '<leader>e', function()
	local _, winid = diagnostic.open_float(nil, { scope = 'line' })
	if not winid then
		vim.notify('no diagnostics found', vim.log.levels.INFO)
		return
	end
	vim.api.nvim_win_set_config(winid or 0, { focusable = true })
end, { noremap = true, silent = true, desc = 'diagnostics floating window' })

keymap.set('n', '[e', function()
	diagnostic.jump({
		count = -1,
		severity = severity.ERROR,
	})
end, { noremap = true, silent = true, desc = 'previous [e]rror diagnostic' })

keymap.set('n', ']e', function()
	diagnostic.jump({
		count = 1,
		severity = severity.ERROR,
	})
end, { noremap = true, silent = true, desc = 'next [e]rror diagnostic' })

keymap.set('n', '[w', function()
	diagnostic.jump({
		count = -1,
		severity = severity.WARN,
	})
end, { noremap = true, silent = true, desc = 'previous [w]arning diagnostic' })

keymap.set('n', ']w', function()
	diagnostic.jump({
		count = 1,
		severity = severity.WARN,
	})
end, { noremap = true, silent = true, desc = 'next [w]arning diagnostic' })

keymap.set('n', '[i', function()
	diagnostic.jump({
		count = -1,
		severity = severity.INFO,
	})
end, { noremap = true, silent = true, desc = 'previous [i]nfo diagnostic' })

keymap.set('n', ']i', function()
	diagnostic.jump({
		count = 1,
		severity = severity.INFO,
	})
end, { noremap = true, silent = true, desc = 'next [i]nfo diagnostic' })

keymap.set('n', '[h', function()
	diagnostic.jump({
		count = -1,
		severity = severity.HINT,
	})
end, { noremap = true, silent = true, desc = 'previous [h]int diagnostic' })

keymap.set('n', ']h', function()
	diagnostic.jump({
		count = 1,
		severity = severity.HINT,
	})
end, { noremap = true, silent = true, desc = 'next [h]int diagnostic' })

local function toggle_spell_check()
	---@diagnostic disable-next-line: param-type-mismatch
	vim.opt.spell = not (vim.opt.spell:get())
end

keymap.set(
	'n',
	'<leader>S',
	toggle_spell_check,
	{ noremap = true, silent = true, desc = 'toggle [S]pell' }
)

-- Clear highlighting
keymap.set(
	'n',
	'<Leader>_',
	'<cmd>nohlsearch<cr>',
	{ silent = true, desc = 'Clear search highlighting' }
)

-- Keymap to show information about the Highlight under the cursor
keymap.set(
	'n',
	'<Leader>H',
	cmd.Inspect,
	{ silent = true, desc = 'Show treesitter highlight information' }
)

-- TODO: Evaluate the current line
keymap.set(
	'n',
	'<Leader>=',
	'<cmd>s/.*/\\=luaeval(submatch(0))<CR>',
	{ silent = true, desc = 'Evaluate the current line' }
)

-- TODO: establish whether this is actually necessary
keymap.set('i', '<A-3>', '#', { noremap = true, silent = true, desc = 'Insert a literal #' })
