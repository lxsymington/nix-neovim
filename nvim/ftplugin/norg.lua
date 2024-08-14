local writing = require('lxs.writing')
local wo = vim.wo
local opt = vim.opt
local keymap = vim.keymap

-- Recommended settings for norg
wo.foldlevel = 99
wo.conceallevel = 2

-- Use a fixed width for documents to aid readability
opt.textwidth = 62
opt.formatoptions = 'tcro/qwan1]j'

keymap.set('n', '<leader>P', '<Cmd>Neorg presenter start<CR>')
keymap.set('n', '<C-L>', '<Plug>(neorg.presenter.next-page)')
keymap.set('n', '<C-H>', '<Plug>(neorg.presenter.previous-page)')
keymap.set('n', 'q', '<Plug>(neorg.presenter.close)')

keymap.set('n', '<leader>lg', '<Plug>(neorg.looking-glass.magnify-code-block)')

writing.start()
