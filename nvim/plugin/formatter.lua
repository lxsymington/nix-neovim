local conform = require('conform')

local api = vim.api
local b = vim.b
local bo = vim.bo
local g = vim.g
local o = vim.o

o.formatexpr = "v:lua.require'conform'.formatexpr()"

local ignore_filetypes = { 'sql', 'java' }
local slow_format_filetypes = {}

conform.setup({
	formatters_by_ft = {
		-- Use a sub-list to run only the first available formatter
		javascript = { 'prettierd', 'prettier' },
		lua = { 'stylua' },
		nix = { 'nixpkgs_fmt' },
		tf = { 'terraform_fmt' },
		terraform = { 'terraform_fmt' },
		['terraform-vars'] = { 'terraform_fmt' },
	},
	default_format_opts = {
		stop_after_first = true,
	},
	format_on_save = function(bufnr)
		if vim.tbl_contains(ignore_filetypes, bo[bufnr].filetype) then
			return
		end

		if g.disable_autoformat or b[bufnr].disable_autoformat then
			return
		end

		if slow_format_filetypes[bo[bufnr].filetype] then
			return
		end

		local function on_format(err)
			if err and err:match('timeout$') then
				slow_format_filetypes[bo[bufnr].filetype] = true
			end
		end

		return { timeout_ms = 100, lsp_format = 'fallback' }, on_format
	end,
	format_after_save = function(bufnr)
		if vim.tbl_contains(ignore_filetypes, bo[bufnr].filetype) then
			return
		end

		if g.disable_autoformat or b[bufnr].disable_autoformat then
			return
		end

		if not slow_format_filetypes[bo[bufnr].filetype] then
			return
		end

		return { async = true, lsp_format = 'fallback' }
	end,
})

api.nvim_create_user_command('FormatDisable', function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		b.disable_autoformat = true
	else
		g.disable_autoformat = true
	end
end, {
	desc = 'Disable autoformat-on-save',
	bang = true,
})

api.nvim_create_user_command('FormatEnable', function()
	b.disable_autoformat = false
	g.disable_autoformat = false
end, {
	desc = 'Re-enable autoformat-on-save',
})
