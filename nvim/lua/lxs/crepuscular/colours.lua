local lush = require('lush')
local hsluv = lush.hsluv

-- CREPUSCULAR —————————————————————————————————————————————————————————————————
local dark_palette_metatable = {
	__index = function(self, key)
		if key == 'foreground' then
			return rawget(self, 'white')
		end

		if key == 'background' then
			return rawget(self, 'black')
		end

		return rawget(self, key)
	end,
}

local light_palette_metatable = {
	__index = function(self, key)
		if key == 'foreground' then
			return rawget(self, 'black')
		end

		if key == 'background' then
			return rawget(self, 'white')
		end

		return rawget(self, key)
	end,
}

local palette_metatable = {
	__index = function(self, key)
		local variant = vim.opt.background:get()

		if vim.tbl_contains({ 'bright', 'dim', 'standard' }, key) then
			return self[variant][key]
		end
		return self[key]
	end,
}

-- Colours
local colours = setmetatable({
	-- Dim Palette
	-- https://accessiblepalette.com/?lightness=95,74,67,60,53,46,39,32,25,5&af6a75=1,0&d6855c=1,0&e6bf99=1,0&825e17=1,0&8aa88f=1,0&50958f=1,0&506d95=1,0&412a6f=1,0&766f74=1,15

	-- Light Palette
	-- https://accessiblepalette.com/?lightness=95,74,67,60,53,46,39,32,25,5&fa9e9e=1,0&ff9d57=1,0&ffbb33=1,0&789550=1,0&4c8ce6=1,0&af8fef=1,0&d6f5f2=1,0&fbf7e9=1,0&a38fa0=1,0

	-- standard Palette
	-- https://accessiblepalette.com/?lightness=95,74,67,60,53,46,39,32,25,5&a3293d=1,0&df6020=1,0&EBCCAD=1,0&E69900=1,0&36633D=1,0&6BC7BF=1,0&1d64C9=1,0&561DC9=1,0&50494E=1,0

	dark = {
		bright = setmetatable({
			black = hsluv('#131016'),
			blue = hsluv('#9CB6F0'),
			cyan = hsluv('#A4BBB8'),
			green = hsluv('#ABBC90'),
			grey = hsluv('#C0B2BE'),
			orange = hsluv('#FF9F5A'),
			purple = hsluv('#C4A9F3'),
			red = hsluv('#F99D9D'),
			white = hsluv('#F5F1E3'),
			yellow = hsluv('#E9AB31'),
		}, dark_palette_metatable),

		dim = setmetatable({
			black = hsluv('#150E1C'),
			blue = hsluv('#ABB7CC'),
			cyan = hsluv('#96BEB9'),
			green = hsluv('#A5BCA8'),
			grey = hsluv('#B9B5B7'),
			orange = hsluv('#E6A88A'),
			purple = hsluv('#BDB1CD'),
			red = hsluv('#D5ACB1'),
			white = hsluv('#FAEFE5'),
			yellow = hsluv('#CAB392'),
		}, dark_palette_metatable),

		standard = setmetatable({
			black = hsluv('#170C21'),
			blue = hsluv('#A9B4E7'),
			cyan = hsluv('#6AC5BD'),
			green = hsluv('#A7BBA9'),
			grey = hsluv('#B8B5B7'),
			orange = hsluv('#F7A179'),
			purple = hsluv('#C7A9EC'),
			red = hsluv('#E0A8A9'),
			white = hsluv('#FAEFE5'),
			yellow = hsluv('#EEA83E'),
		}, dark_palette_metatable),
	},

	light = {
		bright = setmetatable({
			black = hsluv('#131016'),
			blue = hsluv('#406DB1'),
			cyan = hsluv('#63706E'),
			green = hsluv('#5E7440'),
			grey = hsluv('#776975'),
			orange = hsluv('#986038'),
			purple = hsluv('#7762A1'),
			red = hsluv('#935F5F'),
			white = hsluv('#F5F1E3'),
			yellow = hsluv('#8B6724'),
		}, light_palette_metatable),

		dim = setmetatable({
			black = hsluv('#150E1C'),
			blue = hsluv('#526F96'),
			cyan = hsluv('#417671'),
			green = hsluv('#5E7262'),
			grey = hsluv('#736B6F'),
			orange = hsluv('#975F43'),
			purple = hsluv('#786398'),
			red = hsluv('#975C66'),
			white = hsluv('#FAEFE5'),
			yellow = hsluv('#8B6726'),
		}, light_palette_metatable),

		standard = setmetatable({
			black = hsluv('#170C21'),
			blue = hsluv('#326ACB'),
			cyan = hsluv('#437671'),
			green = hsluv('#4F7654'),
			grey = hsluv('#716B70'),
			orange = hsluv('#B34F1D'),
			purple = hsluv('#8250D5'),
			red = hsluv('#B34B55'),
			white = hsluv('#FAEFE5'),
			yellow = hsluv('#946312'),
		}, light_palette_metatable),
	},
}, palette_metatable)

local bright = colours[vim.opt.background:get()].bright
local standard = colours[vim.opt.background:get()].standard

vim.g.terminal_color_0 = standard.black.hex -- black
vim.g.terminal_color_8 = standard.grey.hex -- bright black
vim.g.terminal_color_1 = standard.red.hex -- red
vim.g.terminal_color_9 = bright.red.hex -- bright red
vim.g.terminal_color_2 = standard.green.hex -- green
vim.g.terminal_color_10 = bright.green.hex -- bright green
vim.g.terminal_color_3 = standard.yellow.hex -- yellow
vim.g.terminal_color_11 = bright.yellow.hex -- bright yellow
vim.g.terminal_color_4 = standard.blue.hex -- blue
vim.g.terminal_color_12 = bright.blue.hex -- bright blue
vim.g.terminal_color_5 = standard.purple.hex -- magenta
vim.g.terminal_color_13 = bright.purple.hex -- bright magenta
vim.g.terminal_color_6 = standard.cyan.hex -- cyan
vim.g.terminal_color_14 = bright.cyan.hex -- bright cyan
vim.g.terminal_color_7 = standard.white.hex -- white
vim.g.terminal_color_15 = bright.white.hex -- bright white

return colours
