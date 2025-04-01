local trouble = require('trouble')
local todo = require('todo-comments')
local keymap = vim.keymap
local ERROR = vim.diagnostic.severity.ERROR
local WARN = vim.diagnostic.severity.WARN
local INFO = vim.diagnostic.severity.INFO
local HINT = vim.diagnostic.severity.HINT

-- Diagnostic –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
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
		header = 'Diagnostic',
		prefix = '',
	},
}

vim.diagnostic.config(vim.tbl_deep_extend('force', defaults, {
	virtual_lines = {
		current_line = true,
		hl_mode = 'blend',
	},
	virtual_text = {
		hl_mode = 'blend',
		prefix = function(diagnostic)
			local severity = diagnostic.severity
			if severity == ERROR then
				return '󰅚'
			end
			if severity == WARN then
				return '⚠'
			end
			if severity == INFO then
				return '⚐'
			end
			if severity == HINT then
				return '󰌶'
			end
			return '■'
		end,
		spacing = 2,
		virt_text_pos = 'eol',
	},
}))

trouble.setup({
	preview = {
		type = 'split',
		relative = 'win',
		position = 'right',
		size = 0.4,
	},
	modes = {
		cascade = {
			mode = 'diagnostics', -- inherit from diagnostics mode
			filter = function(items)
				local severity = HINT
				for _, item in ipairs(items) do
					severity = math.min(severity, item.severity)
				end
				return vim.tbl_filter(function(item)
					return item.severity == severity
				end, items)
			end,
		},
		document_diagnostics = {
			mode = 'diagnostics',
			filter = { buf = 0 },
		},
		workspace_diagnostics = {
			mode = 'diagnostics',
		},
		quickfix = {
			mode = 'quickfix',
		},
		loclist = {
			mode = 'loclist',
		},
		lsp_references = {
			mode = 'lsp_references',
		},
	},
})

-- Lua
keymap.set('n', '<Leader>xx', function()
	trouble.toggle('cascade')
end, { desc = 'Trouble Toggle' })
keymap.set('n', '<Leader>xw', function()
	trouble.toggle('workspace_diagnostics')
end, { desc = 'Trouble Toggle Workspace' })
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

todo.setup()
