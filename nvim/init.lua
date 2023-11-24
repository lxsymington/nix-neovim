local cmd = vim.cmd
local fn = vim.fn
local opt = vim.o
local g = vim.g

-- Builtin –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
cmd.runtime('ftplugin/man.vim')
cmd.runtime('macros/matchit.vim')
cmd.filetype('plugin', 'indent', 'on')
cmd.packadd('cfilter') -- Allows filtering the quickfix list with :cfdo

-- Syntax ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
cmd.syntax('on')
cmd.syntax('enable')
opt.compatible = false

-- Config ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
require('lxs.config.init').setup()

local sign = function(opts)
	fn.sign_define(opts.name, {
		texthl = opts.name,
		text = opts.text,
		numhl = '',
	})
end

-- Requires Nerd fonts
sign({ name = 'DiagnosticSignError', text = '󰅚' })
sign({ name = 'DiagnosticSignWarn', text = '⚠' })
sign({ name = 'DiagnosticSignInfo', text = '⚐' })
sign({ name = 'DiagnosticSignHint', text = '󰌶' })
