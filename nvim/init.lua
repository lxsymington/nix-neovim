local cmd = vim.cmd
local opt = vim.o

-- Builtin –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
cmd.runtime('ftplugin/man.vim')
cmd.runtime('macros/matchit.vim')
cmd.filetype('plugin', 'indent', 'on')
cmd.packadd('cfilter') -- Allows filtering the quickfix list with :cfdo

-- Syntax ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
cmd.syntax('on')
cmd.syntax('enable')
opt.compatible = false
