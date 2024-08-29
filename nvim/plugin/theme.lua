local cmd = vim.cmd
local opt = vim.opt

-- Theme –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
-- Set terminal to use true color
if vim.fn.exists('+termguicolors') then
	opt.termguicolors = true
end

-- Sets the background to be light
opt.background = 'light'

-- Sets the colorscheme to be Crepuscular
cmd.colorscheme('crepuscular')
