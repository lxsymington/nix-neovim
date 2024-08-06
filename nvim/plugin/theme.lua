-- local rose_pine = require('rose-pine')

local cmd = vim.cmd
local opt = vim.opt

-- Theme –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
-- Set terminal to use true color
if vim.fn.exists('+termguicolors') then
	opt.termguicolors = true
end

-- Sets the background to be dark
opt.background = 'dark'

-- Sets the colorscheme to be Crepuscular
cmd.colorscheme('crepuscular')

-- rose_pine.setup({
-- 	variant = 'auto',
-- 	dark_variant = 'main',
-- 	dim_inactive_windows = true,
-- })
-- cmd.colorscheme('rose-pine')
