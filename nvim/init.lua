local cmd = vim.cmd
local fn = vim.fn
local opt = vim.o
local g = vim.g

-- Builtin –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
cmd.runtime('ftplugin/man.vim')
cmd.runtime('macros/matchit.vim')
cmd.filetype('plugin', 'indent', 'on')
cmd.packadd('cfilter') -- Allows filtering the quickfix list with :cfdo

-- Compatible ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
opt.compatible = false

-- Config ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
require('lxs.config.init').setup()
