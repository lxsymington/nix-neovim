local cmd = vim.cmd
local g = vim.g
local opt = vim.opt

-- Theme –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
-- Set terminal to use true color
if vim.fn.exists('+termguicolors') then
	opt.termguicolors = true
end

-- Sets the background to be dark
opt.background = 'dark'

-- Sets the colorscheme to be Crepuscular
cmd.packadd('everforest')
cmd.colorscheme('everforest')
g.colors_name = 'everforest'
