local api = vim.api
local cmd = vim.cmd
local cwd = vim.uv.cwd
local fn = vim.fn
local fs = vim.fs
local log = vim.log
local notify = vim.notify
local opt = vim.opt

-- Theme –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
-- Set terminal to use true color
if fn.exists('+termguicolors') then
	opt.termguicolors = true
end

local shipwright_group = api.nvim_create_augroup('Shipwright build', {
	clear = true,
})

local crepuscular_build = fs.joinpath(cwd(), 'nvim', 'lua', 'lxs', 'crepuscular', 'build.lua')

api.nvim_create_autocmd('BufWritePost', {
	callback = function()
		cmd.Shipwright(crepuscular_build)
		notify('Updating crepuscular colorscheme', log.levels.INFO, {
			title = 'Crepuscular',
		})
	end,
	desc = 'Build native colourschemes from lush specifications',
	group = shipwright_group,
	pattern = '*/lxs/crepuscular/{colours,dawn,dusk,theme}.lua',
})
--
-- Sets the background to be dark - Latest versions of neovim may be able to detect this
opt.background = 'light'
local function colourscheme_variant()
	local variant = opt.background:get() == 'dark' and 'crepuscular_dusk' or 'crepuscular_dawn'

	vim.g.colors_name = variant

	return variant
end

cmd.colorscheme(colourscheme_variant())

local theme_group = api.nvim_create_augroup('Theme', {
	clear = false,
})

api.nvim_create_autocmd('OptionSet', {
	group = theme_group,
	pattern = { 'background' },
	callback = function()
		cmd.colorscheme(colourscheme_variant())
	end,
	desc = 'Switch colourscheme variant based on background option',
})
