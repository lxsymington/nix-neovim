local opt = vim.opt

-- External –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
-- Use ripgrep instead of grep
opt.grepprg = [[rg --vimgrep --no-heading --smart-case]]
opt.grepformat = [[%f:%l:%c:%m,%f:%l:%m]]
