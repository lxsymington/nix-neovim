local api = vim.api
local fn = vim.fn
local keymap = vim.keymap
local diagnostic = vim.diagnostic

-- Convenient normal mode
keymap.set('i', 'jj', '<esc>', { silent = true, desc = 'Return to normal mode' })

-- Yank from the current position till end of current line
keymap.set('n', 'Y', 'y$', { desc = 'Yank to the end of the line' })

-- Buffer list navigation
keymap.set('n', '[b', vim.cmd.bprevious, { silent = true, desc = 'previous buffer' })
keymap.set('n', ']b', vim.cmd.bnext, { silent = true, desc = 'next buffer' })
keymap.set('n', '[B', vim.cmd.bfirst, { silent = true, desc = 'first buffer' })
keymap.set('n', ']B', vim.cmd.blast, { silent = true, desc = 'last buffer' })

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

local function try_fallback_notify(opts)
	local success, _ = pcall(opts.try)
	if success then
		return
	end
	success, _ = pcall(opts.fallback)
	if success then
		return
	end
	vim.notify(opts.notify, vim.log.levels.INFO)
end

-- Cycle the quickfix and location lists
local function cleft()
	try_fallback_notify({
		try = vim.cmd.cprev,
		fallback = vim.cmd.clast,
		notify = 'Quickfix list is empty!',
	})
end

local function cright()
	try_fallback_notify({
		try = vim.cmd.cnext,
		fallback = vim.cmd.cfirst,
		notify = 'Quickfix list is empty!',
	})
end

keymap.set('n', '[q', cleft, { silent = true, desc = 'cycle quickfix left' })
keymap.set('n', ']q', cright, { silent = true, desc = 'cycle quickfix right' })
keymap.set('n', '[Q', vim.cmd.cfirst, { silent = true, desc = 'first quickfix entry' })
keymap.set('n', ']Q', vim.cmd.clast, { silent = true, desc = 'last quickfix entry' })

local function lleft()
	try_fallback_notify({
		try = vim.cmd.lprev,
		fallback = vim.cmd.llast,
		notify = 'Location list is empty!',
	})
end

local function lright()
	try_fallback_notify({
		try = vim.cmd.lnext,
		fallback = vim.cmd.lfirst,
		notify = 'Location list is empty!',
	})
end

keymap.set('n', '[l', lleft, { silent = true, desc = 'cycle loclist left' })
keymap.set('n', ']l', lright, { silent = true, desc = 'cycle loclist right' })
keymap.set('n', '[L', vim.cmd.lfirst, { silent = true, desc = 'first loclist entry' })
keymap.set('n', ']L', vim.cmd.llast, { silent = true, desc = 'last loclist entry' })

-- Resize vertical splits
local toIntegral = math.ceil
keymap.set('n', '<leader>w+', function()
	local curWinWidth = api.nvim_win_get_width(0)
	api.nvim_win_set_width(0, toIntegral(curWinWidth * 3 / 2))
end, { silent = true, desc = 'inc window width' })
keymap.set('n', '<leader>w-', function()
	local curWinWidth = api.nvim_win_get_width(0)
	api.nvim_win_set_width(0, toIntegral(curWinWidth * 2 / 3))
end, { silent = true, desc = 'dec window width' })
keymap.set('n', '<leader>h+', function()
	local curWinHeight = api.nvim_win_get_height(0)
	api.nvim_win_set_height(0, toIntegral(curWinHeight * 3 / 2))
end, { silent = true, desc = 'inc window height' })
keymap.set('n', '<leader>h-', function()
	local curWinHeight = api.nvim_win_get_height(0)
	api.nvim_win_set_height(0, toIntegral(curWinHeight * 2 / 3))
end, { silent = true, desc = 'dec window height' })

-- Close floating windows [Neovim 0.10 and above]
keymap.set('n', '<leader>fq', function()
	vim.cmd('fclose!')
end, { silent = true, desc = 'close all floating windows' })

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

keymap.set('n', '<space>tn', vim.cmd.tabnew, { desc = 'new tab' })
keymap.set('n', '<space>tq', vim.cmd.tabclose, { desc = 'close tab' })

local severity = diagnostic.severity

keymap.set('n', '<space>e', function()
	local _, winid = diagnostic.open_float(nil, { scope = 'line' })
	if not winid then
		vim.notify('no diagnostics found', vim.log.levels.INFO)
		return
	end
	vim.api.nvim_win_set_config(winid or 0, { focusable = true })
end, { noremap = true, silent = true, desc = 'diagnostics floating window' })
keymap.set(
	'n',
	'[d',
	diagnostic.goto_prev,
	{ noremap = true, silent = true, desc = 'previous diagnostic' }
)
keymap.set(
	'n',
	']d',
	diagnostic.goto_next,
	{ noremap = true, silent = true, desc = 'next diagnostic' }
)
keymap.set('n', '[e', function()
	diagnostic.goto_prev({
		severity = severity.ERROR,
	})
end, { noremap = true, silent = true, desc = 'previous error diagnostic' })
keymap.set('n', ']e', function()
	diagnostic.goto_next({
		severity = severity.ERROR,
	})
end, { noremap = true, silent = true, desc = 'next error diagnostic' })
keymap.set('n', '[w', function()
	diagnostic.goto_prev({
		severity = severity.WARN,
	})
end, { noremap = true, silent = true, desc = 'previous warning diagnostic' })
keymap.set('n', ']w', function()
	diagnostic.goto_next({
		severity = severity.WARN,
	})
end, { noremap = true, silent = true, desc = 'next warning diagnostic' })
keymap.set('n', '[?', function()
	diagnostic.goto_prev({
		severity = severity.HINT,
	})
end, { noremap = true, silent = true, desc = 'previous hint diagnostic' })
keymap.set('n', ']?', function()
	diagnostic.goto_next({
		severity = severity.HINT,
	})
end, { noremap = true, silent = true, desc = 'next hint diagnostic' })

local function toggle_spell_check()
	---@diagnostic disable-next-line: param-type-mismatch
	vim.opt.spell = not (vim.opt.spell:get())
end

keymap.set(
	'n',
	'<leader>S',
	toggle_spell_check,
	{ noremap = true, silent = true, desc = 'toggle spell' }
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
	'<cmd>TSHighlightCapturesUnderCursor<cr>',
	{ silent = true, desc = 'Show treesitter highlight information' }
)
