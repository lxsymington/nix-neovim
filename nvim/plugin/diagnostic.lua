local trouble = require('trouble')
local keymap = vim.keymap
local ERROR = vim.diagnostic.severity.ERROR
local WARN = vim.diagnostic.severity.WARN
local INFO = vim.diagnostic.severity.INFO
local HINT = vim.diagnostic.severity.HINT

-- Diagnostic –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
-- Configure Neovim diagnostic messages
local function prefix_diagnostic(prefix, diagnostic)
	return string.format(prefix .. ' %s', diagnostic.message)
end

local defaults = {
	signs = {
		text = {
			[ERROR] = '󰅚',
			[WARN] = '⚠',
			[INFO] = '⚐',
			[HINT] = '󰌶',
		},
		texthl = {
			[ERROR] = 'DiagnosticSignError',
			[WARN] = 'DiagnosticSignWarn',
			[INFO] = 'DiagnosticSignInfo',
			[HINT] = 'DiagnosticSignHint',
		},
	},
	update_in_insert = true,
	underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = 'minimal',
		border = 'rounded',
		source = 'always',
		header = '',
		prefix = '',
	},
}

vim.diagnostic.config(vim.tbl_deep_extend('force', defaults, {
	virtual_text = {
		prefix = '',
		format = function(diagnostic)
			local severity = diagnostic.severity
			if severity == ERROR then
				return prefix_diagnostic('󰅚', diagnostic)
			end
			if severity == WARN then
				return prefix_diagnostic('⚠', diagnostic)
			end
			if severity == INFO then
				return prefix_diagnostic('⚐', diagnostic)
			end
			if severity == HINT then
				return prefix_diagnostic('󰌶', diagnostic)
			end
			return prefix_diagnostic('■', diagnostic)
		end,
	},
}))

-- Lua
keymap.set('n', '<Leader>xx', trouble.toggle)
keymap.set('n', '<Leader>xw', function()
	trouble.toggle('workspace_diagnostics')
end)
keymap.set('n', '<Leader>xd', function()
	trouble.toggle('document_diagnostics')
end)
keymap.set('n', '<Leader>xq', function()
	trouble.toggle('quickfix')
end)
keymap.set('n', '<Leader>xl', function()
	trouble.toggle('loclist')
end)
keymap.set('n', '<Leader>xr', function()
	trouble.toggle('lsp_references')
end)
