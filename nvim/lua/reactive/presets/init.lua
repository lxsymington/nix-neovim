--- Construct mode highlights for `Reactive`
---@param variantType 'dark' | 'light' Whether the palette is dark or light
---@param variant table The colour palette to use
---@return table Reactive Modes
local function create_highlights(variantType, variant)
	local normal = variantType == 'dark' and variant.standard.black or variant.standard.white

	return {
		n = {
			winhl = {
				CursorLine = {
					bg = normal.mix(variant.bright.purple, 40).hex,
				},
			},
			hl = {
				MyCursor = {
					bg = normal.mix(variant.bright.purple, 80).hex,
				},
			},
		},
		no = {
			winhl = {},
			hl = {},
			operators = {
				d = {
					winhl = {
						CursorLine = {
							bg = normal.mix(variant.bright.red, 40).hex,
						},
					},
					hl = {
						MyCursor = {
							bg = normal.mix(variant.bright.red, 80).hex,
						},
					},
				},
				y = {
					winhl = {
						CursorLine = {
							bg = normal.mix(variant.bright.yellow, 40).hex,
						},
					},
					hl = {
						MyCursor = {
							bg = normal.mix(variant.bright.yellow, 80).hex,
						},
					},
				},
			},
		},
		i = {
			winhl = {
				CursorLine = {
					bg = normal.mix(variant.bright.green, 40).hex,
				},
			},
			hl = {
				MyCursor = {
					bg = normal.mix(variant.bright.green, 80).hex,
				},
			},
		},
		[{ 's', 'S', '' }] = {
			winhl = {
				CursorLine = {
					bg = normal.mix(variant.bright.orange, 40).hex,
				},
			},
			hl = {
				MyCursor = {
					bg = normal.mix(variant.bright.orange, 80).hex,
				},
			},
		},
		[{ 'v', 'V', '' }] = {
			winhl = {
				CursorLine = {
					bg = normal.mix(variant.bright.cyan, 40).hex,
				},
			},
			hl = {
				MyCursor = {
					bg = normal.mix(variant.bright.cyan, 80).hex,
				},
			},
		},
	}
end

return create_highlights
