local function create_highlights(variant)
	return {
		n = {
			winhl = {
				CursorLine = {
					bg = variant.standard.black.mix(variant.bright.purple, 20).hex,
				},
			},
			hl = {
				MyCursor = {
					bg = variant.standard.black.mix(variant.bright.purple, 40).hex,
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
							bg = variant.standard.black.mix(variant.bright.red, 20).hex,
						},
					},
					hl = {
						MyCursor = {
							bg = variant.standard.black.mix(variant.bright.red, 20).hex,
						},
					},
				},
				y = {
					winhl = {
						CursorLine = {
							bg = variant.standard.black.mix(variant.bright.yellow, 20).hex,
						},
					},
					hl = {
						MyCursor = {
							bg = variant.standard.black.mix(variant.bright.yellow, 40).hex,
						},
					},
				},
			},
		},
		i = {
			winhl = {
				CursorLine = {
					bg = variant.standard.black.mix(variant.bright.green, 20).hex,
				},
			},
			hl = {
				MyCursor = {
					bg = variant.standard.black.mix(variant.bright.green, 40).hex,
				},
			},
		},
		[{ 's', 'S', '\x13' }] = {
			winhl = {
				CursorLine = {
					bg = variant.standard.black.mix(variant.bright.orange, 20).hex,
				},
			},
			hl = {
				MyCursor = {
					bg = variant.standard.black.mix(variant.bright.orange, 40).hex,
				},
			},
		},
		[{ 'v', 'V', '\x16' }] = {
			winhl = {
				CursorLine = {
					bg = variant.standard.black.mix(variant.bright.cyan, 20).hex,
				},
			},
			hl = {
				MyCursor = {
					bg = variant.standard.black.mix(variant.bright.cyan, 40).hex,
				},
			},
		},
	}
end

return create_highlights
