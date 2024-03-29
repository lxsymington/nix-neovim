local lush = require('lush')

package.loaded['lxs.crepuscular.colours'] = nil
package.loaded['lxs.crepuscular.base'] = nil

local colours = require('lxs.crepuscular.colours')
local base = require('lxs.crepuscular.base')

local theme = lush.merge({
	base,
	lush(function()
		return {
			ColorColumn({ bg = colours.black.darken(20), gui = 'nocombine' }),
			Comment({ fg = colours.lightGrey, gui = 'nocombine,italic' }),
			CursorLine({ bg = colours.black.darken(20), gui = 'nocombine' }),
			CursorLineNr({ bg = colours.black, fg = colours.yellow, gui = 'nocombine,bold' }),
			DiffAdd({ bg = colours.black.mix(colours.green, 25), gui = 'nocombine,bold' }),
			DiffChange({ bg = colours.black.mix(colours.blue, 25), gui = 'nocombine,bold' }),
			DiffDelete({ fg = colours.black.mix(colours.red, 75), gui = 'nocombine,bold' }),
			DiffText({
				bg = colours.black.mix(colours.lightPurple, 25),
				gui = 'nocombine,bold,undercurl',
			}),
			IncSearch({ bg = colours.lightGreen, fg = colours.black, gui = 'nocombine,bold' }),
			LineNr({
				bg = colours.black.lighten(5),
				fg = colours.grey.lighten(15),
				gui = 'nocombine',
			}),
			MatchParen({ bg = colours.purple, fg = colours.yellow, gui = 'nocombine' }),
			ModeMsg({ fg = colours.lightGrey, gui = 'nocombine' }),
			MoreMsg({ fg = colours.lightPurple, gui = 'nocombine,bold' }),
			MsgArea({ fg = colours.lightYellow, gui = 'nocombine,italic' }),
			MsgSeparator({ fg = colours.lightGreen, gui = 'nocombine' }),
			NonText({ fg = colours.grey, gui = 'nocombine' }),
			Normal({ bg = colours.black, fg = colours.white, gui = 'nocombine' }),
			NormalFloat({ bg = colours.black.darken(40), gui = 'nocombine' }),
			NormalNC({ bg = colours.lightBlack, fg = colours.white, gui = 'nocombine' }),
			Pmenu({ bg = colours.black.darken(20), fg = colours.white, gui = 'nocombine' }),
			PmenuSbar({ bg = colours.black.darken(40), gui = 'nocombine' }),
			PmenuSel({ bg = colours.purple, fg = colours.yellow, gui = 'nocombine,bold' }),
			QuickFixLine({ bg = colours.purple, fg = colours.yellow, gui = 'nocombine' }),
			SignColumn({ bg = colours.black, gui = 'nocombine,italic' }),
			SpellRare({ fg = colours.lightBlue, gui = 'nocombine,undercurl' }),
			StatusLine({ bg = colours.black, gui = 'nocombine' }),
			StatusLineNC({ bg = colours.black, gui = 'nocombine' }),
			Substitute({ bg = colours.blue, fg = colours.lightCyan, gui = 'nocombine' }),
			TabLine({ bg = colours.grey, fg = colours.lightGrey }),
			TabLineFill({
				bg = colours.lightGrey.darken(30),
				fg = colours.black,
				gui = 'nocombine',
			}),
			TabLineSel({ Normal, gui = 'nocombine,bold' }),
			TermCursorNC({ bg = colours.white, fg = colours.black, gui = 'nocombine' }),
			VertSplit({ fg = colours.lightPurple, gui = 'nocombine' }),
			Visual({ bg = colours.purple.abs_desaturate(50).abs_darken(15), gui = 'nocombine' }),
			VisualNOS({ bg = colours.lightCyan, gui = 'nocombine' }),
			Whitespace({ fg = colours.black.lighten(15), gui = 'nocombine' }),
			WildMenu({ bg = colours.green, gui = 'nocombine,bold' }),

			Constant({ fg = colours.lightCyan, gui = 'nocombine,bold' }),
			String({ fg = colours.lightWhite, gui = 'nocombine,italic' }),
			Function({ fg = colours.cyan, gui = 'nocombine,bold' }),
			PreCondit({ fg = colours.white, gui = 'nocombine,bold' }),
			SpecialComment({ fg = colours.green.desaturate(40), gui = 'nocombine,italic' }),
			StorageClass({ fg = colours.lightYellow, gui = 'nocombine,bold' }),
			Structure({ fg = colours.lightCyan, gui = 'nocombine,bold' }),
			Tag({ fg = colours.lightCyan, gui = 'nocombine,underline' }),
			Type({ fg = colours.yellow, gui = 'nocombine,bold' }),
			Typedef({ fg = colours.lightGreen, gui = 'nocombine' }),

			TSPunctBracket({ fg = colours.orange, gui = 'nocombine' }),
			TSConstant({ Constant }),
			TSString({ String }),
			TSFunction({ Function }),
			TSParameter({ fg = colours.purple.abs_lighten(15), gui = 'nocombine,bold' }),
			TSParameterReference({
				TSParameter,
				gui = 'nocombine,undercurl',
				sp = colours.purple,
			}),
			TSMethod({ Function, fg = colours.lightBlue }),
			TSField({ TSMethod, fg = colours.blue }),
			TSProperty({ TSField }),
			TSConstructor({ TSMethod, gui = 'nocombine,underline', sp = colours.blue }),
			TSKeywordFunction({ Function }),
			TSType({ Type }),
			TSTypeBuiltin({ Typedef }),
			TSText({ String }),
			TSLiteral({ String }),

			DiagnosticVirtualTextError({
				bg = colours.lightRed.saturation(36).lightness(12),
				fg = colours.lightRed.saturation(60).lightness(48),
				gui = 'nocombine,italic',
			}),
			DiagnosticVirtualTextHint({
				bg = colours.lightGreen.saturation(36).lightness(12),
				fg = colours.lightGreen.saturation(60).lightness(48),
				gui = 'nocombine,italic',
			}),
			DiagnosticVirtualTextInfo({
				bg = colours.lightBlue.saturation(36).lightness(12),
				fg = colours.lightBlue.saturation(60).lightness(48),
				gui = 'nocombine,italic',
			}),
			DiagnosticVirtualTextWarn({
				bg = colours.yellow.saturation(36).lightness(12),
				fg = colours.yellow.saturation(60).lightness(48),
				gui = 'nocombine,italic',
			}),

			GitSignsAddSign({ SignColumn, fg = colours.lightGreen, gui = 'nocombine' }),
			GitSignsChangeSign({ SignColumn, fg = colours.lightBlue, gui = 'nocombine' }),
			GitSignsDeleteSign({
				SignColumn,
				fg = colours.lightRed.darken(15),
				gui = 'nocombine',
			}),
			GitSignsAddNr({
				bg = colours.lightGreen.abs_desaturate(30).abs_darken(30),
				fg = colours.lightGreen,
				gui = 'nocombine',
			}),
			GitSignsChangeNr({
				bg = colours.lightBlue.abs_desaturate(30).abs_darken(45),
				fg = colours.lightBlue,
				gui = 'nocombine',
			}),
			GitSignsDeleteNr({
				bg = colours.lightRed.abs_desaturate(60).abs_darken(60),
				fg = colours.lightRed.darken(15),
				gui = 'nocombine',
			}),

			CmpItemAbbr({ fg = colours.white, gui = 'nocombine' }),
			CmpItemAbbrDeprecated({ fg = colours.lightYellow, gui = 'nocombine,strikethrough' }),
			CmpItemAbbrMatch({ fg = colours.orange, gui = 'nocombine,bold' }),
			CmpItemAbbrMatchFuzzy({ fg = colours.lightOrange, gui = 'nocombine,bold' }),
			CmpItemKind({ fg = colours.lightBlue }),
			CmpItemMenu({ Comment }),

			NotifyDEBUGBody({ Normal }),
			NotifyERRORBody({ Normal }),
			NotifyINFOBody({ Normal }),
			NotifyTRACEBody({ Normal }),
			NotifyWARNBody({ Normal }),

			NeogitDiffAddHighlight({ DiffAdd }),
			NeogitDiffDeleteHighlight({ DiffDelete }),
			NeogitDiffContextHighlight({ DiffChange }),
			NeogitHunkHeader({
				fg = colours.lightPurple,
				bg = colours.black.mix(colours.yellow, 25),
				gui = 'nocombine',
			}),
			NeogitHunkHeaderHighlight({ NeogitHunkHeader, gui = 'nocombine,underline,bold' }),
		}
	end),
})

return theme
