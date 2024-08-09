---@diagnostic disable: undefined-global
local lush = require('lush')

local function generate_theme(bright, dim, standard)
	local theme = lush(function(injected_functions)
		local sym = injected_functions.sym

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
			NormalFloat({ Normal, blend = 10 }), -- Normal text in floating windows.
			NormalNC({ Normal }), -- normal text in non-current windows

			ColorColumn({ bg = Normal.bg.mix(Normal.fg, 2) }), -- Columns set with 'colorcolumn'
			Conceal({ fg = dim.grey.mix(Normal.bg, 85) }), -- Placeholder characters substituted for concealed text (see 'conceallevel')
			Cursor({ gui = Reverse.gui }), -- Character under the cursor
			CurSearch({ bg = Normal.bg.mix(Normal.fg, 15) }), -- Highlighting a search pattern under the cursor (see 'hlsearch')
			lCursor({ Cursor }), -- Character under the cursor when |language-mapping| is used (see 'guicursor')
			CursorIM({ Cursor }), -- Like Cursor, but used when in IME mode |CursorIM|
			CursorColumn({ bg = Normal.bg.mix(Normal.fg, 2) }), -- Screen-column at the cursor, when 'cursorcolumn' is set.
			CursorLine({ bg = Normal.bg.mix(Normal.fg, 2) }), -- Screen-line at the cursor, when 'cursorline' is set. Low-priority if foreground (ctermfg OR guifg) is not set.
			Directory({ fg = bright.blue }), -- Directory names (and other special names in listings)
			DiffAdd({ fg = dim.green }), -- Diff mode: Added line |diff.txt|
			DiffChange({ fg = dim.orange }), -- Diff mode: Changed line |diff.txt|
			DiffDelete({ fg = dim.red }), -- Diff mode: Deleted line |diff.txt|
			DiffText({ fg = dim.cyan }), -- Diff mode: Changed text within a changed line |diff.txt|
			EndOfBuffer({ fg = dim.grey.mix(Normal.bg, 85) }), -- Filler lines (~) after the end of the buffer. By default, this is highlighted like |hl-NonText|.
			TermCursor({ gui = Reverse.gui }), -- Cursor in a focused terminal
			TermCursorNC({ bg = Normal.bg.mix(Normal.fg, 15) }), -- Cursor in an unfocused terminal
			ErrorMsg({ fg = bright.red }), -- Error messages on the command line
			VertSplit({ fg = dim.grey.mix(Normal.bg, 85) }), -- Column separating vertically split windows
			Folded({ fg = dim.purple }), -- Line used for closed folds
			FoldColumn({ Folded, bg = Normal.bg.mix(Normal.fg, 2) }), -- 'foldcolumn'
			SignColumn({ bg = Normal.bg.mix(Normal.fg, 2) }), -- Column where |signs| are displayed
			IncSearch({ bg = standard.green, fg = standard.black }), -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
			Substitute({ bg = bright.yellow.mix(Normal.bg, 25) }), -- |:substitute| replacement text highlighting
			LineNr({ bg = Normal.bg.mix(Normal.fg, 2), fg = bright.grey.mix(Normal.bg, 67) }), -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
			LineNrAbove({ fg = dim.grey.mix(Normal.bg, 67) }), -- Line number for when the 'relativenumber' option is set, above the cursor line
			LineNrBelow({ fg = dim.grey.mix(Normal.bg, 67) }), -- Line number for when the 'relativenumber' option is set, below the cursor line
			CursorLineNr({ LineNr, fg = bright.purple }), -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
			CursorLineFold({ CursorLineNr }), -- Like FoldColumn when 'cursorline' is set for the cursor line
			CursorLineSign({ SignColumn }), -- Like SignColumn when 'cursorline' is set for the cursor line
			MatchParen({ fg = bright.yellow }), -- Character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
			ModeMsg({ fg = dim.grey }), -- 'showmode' message (e.g., "-- INSERT -- ")
			MsgArea({ fg = dim.foreground }), -- Area for messages and cmdline
			MsgSeparator({ fg = dim.grey }), -- Separator for scrolled messages, `msgsep` flag of 'display'
			MoreMsg({ fg = dim.yellow }), -- |more-prompt|
			NonText({ fg = dim.grey.mix(Normal.bg, 75) }), -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
			FloatBorder({ fg = dim.grey }), -- Border of floating windows.
			FloatTitle({ fg = bright.grey }), -- Title of floating windows.
			Pmenu({ fg = dim.grey }), -- Popup menu: Normal item.
			PmenuSel({ fg = bright.orange }), -- Popup menu: Selected item.
			PmenuKind({ bg = standard.grey, fg = standard.black }), -- Popup menu: Normal item "kind"
			PmenuKindSel({ bg = bright.green, fg = standard.black }), -- Popup menu: Selected item "kind"
			PmenuExtra({ fg = dim.foreground }), -- Popup menu: Normal item "extra text"
			PmenuExtraSel({ fg = standard.yellow }), -- Popup menu: Selected item "extra text"
			PmenuSbar({ fg = dim.grey.mix(Normal.bg, 67) }), -- Popup menu: Scrollbar.
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
			TabLine({ bg = dim.grey.mix(Normal.bg, 95) }), -- Tab pages line, not active tab page label
			TabLineFill({ Normal }), -- Tab pages line, where there are no labels
			TabLineSel({ bg = dim.grey.mix(Normal.bg, 85) }), -- Tab pages line, active tab page label
			Title({ fg = bright.grey }), -- Titles for output from ":set all", ":autocmd" etc.
			Visual({ bg = Normal.bg.mix(standard.yellow, 25) }), -- Visual mode selection
			VisualNOS({ bg = Normal.bg.mix(standard.yellow, 50) }), -- Visual mode selection when vim is "Not Owning the Selection".
			WarningMsg({ fg = bright.yellow }), -- Warning messages
			Whitespace({ fg = dim.grey.mix(Normal.bg, 67) }), -- "nbsp", "space", "tab" and "trail" in 'listchars'
			Winseparator({ fg = dim.grey.mix(Normal.bg, 75) }), -- Separator between window splits. Inherts from |hl-VertSplit| by default, which it will replace eventually.
			WildMenu({ bg = dim.orange, fg = bright.black }), -- Current match in 'wildmenu' completion
			WinBar({ StatusLine }), -- Window bar of current window
			WinBarNC({ StatusLineNC }), -- Window bar of not-current windows

			-- Common vim syntax groups used for all kinds of code and markup.
			-- Commented-out groups should chain up to their preferred (*) group
			-- by default.
			--
			-- See :h group-name
			Comment({ fg = dim.grey.mix(Normal.bg, 50), gui = Italic.gui }), -- Any comment

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
			SpecialComment({ fg = Normal.fg.mix(Comment.fg, 50), gui = Underdot.gui, sp = standard.blue }), --   Special things inside a comment (e.g. '\n')
			Debug({ fg = bright.cyan, gui = Underdash.gui, sp = standard.cyan }), --   Debugging statements

			Underlined({ gui = Underline.gui }), -- Text that stands out, HTML links
			Ignore({ fg = Normal.bg }), -- Left blank, hidden |hl-Ignore| (NOTE: May be invisible here in template)
			Error({ bg = bright.red, fg = bright.black }), -- Any erroneous construct
			Todo({ bg = bright.blue, fg = bright.black }), -- Anything that needs extra attention; mostly the keywords TODO FIXME and XXX

			-- These groups are for the native LSP client and diagnostic system. Some
			-- other LSP clients may use these groups, or use their own. Consult your
			-- LSP client's documentation.

			-- See :h lsp-highlight, some groups may not be listed, submit a PR fix to lush-template!

			LspCodeLens({ fg = dim.blue }), -- Used to color the virtual text of the codelens. See |nvim_buf_set_extmark()|.
			LspCodeLensSeparator({ fg = bright.grey }), -- Used to color the seperator between two or more code lens.
			LspInlayHint({ fg = dim.yellow.mix(Normal.bg, 67), gui = ItalicUnderdot.gui }), -- Used for virtual text "hints"
			LspReferenceRead({ fg = dim.purple }), -- Used for highlighting "read" references
			LspReferenceText({ fg = standard.purple }), -- Used for highlighting "text" references
			LspReferenceWrite({ fg = standard.blue }), -- Used for highlighting "write" references
			LspSignatureActiveParameter({ fg = standard.cyan, gui = Underdouble.gui }), -- Used to highlight the active parameter in the signature help. See |vim.lsp.handlers.signature_help()|.

			-- See :h diagnostic-highlights, some groups may not be listed, submit a PR fix to lush-template!

			DiagnosticError({ bg = dim.red.mix(Normal.bg, 90), fg = bright.red }), -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
			DiagnosticWarn({ bg = dim.yellow.mix(Normal.bg, 90), fg = bright.yellow }), -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
			DiagnosticInfo({ bg = dim.purple.mix(Normal.bg, 90), fg = bright.purple }), -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
			DiagnosticHint({ bg = dim.blue.mix(Normal.bg, 90), fg = bright.blue }), -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
			DiagnosticOk({ bg = dim.green.mix(Normal.bg, 90), fg = bright.green }), -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
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

			CmpItemAbbr({ fg = standard.foreground, gui = NoCombine.gui }),
			CmpItemAbbrDeprecated({ fg = bright.yellow, gui = Strikethrough.gui }),
			CmpItemAbbrMatch({ fg = bright.orange, gui = Bold.gui }),
			CmpItemAbbrMatchFuzzy({ fg = dim.orange, gui = Bold.gui }),
			CmpItemKind({ fg = bright.blue }),
			CmpItemMenu({ Comment }),

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
			NotifyERRORTitle({ fg = standard.red }),
			NotifyWARNTitle({ fg = standard.yellow }),
			NotifyINFOTitle({ fg = standard.purple }),
			NotifyDEBUGTitle({ fg = standard.blue }),
			NotifyTRACETitle({ fg = standard.orange }),
			NotifyDEBUGBody({ Normal }),
			NotifyERRORBody({ Normal }),
			NotifyINFOBody({ Normal }),
			NotifyTRACEBody({ Normal }),
			NotifyWARNBody({ Normal }),

			NeogitDiffAddHighlight({ DiffAdd }),
			NeogitDiffDeleteHighlight({ DiffDelete }),
			NeogitDiffContextHighlight({ DiffChange }),
			NeogitHunkHeader({ fg = bright.purple, bg = dim.background, gui = NoCombine.gui }),
			NeogitHunkHeaderHighlight({ NeogitHunkHeader, gui = BoldUnderline.gui }),

			NeotestAdapterName({ fg = standard.purple, gui = Bold.gui }),
			NeotestBorder({ fg = bright.purple, gui = NoCombine.gui }),
			NeotestDir({ fg = standard.yellow, gui = NoCombine.gui }),
			NeotestExpandMarker({ fg = standard.grey, gui = NoCombine.gui }),
			NeotestFailed({ fg = standard.red, gui = Bold.gui }),
			NeotestFile({ fg = standard.green, gui = Italic.gui }),
			NeotestFocused({ bg = bright.background, gui = NoCombine.gui }),
			NeotestIndent({ fg = standard.black, gui = NoCombine.gui }),
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
			TelescopePromptPrefix({ fg = dim.grey.mix(Normal.bg, 40) }),
			TelescopeSelection({ fg = dim.blue, bg = Normal.bg.mix(dim.blue, 25) }),
			TelescopeSelectionCaret({ fg = bright.red, bg = Normal.bg.mix(dim.red, 25) }),
			TelescopeTitle({ fg = standard.blue, gui = Bold.gui }),
		}
	end)

	return theme
end

return generate_theme
