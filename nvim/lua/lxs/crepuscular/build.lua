local lushwright = require('shipwright.transform.lush')
local cwd = vim.uv.cwd
local fs = vim.fs

-- NOTE: `:h colortest.vim`
-- `:runtime syntax/colortest.vim`

local function live_colour_scheme(colourscheme_path)
	package.loaded[colourscheme_path] = nil
	return require(colourscheme_path)
end

local crepuscular_dawn = fs.joinpath(cwd(), 'nvim', 'colors', 'crepuscular_dawn.lua')
local crepuscular_dusk = fs.joinpath(cwd(), 'nvim', 'colors', 'crepuscular_dusk.lua')

---@diagnostic disable-next-line: undefined-global run is provided by shipwright
run(
	live_colour_scheme('lxs.crepuscular.dawn'),
	lushwright.to_lua,
	---@diagnostic disable-next-line: undefined-global patchwrite is provided by shipwright
	{ patchwrite, crepuscular_dawn, '-- PATCH_OPEN', '-- PATCH_CLOSE' }
)

---@diagnostic disable-next-line: undefined-global run is provided by shipwright
run(
	live_colour_scheme('lxs.crepuscular.dusk'),
	lushwright.to_lua,
	---@diagnostic disable-next-line: undefined-global patchwrite is provided by shipwright
	{ patchwrite, crepuscular_dusk, '-- PATCH_OPEN', '-- PATCH_CLOSE' }
)
