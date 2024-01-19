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
}

return colours
