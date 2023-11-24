local conform = require('conform')

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

local ignore_filetypes = { 'sql', 'java' }
local slow_format_filetypes = {}
conform.setup({
	formatters_by_ft = {
		lua = { 'stylua' },
		-- Use a sub-list to run only the first available formatter
		javascript = { { 'prettierd', 'prettier' } },
	},
	format_on_save = function(bufnr)
		if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
			return
		end

		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end

		if slow_format_filetypes[vim.bo[bufnr].filetype] then
			return
		end

		local function on_format(err)
			if err and err:match('timeout$') then
				slow_format_filetypes[vim.bo[bufnr].filetype] = true
			end
		end

		return { timeout_ms = 200, lsp_fallback = true }, on_format
	end,
	format_after_save = function(bufnr)
		if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
			return
		end

		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end

		if not slow_format_filetypes[vim.bo[bufnr].filetype] then
			return
		end

		return { lsp_fallback = true }
	end,
})

vim.api.nvim_create_user_command('FormatDisable', function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = 'Disable autoformat-on-save',
	bang = true,
})

vim.api.nvim_create_user_command('FormatEnable', function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = 'Re-enable autoformat-on-save',
})
