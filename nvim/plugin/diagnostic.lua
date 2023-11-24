local lsp_lines = require('lsp_lines')

-- Diagnostic –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
lsp_lines.setup()
-- Configure Neovim diagnostic messages
local function prefix_diagnostic(prefix, diagnostic)
	return string.format(prefix .. ' %s', diagnostic.message)
end

local defaults = {
	virtual_text = false,
	virtual_lines = true,
	signs = true,
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

local function toggle_lsp_lines()
	local use_lines = lsp_lines.toggle()

	if use_lines then
		vim.diagnostic.config(defaults)
	else
		vim.diagnostic.config(vim.tbl_deep_extend('force', defaults, {
			virtual_lines = false,
			virtual_text = {
				prefix = '',
				format = function(diagnostic)
					local severity = diagnostic.severity
					if severity == vim.diagnostic.severity.ERROR then
						return prefix_diagnostic('󰅚', diagnostic)
					end
					if severity == vim.diagnostic.severity.WARN then
						return prefix_diagnostic('⚠', diagnostic)
					end
					if severity == vim.diagnostic.severity.INFO then
						return prefix_diagnostic('⚐', diagnostic)
					end
					if severity == vim.diagnostic.severity.HINT then
						return prefix_diagnostic('󰌶', diagnostic)
					end
					return prefix_diagnostic('■', diagnostic)
				end,
			},
		}))
	end
end

vim.diagnostic.config(defaults)

vim.keymap.set('', '<Leader>L', toggle_lsp_lines, { desc = 'Toggle lsp_lines' })
