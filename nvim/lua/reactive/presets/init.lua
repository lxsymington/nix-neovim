--- Construct mode highlights for `Reactive`
---@param variant table The colour palette to use
---@return table Reactive Modes
local function create_highlights(variant)
	return {
		n = {
			winhl = {
				CursorLine = {
					bg = variant.standard.background.mix(variant.bright.purple.saturate(50), 10).hex,
				},
			},
			hl = {
				MyCursor = {
					bg = variant.standard.background.mix(variant.bright.purple.saturate(50), 20).hex,
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
							bg = variant.standard.background.mix(variant.bright.red.saturate(50), 10).hex,
						},
					},
					hl = {
						MyCursor = {
							bg = variant.standard.background.mix(variant.bright.red.saturate(50), 20).hex,
						},
					},
				},
				y = {
					winhl = {
						CursorLine = {
							bg = variant.standard.background.mix(variant.bright.yellow.saturate(50), 10).hex,
						},
					},
					hl = {
						MyCursor = {
							bg = variant.standard.background.mix(variant.bright.yellow.saturate(50), 20).hex,
						},
					},
				},
			},
		},
		i = {
			winhl = {
				CursorLine = {
					bg = variant.standard.background.mix(variant.bright.green.saturate(50), 10).hex,
				},
			},
			hl = {
				MyCursor = {
					bg = variant.standard.background.mix(variant.bright.green.saturate(50), 20).hex,
				},
			},
		},
		[{ 's', 'S', '' }] = {
			winhl = {
				CursorLine = {
					bg = variant.standard.background.mix(variant.bright.orange.saturate(50), 10).hex,
				},
			},
			hl = {
				MyCursor = {
					bg = variant.standard.background.mix(variant.bright.orange.saturate(50), 20).hex,
				},
			},
		},
		[{ 'v', 'V', '' }] = {
			winhl = {
				CursorLine = {
					bg = variant.standard.background.mix(variant.bright.cyan.saturate(50), 10).hex,
				},
			},
			hl = {
				MyCursor = {
					bg = variant.standard.background.mix(variant.bright.cyan.saturate(50), 20).hex,
				},
			},
		},
	}
end

return create_highlights
