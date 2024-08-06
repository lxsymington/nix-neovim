local lush = require('lush')
local hsl = lush.hsl

-- CREPUSCULAR —————————————————————————————————————————————————————————————————

-- Colours
local colours = {
	black = hsl(275, 20, 10),
	blue = hsl(215, 75, 45),
	cyan = hsl(175, 45, 60),
	green = hsl(130, 30, 30),
	grey = hsl(315, 5, 30),
	orange = hsl(20, 75, 50),
	purple = hsl(260, 75, 45),
	red = hsl(350, 60, 40),
	white = hsl(30, 60, 80),
	yellow = hsl(40, 100, 45),

	lightBlack = hsl(275, 25, 15),
	lightBlue = hsl(215, 75, 60),
	lightCyan = hsl(175, 60, 90),
	lightGreen = hsl(85, 30, 45),
	lightGrey = hsl(310, 10, 60),
	lightOrange = hsl(25, 100, 67),
	lightPurple = hsl(260, 75, 75),
	lightRed = hsl(0, 90, 80),
	lightWhite = hsl(45, 70, 95),
	lightYellow = hsl(40, 100, 60),

	-- Dim Palette
	-- https://accessiblepalette.com/?lightness=95,74,67,60,53,46,39,32,25,5&af6a75=1,0&d6855c=1,0&e6bf99=1,0&825e17=1,0&8aa88f=1,0&50958f=1,0&506d95=1,0&412a6f=1,0&766f74=1,15

	-- Light Palette
	-- https://accessiblepalette.com/?lightness=95,74,67,60,53,46,39,32,25,5&fa9e9e=1,0&ff9d57=1,0&ffbb33=1,0&789550=1,0&4c8ce6=1,0&af8fef=1,0&d6f5f2=1,0&fbf7e9=1,0&a38fa0=1,0

	-- standard Palette
	-- https://accessiblepalette.com/?lightness=95,74,67,60,53,46,39,32,25,5&a3293d=1,0&df6020=1,0&EBCCAD=1,0&E69900=1,0&36633D=1,0&6BC7BF=1,0&1d64C9=1,0&561DC9=1,0&50494E=1,0

	dark = {
		dim = {
			black = hsl('#150E1C'),
			blue = hsl('#ABB7CC'),
			cyan = hsl('#96BEB9'),
			green = hsl('#A5BCA8'),
			grey = hsl('#B9B5B7'),
			orange = hsl('#E6A88A'),
			purple = hsl('#BDB1CD'),
			red = hsl('#D5ACB1'),
			white = hsl('#FAEFE5'),
			yellow = hsl('#CAB392'),
		},

		bright = {
			black = hsl('#131016'),
			blue = hsl('#9CB6F0'),
			cyan = hsl('#A4BBB8'),
			green = hsl('#ABBC90'),
			grey = hsl('#C0B2BE'),
			orange = hsl('#FF9F5A'),
			purple = hsl('#C4A9F3'),
			red = hsl('#F99D9D'),
			white = hsl('#F5F1E3'),
			yellow = hsl('#E9AB31'),
		},

		standard = {
			black = hsl('#170C21'),
			blue = hsl('#A9B4E7'),
			cyan = hsl('#6AC5BD'),
			green = hsl('#A7BBA9'),
			grey = hsl('#B8B5B7'),
			orange = hsl('#F7A179'),
			purple = hsl('#C7A9EC'),
			red = hsl('#E0A8A9'),
			white = hsl('#FAEFE5'),
			yellow = hsl('#EEA83E'),
		},
	},

	light = {
		dim = {
			black = hsl('#150E1C'),
			blue = hsl('#526F96'),
			cyan = hsl('#417671'),
			green = hsl('#5E7262'),
			grey = hsl('#736B6F'),
			orange = hsl('#975F43'),
			purple = hsl('#786398'),
			red = hsl('#975C66'),
			white = hsl('#FAEFE5'),
			yellow = hsl('#8B6726'),
		},

		bright = {
			black = hsl('#131016'),
			blue = hsl('#406DB1'),
			cyan = hsl('#63706E'),
			green = hsl('#5E7440'),
			grey = hsl('#776975'),
			orange = hsl('#986038'),
			purple = hsl('#7762A1'),
			red = hsl('#935F5F'),
			white = hsl('#F5F1E3'),
			yellow = hsl('#8B6724'),
		},

		standard = {
			black = hsl('#170C21'),
			blue = hsl('#326ACB'),
			cyan = hsl('#437671'),
			green = hsl('#4F7654'),
			grey = hsl('#716B70'),
			orange = hsl('#B34F1D'),
			purple = hsl('#8250D5'),
			red = hsl('#B34B55'),
			white = hsl('#FAEFE5'),
			yellow = hsl('#946312'),
		},
	},
}

return colours
