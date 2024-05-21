if vim.g.did_load_autocommands_plugin then
	return
end
vim.g.did_load_autocommands_plugin = true

local api = vim.api

local tempdirgroup = api.nvim_create_augroup('tempdir', { clear = true })
-- Do not set undofile for files in /tmp
api.nvim_create_autocmd('BufWritePre', {
	pattern = '/tmp/*',
	group = tempdirgroup,
	callback = function()
		vim.cmd.setlocal('noundofile')
	end,
})

-- Disable spell checking in terminal buffers
local nospell_group = api.nvim_create_augroup('nospell', { clear = true })
api.nvim_create_autocmd('TermOpen', {
	group = nospell_group,
	callback = function()
		vim.wo[0].spell = false
	end,
})

-- LSP
local keymap = vim.keymap

--- Don't create a comment string when hitting <Enter> on a comment line
vim.api.nvim_create_autocmd('BufEnter', {
	group = vim.api.nvim_create_augroup('DisableNewLineAutoCommentString', {}),
	callback = function()
		vim.opt.formatoptions = vim.opt.formatoptions - { 'c', 'r', 'o' }
	end,
})

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = require('lxs.lsp').attach,
})

-- More examples, disabled by default

-- Toggle between relative/absolute line numbers
-- Show relative line numbers in the current buffer,
-- absolute line numbers in inactive buffers
local numbertoggle = api.nvim_create_augroup('numbertoggle', { clear = true })
api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
	pattern = '*',
	group = numbertoggle,
	callback = function()
		if vim.o.nu and vim.api.nvim_get_mode().mode ~= 'i' then
			vim.opt.relativenumber = true
		end
	end,
})

api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
	pattern = '*',
	group = numbertoggle,
	callback = function()
		if vim.o.nu then
			vim.opt.relativenumber = false
			vim.cmd.redraw()
		end
	end,
})

local highlight_yank = api.nvim_create_augroup('highlight_yank', { clear = true })
api.nvim_create_autocmd('TextYankPost', {
	pattern = '*',
	group = highlight_yank,
	callback = function()
		vim.highlight.on_yank({
			higroup = 'IncSearch',
			timeout = 150,
		})
	end,
})

local terminal_style = api.nvim_create_augroup('terminal_style', { clear = true })
api.nvim_create_autocmd({ 'TermOpen', 'TermEnter' }, {
	pattern = '*',
	group = terminal_style,
	callback = function()
		-- Disables line numbers
		vim.opt.number = false
		vim.opt.relativenumber = false

		-- Remove the signcolumn
		vim.opt.signcolumn = 'no'

		-- Remove the foldcolumn
		vim.opt.foldcolumn = '0'
	end,
})
