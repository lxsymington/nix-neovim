---@diagnostic disable: undefined-global
local lush = require('lush')
package.loaded['lxs.crepuscular.colours'] = nil
local colours = require('lxs.crepuscular.colours')

local theme = setmetatable({}, {
	__index = function(_, key)
		if not vim.tbl_contains({ 'light', 'dark' }, key) then
			return nil
		end

		local variant = colours[key]

		return lush(function(injected_functions)
			local sym = injected_functions.sym

			local bright = variant.bright
			local dim = variant.dim
			local standard = variant.standard

			-- selene: allow(mixed_table, undefined_variable)
			return {
				Altfont({ gui = 'nocombine,altfont' }),
				Bold({ gui = 'nocombine,bold' }),
				BoldItalic({ gui = 'nocombine,bold,italic' }),
				BoldItalicUndercurl({ gui = 'nocombine,bold,italic,undercurl' }),
				BoldItalicUnderdash({ gui = 'nocombine,bold,italic,underdashed' }),
				BoldItalicUnderdot({ gui = 'nocombine,bold,italic,underdotted' }),
				BoldItalicUnderline({ gui = 'nocombine,bold,italic,underline' }),
				BoldReverse({ gui = 'nocombine,bold,reverse' }),
				BoldUndercurl({ gui = 'nocombine,bold,undercurl' }),
				BoldUnderdash({ gui = 'nocombine,bold,underdashed' }),
				BoldUnderdot({ gui = 'nocombine,bold,underdotted' }),
				BoldUnderline({ gui = 'nocombine,bold,underline' }),
				Italic({ gui = 'nocombine,italic' }),
				ItalicUndercurl({ gui = 'nocombine,italic,undercurl' }),
				ItalicUnderdash({ gui = 'nocombine,italic,underdashed' }),
				ItalicUnderdot({ gui = 'nocombine,italic,underdotted' }),
				ItalicUnderline({ gui = 'nocombine,italic,underline' }),
				ItalicReverse({ gui = 'nocombine,italic,reverse' }),
				NoCombine({ gui = 'nocombine' }),
				Reverse({ gui = 'nocombine,reverse' }),
				Standout({ gui = 'nocombine,standout' }),
				StrikeThrough({ gui = 'nocombine,strikethrough' }),
				Undercurl({ gui = 'nocombine,undercurl' }),
				Underdash({ gui = 'nocombine,underdashed' }),
				Underdot({ gui = 'nocombine,underdotted' }),
				Underdouble({ gui = 'nocombine,underdouble' }),
				Underline({ gui = 'nocombine,underline' }),

				Background({ fg = standard.background }),
				BackgroundBG({ bg = standard.background }),
				BackgroundSpecial({ sp = standard.background }),

				Foreground({ fg = standard.foreground }),
				ForegroundBG({ bg = standard.foreground }),
				ForegroundSpecial({ sp = standard.foreground }),

				Black({ fg = standard.black }),
				BlackBG({ bg = standard.black }),
				BlackSpecial({ sp = standard.black }),

				Blue({ fg = standard.blue }),
				BlueBG({ bg = standard.blue }),
				BlueSpecial({ sp = standard.blue }),

				Cyan({ fg = standard.cyan }),
				CyanBG({ bg = standard.cyan }),
				CyanSpecial({ sp = standard.cyan }),

				Green({ fg = standard.green }),
				GreenBG({ bg = standard.green }),
				GreenSpecial({ sp = standard.green }),

				Grey({ fg = standard.grey }),
				GreyBG({ bg = standard.grey }),
				GreySpecial({ sp = standard.grey }),

				Orange({ fg = standard.orange }),
				OrangeBG({ bg = standard.orange }),
				OrangeSpecial({ sp = standard.orange }),

				Purple({ fg = standard.purple }),
				PurpleBG({ bg = standard.purple }),
				PurpleSpecial({ sp = standard.purple }),

				Red({ fg = standard.red }),
				RedBG({ bg = standard.red }),
				RedSpecial({ sp = standard.red }),

				White({ fg = standard.white }),
				WhiteBG({ bg = standard.white }),
				WhiteSpecial({ sp = standard.white }),

				Yellow({ fg = standard.yellow }),
				YellowBG({ bg = standard.yellow }),
				YellowSpecial({ sp = standard.yellow }),

				BrightBlack({ fg = bright.black }),
				BrightBlackBG({ bg = bright.black }),
				BrightBlackSpecial({ sp = bright.black }),

				BrightBlue({ fg = bright.blue }),
				BrightBlueBG({ bg = bright.blue }),
				BrightBlueSpecial({ sp = bright.blue }),

				BrightCyan({ fg = bright.cyan }),
				BrightCyanBG({ bg = bright.cyan }),
				BrightCyanSpecial({ sp = bright.cyan }),

				BrightGreen({ fg = bright.green }),
				BrightGreenBG({ bg = bright.green }),
				BrightGreenSpecial({ sp = bright.green }),

				BrightGrey({ fg = bright.grey }),
				BrightGreyBG({ bg = bright.grey }),
				BrightGreySpecial({ sp = bright.grey }),

				BrightOrange({ fg = bright.orange }),
				BrightOrangeBG({ bg = bright.orange }),
				BrightOrangeSpecial({ sp = bright.orange }),

				BrightPurple({ fg = bright.purple }),
				BrightPurpleBG({ bg = bright.purple }),
				BrightPurpleSpecial({ sp = bright.purple }),

				BrightRed({ fg = bright.red }),
				BrightRedBG({ bg = bright.red }),
				BrightRedSpecial({ sp = bright.red }),

				BrightWhite({ fg = bright.white }),
				BrightWhiteBG({ bg = bright.white }),
				BrightWhiteSpecial({ sp = bright.white }),

				BrightYellow({ fg = bright.yellow }),
				BrightYellowBG({ bg = bright.yellow }),
				BrightYellowSpecial({ sp = bright.yellow }),

				DimBlack({ fg = dim.black }),
				DimBlackBG({ bg = dim.black }),
				DimBlackSpecial({ sp = dim.black }),

				DimBlue({ fg = dim.blue }),
				DimBlueBG({ bg = dim.blue }),
				DimBlueSpecial({ sp = dim.blue }),

				DimCyan({ fg = dim.cyan }),
				DimCyanBG({ bg = dim.cyan }),
				DimCyanSpecial({ sp = dim.cyan }),

				DimGreen({ fg = dim.green }),
				DimGreenBG({ bg = dim.green }),
				DimGreenSpecial({ sp = dim.green }),

				DimGrey({ fg = dim.grey }),
				DimGreyBG({ bg = dim.grey }),
				DimGreySpecial({ sp = dim.grey }),

				DimOrange({ fg = dim.orange }),
				DimOrangeBG({ bg = dim.orange }),
				DimOrangeSpecial({ sp = dim.orange }),

				DimPurple({ fg = dim.purple }),
				DimPurpleBG({ bg = dim.purple }),
				DimPurpleSpecial({ sp = dim.purple }),

				DimRed({ fg = dim.red }),
				DimRedBG({ bg = dim.red }),
				DimRedSpecial({ sp = dim.red }),

				DimWhite({ fg = dim.white }),
				DimWhiteBG({ bg = dim.white }),
				DimWhiteSpecial({ sp = dim.white }),

				DimYellow({ fg = dim.yellow }),
				DimYellowBG({ bg = dim.yellow }),
				DimYellowSpecial({ sp = dim.yellow }),

				-- The following are the Neovim (as of 0.8.0-dev+100-g371dfb174) highlight
				-- groups, mostly used for styling UI elements.
				Normal({ fg = standard.foreground, bg = standard.background }), -- Normal text
				NormalFloat({ Normal, blend = 12 }), -- Normal text in floating windows.
				NormalNC({ Normal }), -- normal text in non-current windows

				ColorColumn({ bg = Normal.bg.mix(Normal.fg, 2) }), -- Columns set with 'colorcolumn'
				Conceal({ fg = Normal.bg.mix(dim.grey, 15) }), -- Placeholder characters substituted for concealed text (see 'conceallevel')
				Cursor({ gui = Reverse.gui }), -- Character under the cursor
				CurSearch({ bg = Normal.bg.mix(Normal.fg, 15) }), -- Highlighting a search pattern under the cursor (see 'hlsearch')
				lCursor({ Cursor }), -- Character under the cursor when |language-mapping| is used (see 'guicursor')
				CursorIM({ Cursor }), -- Like Cursor, but used when in IME mode |CursorIM|
				CursorColumn({ bg = Normal.bg.mix(Normal.fg, 2) }), -- Screen-column at the cursor, when 'cursorcolumn' is set.
				CursorLine({ bg = Normal.bg.mix(Normal.fg, 2) }), -- Screen-line at the cursor, when 'cursorline' is set. Low-priority if foreground (ctermfg OR guifg) is not set.
				Directory({ fg = bright.blue }), -- Directory names (and other special names in listings)
				DiffAdd({
					bg = Normal.bg.hue(bright.green.h).mix(bright.green, 20),
					gui = BoldUnderdot.gui,
					sp = bright.green,
				}), -- Diff mode: Added line |diff.txt|
				DiffChange({
					bg = Normal.bg.hue(bright.yellow.h).mix(bright.yellow, 20),
					gui = BoldItalic.gui,
				}), -- Diff mode: Changed line |diff.txt|
				DiffDelete({
					bg = Normal.bg.hue(bright.red.h).mix(bright.red, 20),
					fg = bright.red,
					gui = Strikethrough.gui,
				}), -- Diff mode: Deleted line |diff.txt|
				DiffText({
					bg = Normal.bg.hue(bright.cyan.h).mix(bright.cyan, 20),
					gui = Underdouble.gui,
					sp = bright.purple,
				}), -- Diff mode: Changed text within a changed line |diff.txt|
				EndOfBuffer({ fg = Normal.bg.mix(dim.grey, 15) }), -- Filler lines (~) after the end of the buffer. By default, this is highlighted like |hl-NonText|.
				TermCursor({ gui = Reverse.gui }), -- Cursor in a focused terminal
				TermCursorNC({ bg = Normal.bg.mix(Normal.fg, 15) }), -- Cursor in an unfocused terminal
				ErrorMsg({ fg = bright.red }), -- Error messages on the command line
				VertSplit({ fg = Normal.bg.mix(dim.grey, 85) }), -- Column separating vertically split windows
				Folded({ fg = dim.purple }), -- Line used for closed folds
				FoldColumn({ Folded, bg = Normal.bg.mix(Normal.fg, 2) }), -- 'foldcolumn'
				SignColumn({ bg = Normal.bg.mix(Normal.fg, 2) }), -- Column where |signs| are displayed
				IncSearch({ bg = standard.green, fg = standard.black }), -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
				-- Substitute({ bg = Normal.bg.hue(bright.yellow.h).mix(bright.yellow, 75) }), -- |:substitute| replacement text highlighting
				LineNr({ bg = Normal.bg.mix(Normal.fg, 2), fg = Normal.bg.mix(bright.grey, 33) }), -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
				LineNrAbove({ fg = Normal.bg.mix(dim.grey, 33) }), -- Line number for when the 'relativenumber' option is set, above the cursor line
				LineNrBelow({ fg = Normal.bg.mix(dim.grey, 33) }), -- Line number for when the 'relativenumber' option is set, below the cursor line
				CursorLineNr({ LineNr, fg = bright.purple }), -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
				CursorLineFold({ CursorLineNr }), -- Like FoldColumn when 'cursorline' is set for the cursor line
				CursorLineSign({ SignColumn }), -- Like SignColumn when 'cursorline' is set for the cursor line
				MatchParen({ fg = bright.yellow }), -- Character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
				ModeMsg({ fg = dim.grey }), -- 'showmode' message (e.g., "-- INSERT -- ")
				MsgArea({ fg = dim.foreground }), -- Area for messages and cmdline
				MsgSeparator({ fg = dim.grey }), -- Separator for scrolled messages, `msgsep` flag of 'display'
				MoreMsg({ fg = dim.yellow }), -- |more-prompt|
				NonText({ fg = Normal.bg.mix(dim.grey, 25) }), -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
				FloatBorder({ fg = dim.grey }), -- Border of floating windows.
				FloatTitle({ fg = bright.grey }), -- Title of floating windows.
				Pmenu({ fg = dim.grey }), -- Popup menu: Normal item.
				PmenuSel({ bg = Normal.bg.hue(standard.green.h), blend = 30 }), -- Popup menu: Selected item.
				PmenuKind({ bg = standard.grey, fg = standard.black }), -- Popup menu: Normal item "kind"
				PmenuKindSel({ bg = Normal.bg.hue(bright.cyan.h), blend = 30 }), -- Popup menu: Selected item "kind"
				PmenuExtra({ fg = dim.foreground }), -- Popup menu: Normal item "extra text"
				PmenuExtraSel({ fg = standard.yellow }), -- Popup menu: Selected item "extra text"
				PmenuSbar({ fg = Normal.bg.mix(dim.grey, 33) }), -- Popup menu: Scrollbar.
				PmenuThumb({ fg = dim.grey }), -- Popup menu: Thumb of the scrollbar.
				Question({ fg = dim.blue }), -- |hit-enter| prompt and yes/no questions
				QuickFixLine({ bg = bright.grey, fg = bright.black }), -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
				Search({ bg = dim.background }), -- Last search pattern highlighting (see 'hlsearch'). Also used for similar items that need to stand out.
				SpecialKey({ fg = bright.yellow, gui = Underdouble.gui }), -- Unprintable characters: text displayed differently from what it really is. But not 'listchars' whitespace. |hl-Whitespace|
				SpellBad({ gui = Underdash.gui, sp = dim.red }), -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
				SpellCap({ gui = Underdash.gui, sp = standard.cyan }), -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
				SpellLocal({ gui = Underdash.gui, sp = standard.green }), -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
				SpellRare({ gui = Underdash.gui, sp = bright.purple }), -- Word that is recognized by the spellchecker as one that is hardly ever used. |spell| Combined with the highlighting used otherwise.
				StatusLine({ Normal }), -- Status line of current window
				StatusLineNC({ NormalFloat }), -- Status lines of not-current windows. Note: If this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
				TabLine({ bg = Normal.bg.mix(dim.grey, 15) }), -- Tab pages line, not active tab page label
				TabLineFill({ bg = Normal.bg.mix(dim.grey, 20), blend = 50 }), -- Tab pages line, where there are no labels
				TabLineSel({ bg = Normal.bg.mix(dim.grey, 5) }), -- Tab pages line, active tab page label
				Title({ fg = bright.grey }), -- Titles for output from ":set all", ":autocmd" etc.
				Visual({ bg = Normal.bg.hue(bright.yellow.h).mix(standard.yellow, 25) }), -- Visual mode selection
				VisualNOS({ bg = Normal.bg.hue(standard.yellow.h).mix(standard.yellow, 50) }), -- Visual mode selection when vim is "Not Owning the Selection".
				WarningMsg({ fg = bright.yellow }), -- Warning messages
				Whitespace({ fg = Normal.bg.mix(dim.grey, 33) }), -- "nbsp", "space", "tab" and "trail" in 'listchars'
				Winseparator({ fg = Normal.bg.mix(dim.grey, 25) }), -- Separator between window splits. Inherts from |hl-VertSplit| by default, which it will replace eventually.
				WildMenu({ bg = dim.orange, fg = bright.background }), -- Current match in 'wildmenu' completion
				WinBar({ StatusLine }), -- Window bar of current window
				WinBarNC({ StatusLineNC }), -- Window bar of not-current windows

				-- Common vim syntax groups used for all kinds of code and markup.
				-- Commented-out groups should chain up to their preferred (*) group
				-- by default.
				--
				-- See :h group-name
				Comment({ fg = Normal.bg.mix(dim.grey, 50), gui = Italic.gui }), -- Any comment

				Constant({ fg = dim.green }), -- (*) Any constant
				String({ fg = dim.foreground }), --   A string constant: "this is a string"
				Character({ fg = bright.cyan }), --   A character constant: 'c', '\n'
				Number({ fg = standard.orange }), --   A number constant: 234, 0xff
				Boolean({ fg = dim.red }), --   A boolean constant: TRUE, false
				Float({ fg = standard.yellow }), --   A floating point constant: 2.3e10

				Identifier({ fg = standard.purple }), -- (*) Any variable name
				Function({ fg = bright.blue, gui = BoldItalic.gui }), --   Function name (also: methods for classes)

				Statement({ fg = dim.red }), -- (*) Any statement
				Conditional({ fg = bright.red }), --   if, then, else, endif, switch, etc.
				Repeat({ fg = bright.green }), --   for, do, while, etc.
				Label({ fg = dim.yellow }), --   case, default, etc.
				Operator({ fg = standard.cyan }), --   "sizeof", "+", "*", etc.
				Keyword({ fg = dim.purple }), --   any other keyword
				Exception({ fg = bright.red, gui = Underdash.gui }), --   try, catch, throw

				PreProc({ fg = bright.grey }), -- (*) Generic Preprocessor
				Include({ fg = dim.yellow }), --   Preprocessor #include
				Define({ fg = dim.cyan }), --   Preprocessor #define
				Macro({ fg = dim.purple }), --   Same as Define
				PreCondit({ fg = dim.orange }), --   Preprocessor #if, #else, #endif, etc.

				Type({ fg = standard.green, gui = ItalicUnderdot.gui }), -- (*) int, long, char, etc.
				StorageClass({ fg = dim.cyan, gui = ItalicUnderdot.gui }), --   static, register, volatile, etc.
				Structure({ fg = bright.green, gui = ItalicUnderdot.gui }), --   struct, union, enum, etc.
				Typedef({ fg = dim.blue, gui = ItalicUnderdot.gui }), --   A typedef

				Special({ fg = bright.foreground, gui = Underdot.gui, sp = standard.purple }), -- (*) Any special symbol
				SpecialChar({ fg = standard.cyan, gui = Underdouble.gui, sp = standard.orange }), --   Special character in a constant
				Tag({ fg = bright.orange, gui = Underdot.gui, sp = standard.blue }), --   You can use CTRL-] on this
				Delimiter({ fg = standard.yellow.mix(dim.foreground, 25) }), --   Character that needs attention
				SpecialComment({
					fg = Normal.fg.mix(Comment.fg, 50),
					gui = Underdot.gui,
					sp = standard.blue,
				}), --   Special things inside a comment (e.g. '\n')
				Debug({ fg = bright.cyan, gui = Underdash.gui, sp = standard.cyan }), --   Debugging statements

				Underlined({ gui = Underline.gui }), -- Text that stands out, HTML links
				Ignore({ fg = Normal.bg }), -- Left blank, hidden |hl-Ignore| (NOTE: May be invisible here in template)
				Error({ bg = bright.red, fg = bright.background }), -- Any erroneous construct
				Todo({ bg = bright.blue, fg = bright.background }), -- Anything that needs extra attention; mostly the keywords TODO FIXME and XXX

				-- These groups are for the native LSP client and diagnostic system. Some
				-- other LSP clients may use these groups, or use their own. Consult your
				-- LSP client's documentation.

				-- See :h lsp-highlight, some groups may not be listed, submit a PR fix to lush-template!

				LspCodeLens({ fg = dim.blue }), -- Used to color the virtual text of the codelens. See |nvim_buf_set_extmark()|.
				LspCodeLensSeparator({ fg = bright.grey }), -- Used to color the seperator between two or more code lens.
				LspInlayHint({
					fg = Normal.bg.saturation(0).mix(bright.green, 33),
					gui = ItalicUnderdot.gui,
				}), -- Used for virtual text "hints"
				LspReferenceRead({ fg = dim.purple }), -- Used for highlighting "read" references
				LspReferenceText({ fg = standard.purple }), -- Used for highlighting "text" references
				LspReferenceWrite({ fg = standard.blue }), -- Used for highlighting "write" references
				LspSignatureActiveParameter({ fg = standard.cyan, gui = Underdouble.gui }), -- Used to highlight the active parameter in the signature help. See |vim.lsp.handlers.signature_help()|.

				-- See :h diagnostic-highlights, some groups may not be listed, submit a PR fix to lush-template!

				DiagnosticError({ bg = Normal.bg.hue(dim.red.h).mix(dim.red, 10), fg = bright.red }), -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
				DiagnosticWarn({ bg = Normal.bg.hue(dim.yellow.h).mix(dim.yellow, 10), fg = bright.yellow }), -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
				DiagnosticInfo({ bg = Normal.bg.hue(dim.purple.h).mix(dim.purple, 10), fg = bright.purple }), -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
				DiagnosticHint({ bg = Normal.bg.hue(dim.blue.h).mix(dim.blue, 10), fg = bright.blue }), -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
				DiagnosticOk({ bg = Normal.bg.hue(dim.green.h).mix(dim.green, 10), fg = bright.green }), -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
				DiagnosticVirtualTextError({ DiagnosticError, gui = Italic.gui }), -- Used for "Error" diagnostic virtual text.
				DiagnosticVirtualTextWarn({ DiagnosticWarn, gui = Italic.gui }), -- Used for "Warn" diagnostic virtual text.
				DiagnosticVirtualTextInfo({ DiagnosticInfo, gui = Italic.gui }), -- Used for "Info" diagnostic virtual text.
				DiagnosticVirtualTextHint({ DiagnosticHint, gui = Italic.gui }), -- Used for "Hint" diagnostic virtual text.
				DiagnosticVirtualTextOk({ DiagnosticOk, gui = Italic.gui }), -- Used for "Ok" diagnostic virtual text.
				DiagnosticUnderlineError({ gui = Undercurl.gui, sp = bright.red }), -- Used to underline "Error" diagnostics.
				DiagnosticUnderlineWarn({ gui = Undercurl.gui, sp = bright.yellow }), -- Used to underline "Warn" diagnostics.
				DiagnosticUnderlineInfo({ gui = Undercurl.gui, sp = bright.purple }), -- Used to underline "Info" diagnostics.
				DiagnosticUnderlineHint({ gui = Undercurl.gui, sp = bright.blue }), -- Used to underline "Hint" diagnostics.
				DiagnosticUnderlineOk({ gui = Undercurl.gui, sp = bright.green }), -- Used to underline "Ok" diagnostics.
				DiagnosticFloatingError({ fg = dim.red }), -- Used to color "Error" diagnostic messages in diagnostics float. See |vim.diagnostic.open_float()|
				DiagnosticFloatingWarn({ fg = dim.yellow }), -- Used to color "Warn" diagnostic messages in diagnostics float.
				DiagnosticFloatingInfo({ fg = dim.purple }), -- Used to color "Info" diagnostic messages in diagnostics float.
				DiagnosticFloatingHint({ fg = dim.blue }), -- Used to color "Hint" diagnostic messages in diagnostics float.
				DiagnosticFloatingOk({ fg = dim.green }), -- Used to color "Ok" diagnostic messages in diagnostics float.
				DiagnosticSignError({ fg = bright.red }), -- Used for "Error" signs in sign column.
				DiagnosticSignWarn({ fg = bright.yellow }), -- Used for "Warn" signs in sign column.
				DiagnosticSignInfo({ fg = bright.purple }), -- Used for "Info" signs in sign column.
				DiagnosticSignHint({ fg = bright.blue }), -- Used for "Hint" signs in sign column.
				DiagnosticSignOk({ fg = bright.green }), -- Used for "Ok" signs in sign column.

				-- Tree-Sitter syntax groups.
				--
				-- See :h treesitter-highlight-groups, some groups may not be listed,
				-- submit a PR fix to lush-template!
				--
				-- Tree-Sitter groups are defined with an "@" symbol, which must be
				-- specially handled to be valid lua code, we do this via the special
				-- sym function. The following are all valid ways to call the sym function,
				-- for more details see https://www.lua.org/pil/5.html
				--
				-- sym("@text.literal")
				-- sym('@text.literal')
				-- sym"@text.literal"
				-- sym'@text.literal'
				--
				-- For more information see https://github.com/rktjmp/lush.nvim/issues/109

				sym('@boolean')({ Boolean }), -- Boolean
				sym('@character')({ Character }), -- Character
				sym('@character.special')({ SpecialChar }), -- SpecialChar
				sym('@comment')({ Comment }), -- Comment
				sym('@conditional')({ Conditional }), -- Conditional
				sym('@constant')({ Constant }), -- Constant
				sym('@constant.builtin')({ Special }), -- Special
				sym('@constant.macro')({ Define }), -- Define
				sym('@constructor')({ Special }), -- Special
				sym('@debug')({ Debug }), -- Debug
				sym('@define')({ Define }), -- Define
				sym('@exception')({ Exception }), -- Exception
				sym('@field')({ Identifier, fg = dim.purple }), -- Identifier
				sym('@float')({ Float }), -- Float
				sym('@function')({ Function }), -- Function
				sym('@function.builtin')({ Special }), -- Special
				sym('@function.macro')({ Macro }), -- Macro
				sym('@include')({ Include }), -- Include
				sym('@keyword')({ Keyword }), -- Keyword
				sym('@label')({ Label }), -- Label
				sym('@macro')({ Macro }), -- Macro
				sym('@method')({ Function }), -- Function
				sym('@namespace')({ Identifier }), -- Identifier
				sym('@number')({ Number }), -- Number
				sym('@operator')({ Operator }), -- Operator
				sym('@parameter')({ Identifier }), -- Identifier
				sym('@preproc')({ PreProc }), -- PreProc
				sym('@property')({ Identifier, fg = dim.purple }), -- Identifier
				sym('@punctuation')({ Delimiter }), -- Delimiter
				sym('@repeat')({ Repeat }), -- Repeat
				sym('@storageclass')({ StorageClass }), -- StorageClass
				sym('@string')({ String }), -- String
				sym('@string.escape')({ SpecialChar }), -- SpecialChar
				sym('@string.special')({ SpecialChar }), -- SpecialChar
				sym('@structure')({ Structure }), -- Structure
				sym('@tag')({ Tag }), -- Tag
				sym('@text.literal')({ Comment }), -- Comment
				sym('@text.reference')({ Identifier }), -- Identifier
				sym('@text.title')({ Title }), -- Title
				sym('@text.todo')({ Todo }), -- Todo
				sym('@text.underline')({ Underlined }), -- Underlined
				sym('@text.uri')({ Underlined, sp = bright.blue }), -- Underlined
				sym('@type')({ Type }), -- Type
				sym('@type.definition')({ Typedef }), -- Typedef
				sym('@variable')({ Identifier }), -- Identifier

				GitSignsAdd({ SignColumn, fg = bright.green, gui = NoCombine.gui }),
				GitSignsChange({ SignColumn, fg = bright.blue, gui = NoCombine.gui }),
				GitSignsDelete({ SignColumn, fg = bright.red, gui = NoCombine.gui }),
				GitSignsChangedelete({ SignColumn, fg = bright.yellow, gui = NoCombine.gui }),
				GitSignsTopdelete({ SignColumn, fg = bright.red, gui = NoCombine.gui }),
				GitSignsUntracked({ SignColumn, fg = bright.orange, gui = NoCombine.gui }),
				GitSignsAddNr({ LineNr, fg = dim.green, gui = NoCombine.gui }),
				GitSignsChangeNr({ LineNr, fg = dim.blue, gui = NoCombine.gui }),
				GitSignsDeleteNr({ LineNr, fg = dim.red, gui = NoCombine.gui }),
				GitSignsChangedeleteNr({ SignColumn, fg = dim.yellow, gui = NoCombine.gui }),
				GitSignsTopdeleteNr({ SignColumn, fg = dim.red, gui = NoCombine.gui }),
				GitSignsUntrackedNr({ SignColumn, fg = dim.orange, gui = NoCombine.gui }),

				CmpItemAbbr({ fg = standard.foreground, gui = NoCombine.gui, blend = 20 }),
				BlinkCmpLabel({ fg = standard.foreground }),
				CmpItemAbbrDeprecated({ fg = bright.yellow, gui = Strikethrough.gui, blend = 20 }),
				BlinkCmpLabelDeprecated({ fg = bright.yellow, gui = 'strikethrough' }),
				CmpItemAbbrMatch({ fg = standard.green, gui = Bold.gui, blend = 20 }),
				BlinkCmpMenuSelection({ bg = Normal.bg.mix(bright.purple, 20), gui = Bold.gui }),
				CmpItemAbbrMatchFuzzy({ fg = dim.orange, gui = Bold.gui, blend = 20 }),
				BlinkCmpLabelMatch({ fg = standard.green, gui = 'bold' }),
				CmpItemKind({ bg = dim.grey, fg = dim.background, blend = 20 }),
				BlinkCmpKind({ bg = dim.grey, fg = dim.background, blend = 20 }),
				CmpItemMenu({ Comment, blend = 20 }),
				BlinkCmpMenu({ fg = Comment.fg, blend = 20 }),
				CmpItemKindClass({
					bg = standard.blue,
					fg = standard.background,
					gui = BoldUnderdouble.gui,
				}),
				BlinkCmpKindClass({
					bg = standard.blue,
					fg = standard.background,
					gui = BoldUnderdouble.gui,
				}),
				CmpItemKindCopilot({ bg = bright.foreground, fg = standard.background }),
				BlinkCmpKindCopilot({ bg = bright.foreground, fg = standard.background }),
				CmpItemKindFunction({ bg = bright.blue, fg = standard.background }),
				BlinkCmpKindFunction({ bg = bright.blue, fg = standard.background }),
				CmpItemKindInterface({ bg = bright.green, fg = standard.background }),
				BlinkCmpKindInterface({ bg = bright.green, fg = standard.background }),
				CmpItemKindMethod({ bg = dim.blue, fg = standard.background, gui = Underdot.gui }),
				BlinkCmpKindMethod({ bg = dim.blue, fg = standard.background, gui = Underdot.gui }),
				CmpItemKindSnippet({ bg = bright.orange, fg = standard.background }),
				BlinkCmpKindSnippet({ bg = bright.orange, fg = standard.background }),
				CmpItemKindVariable({ bg = bright.purple, fg = standard.background }),
				BlinkCmpKindVariable({ bg = bright.purple, fg = standard.background }),
				CmpItemKindColor({ bg = 'None', fg = dim.red }),
				BlinkCmpKindColor({ bg = 'None', fg = dim.red }),
				CmpItemKindConstant({ bg = dim.green, fg = standard.background }),
				BlinkCmpKindConstant({ bg = dim.green, fg = standard.background }),
				CmpItemKindConstructor({
					bg = bright.foreground,
					fg = standard.background,
					gui = Underdot.gui,
					sp = standard.purple,
				}),
				BlinkCmpKindConstructor({
					bg = bright.foreground,
					fg = standard.background,
					gui = Underdot.gui,
					sp = standard.purple,
				}),
				CmpItemKindEnum({
					bg = dim.cyan,
					fg = standard.background,
					gui = BoldUnderline.gui,
					sp = standard.orange,
				}),
				BlinkCmpKindEnum({
					bg = dim.cyan,
					fg = standard.background,
					gui = BoldUnderline.gui,
					sp = standard.orange,
				}),
				CmpItemKindEnumMember({ bg = bright.cyan, fg = standard.background }),
				BlinkCmpKindEnumMember({ bg = bright.cyan, fg = standard.background }),
				CmpItemKindEvent({ bg = dim.purple, fg = standard.background, gui = BoldItalic.gui }),
				BlinkCmpKindEvent({ bg = dim.purple, fg = standard.background, gui = BoldItalic.gui }),
				CmpItemKindField({ bg = bright.grey, fg = standard.background }),
				BlinkCmpKindField({ bg = bright.grey, fg = standard.background }),
				CmpItemKindFile({ bg = dim.green, fg = standard.background }),
				BlinkCmpKindFile({ bg = dim.green, fg = standard.background }),
				CmpItemKindFolder({
					bg = standard.green,
					fg = standard.background,
					gui = BoldUnderline.gui,
				}),
				BlinkCmpKindFolder({
					bg = standard.green,
					fg = standard.background,
					gui = BoldUnderline.gui,
				}),
				CmpItemKindKeyword({ bg = dim.purple, fg = standard.background, gui = Bold.gui }),
				BlinkCmpKindKeyword({ bg = dim.purple, fg = standard.background, gui = Bold.gui }),
				CmpItemKindModule({ bg = dim.orange, fg = standard.background, gui = Bold.gui }),
				BlinkCmpKindModule({ bg = dim.orange, fg = standard.background, gui = Bold.gui }),
				CmpItemKindOperator({ bg = standard.cyan, fg = standard.background }),
				BlinkCmpKindOperator({ bg = standard.cyan, fg = standard.background }),
				CmpItemKindProperty({ bg = dim.yellow, fg = standard.background }),
				BlinkCmpKindProperty({ bg = dim.yellow, fg = standard.background }),
				CmpItemKindReference({ bg = bright.yellow, fg = standard.background }),
				BlinkCmpKindReference({ bg = bright.yellow, fg = standard.background }),
				CmpItemKindStruct({ bg = bright.green, fg = standard.background, gui = Bold.gui }),
				BlinkCmpKindStruct({ bg = bright.green, fg = standard.background, gui = Bold.gui }),
				CmpItemKindText({ bg = dim.foreground, fg = standard.background, gui = Italic.gui }),
				BlinkCmpKindText({ bg = dim.foreground, fg = standard.background, gui = Italic.gui }),
				CmpItemKindTypeParameter({
					bg = standard.green,
					fg = standard.background,
					gui = Underdot.gui,
				}),
				BlinkCmpKindTypeParameter({
					bg = standard.green,
					fg = standard.background,
					gui = Underdot.gui,
				}),
				CmpItemKindUnit({ bg = bright.red, fg = standard.background, gui = BoldUnderdouble.gui }),
				BlinkCmpKindUnit({ bg = bright.red, fg = standard.background, gui = BoldUnderdouble.gui }),
				CmpItemKindValue({ bg = standard.red, fg = standard.background }),
				BlinkCmpKindValue({ bg = standard.red, fg = standard.background }),
				BlinkCmpGhostTest({ fg = Normal.bg.mix(dim.green, 15), gui = Underdot.gui }),

				NotifyERRORBorder({ fg = dim.red }),
				NotifyWARNBorder({ fg = dim.yellow }),
				NotifyINFOBorder({ fg = dim.purple }),
				NotifyDEBUGBorder({ fg = dim.blue }),
				NotifyTRACEBorder({ fg = dim.orange }),
				NotifyERRORIcon({ fg = bright.red }),
				NotifyWARNIcon({ fg = bright.yellow }),
				NotifyINFOIcon({ fg = bright.purple }),
				NotifyDEBUGIcon({ fg = bright.blue }),
				NotifyTRACEIcon({ fg = bright.orange }),
				NotifyERRORTitle({ fg = standard.red, gui = Bold.gui }),
				NotifyWARNTitle({ fg = standard.yellow, gui = Bold.gui }),
				NotifyINFOTitle({ fg = standard.purple, gui = Bold.gui }),
				NotifyDEBUGTitle({ fg = standard.blue, gui = Bold.gui }),
				NotifyTRACETitle({ fg = standard.orange, gui = Bold.gui }),
				NotifyDEBUGBody({ fg = Normal.fg.mix(standard.blue, 10) }),
				NotifyERRORBody({ fg = Normal.fg.mix(standard.red, 10) }),
				NotifyINFOBody({ fg = Normal.fg.mix(standard.purple, 10) }),
				NotifyTRACEBody({ fg = Normal.fg.mix(standard.orange, 10) }),
				NotifyWARNBody({ fg = Normal.fg.mix(standard.yellow, 10) }),
				NotifyBackground({ Normal }),

				NeogitDiffAddHighlight({ DiffAdd }),
				NeogitDiffDeleteHighlight({ DiffDelete }),
				NeogitDiffContextHighlight({ DiffChange }),
				NeogitHunkHeader({ fg = bright.purple, bg = dim.background, gui = NoCombine.gui }),
				NeogitHunkHeaderHighlight({ NeogitHunkHeader, gui = BoldUnderline.gui }),

				NeotestAdapterName({ fg = standard.purple, gui = Bold.gui }),
				NeotestBorder({ fg = bright.purple, gui = NoCombine.gui }),
				NeotestCanvas({ fg = standard.grey, gui = NoCombine.gui }),
				NeotestDir({ fg = standard.yellow, gui = NoCombine.gui }),
				NeotestExpandMarker({ fg = standard.grey, gui = NoCombine.gui }),
				NeotestFailed({ fg = standard.red, gui = Bold.gui }),
				NeotestFile({ fg = standard.green, gui = Italic.gui }),
				NeotestFocused({ bg = bright.background, gui = NoCombine.gui }),
				NeotestIndent({ fg = standard.background, gui = NoCombine.gui }),
				NeotestMarked({ fg = standard.orange, gui = BoldUnderdot.gui }),
				NeotestNamespace({ fg = bright.purple, gui = NoCombine.gui }),
				NeotestPassed({ fg = bright.green, gui = Bold.gui }),
				NeotestRunning({ fg = standard.yellow, gui = Underdash.gui }),
				NeotestWinSelect({ fg = bright.grey, gui = NoCombine.gui }),
				NeotestSkipped({ fg = bright.orange, gui = Underdot.gui }),
				NeotestTarget({ fg = standard.cyan, gui = NoCombine.gui }),
				NeotestTest({ fg = standard.blue, gui = Bold.gui }),
				NeotestUnknown({ fg = dim.grey, gui = Italic.gui }),

				TelescopeBorder({ NonText }),
				TelescopeMatching({ fg = dim.orange, gui = Bold.gui }),
				TelescopeNormal({ NormalFloat }),
				TelescopePromptNormal({ TelescopeNormal }),
				TelescopePromptPrefix({ fg = Normal.bg.mix(dim.grey, 60) }),
				TelescopeSelection({ fg = dim.blue, bg = Normal.bg.hue(dim.blue.h).mix(dim.blue, 25) }),
				TelescopeSelectionCaret({ fg = bright.red, bg = Normal.bg.hue(dim.red.h).mix(dim.red, 25) }),
				TelescopeTitle({ fg = standard.blue, gui = Bold.gui }),

				SnippetVirtTextSnippetActive({ fg = bright.green }),
				SnippetVirtTextSnippetPassive({ fg = bright.yellow }),
				SnippetVirtTextSnippetVisited({ fg = bright.purple }),
				SnippetVirtTextSnippetUnvisited({ fg = bright.blue }),
				SnippetVirtTextSnippetSnippetPassive({ fg = bright.grey }),
				SnippetVirtTextChoiceActive({ fg = bright.green }),
				SnippetVirtTextChoicePassive({ fg = bright.yellow }),
				SnippetVirtTextChoiceVisited({ fg = bright.purple }),
				SnippetVirtTextChoiceUnvisited({ fg = bright.blue }),
				SnippetVirtTextChoiceSnippetPassive({ fg = bright.grey }),
				SnippetVirtTextInsertActive({ fg = bright.green }),
				SnippetVirtTextInsertPassive({ fg = bright.yellow }),
				SnippetVirtTextInsertVisited({ fg = bright.purple }),
				SnippetVirtTextInsertUnvisited({ fg = bright.blue }),
				SnippetVirtTextInsertSnippetPassive({ fg = bright.grey }),

				EyelinerPrimary({ fg = standard.cyan, gui = Underdash.gui, sp = bright.orange }),
				EyelinerSecondary({ fg = dim.cyan, gui = Underdash.gui, sp = dim.orange }),
			}
		end)
	end,
})

return theme
