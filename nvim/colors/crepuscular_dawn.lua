-- colors/crepuscular_dawn.lua
local api = vim.api
local cmd = vim.cmd
local opt = vim.opt

local colors = {
	-- content here will not be touched
	-- PATCH_OPEN
Normal = {fg = "#170C21", bg = "#FAEFE5"},
NormalNC = {link = "Normal"},
NotifyBackground = {link = "Normal"},
StatusLine = {link = "Normal"},
Altfont = {altfont = true, nocombine = true},
Background = {fg = "#FAEFE5"},
BackgroundBG = {bg = "#FAEFE5"},
BackgroundSpecial = {sp = "#FAEFE5"},
Black = {fg = "#170C21"},
BlackBG = {bg = "#170C21"},
BlackSpecial = {sp = "#170C21"},
BlinkCmpGhostTest = {fg = "#F1D9BC", nocombine = true, underdotted = true},
BlinkCmpKind = {fg = "#FAEFE5", bg = "#736B6F", blend = 20},
BlinkCmpKindClass = {fg = "#FAEFE5", bg = "#336AC9"},
BlinkCmpKindColor = {fg = "#975C67", bg = "None"},
BlinkCmpKindConstant = {fg = "#FAEFE5", bg = "#5E7262"},
BlinkCmpKindConstructor = {fg = "#FAEFE5", bg = "#131016", sp = "#8150D5", nocombine = true, underdotted = true},
BlinkCmpKindCopilot = {fg = "#FAEFE5", bg = "#131016"},
BlinkCmpKindEnum = {fg = "#FAEFE5", bg = "#417671", sp = "#B44E1D", bold = true, nocombine = true, underline = true},
BlinkCmpKindEnumMember = {fg = "#FAEFE5", bg = "#63706E"},
BlinkCmpKindEvent = {fg = "#FAEFE5", bg = "#786399", bold = true, italic = true, nocombine = true},
BlinkCmpKindField = {fg = "#FAEFE5", bg = "#776975"},
BlinkCmpKindFile = {fg = "#FAEFE5", bg = "#5E7262"},
BlinkCmpKindFolder = {fg = "#FAEFE5", bg = "#4F7654", bold = true, nocombine = true, underline = true},
BlinkCmpKindFunction = {fg = "#FAEFE5", bg = "#406DB3"},
BlinkCmpKindInterface = {fg = "#FAEFE5", bg = "#5E7440"},
BlinkCmpKindKeyword = {fg = "#FAEFE5", bg = "#786399", bold = true, nocombine = true},
BlinkCmpKindMethod = {fg = "#FAEFE5", bg = "#526F96", nocombine = true, underdotted = true},
BlinkCmpKindModule = {fg = "#FAEFE5", bg = "#985F43", bold = true, nocombine = true},
BlinkCmpKindOperator = {fg = "#FAEFE5", bg = "#427671"},
BlinkCmpKindProperty = {fg = "#FAEFE5", bg = "#8B6725"},
BlinkCmpKindReference = {fg = "#FAEFE5", bg = "#8B6724"},
BlinkCmpKindSnippet = {fg = "#FAEFE5", bg = "#986038"},
BlinkCmpKindStruct = {fg = "#FAEFE5", bg = "#5E7440", bold = true, nocombine = true},
BlinkCmpKindText = {fg = "#FAEFE5", bg = "#150E1C", italic = true, nocombine = true},
BlinkCmpKindTypeParameter = {fg = "#FAEFE5", bg = "#4F7654", nocombine = true, underdotted = true},
BlinkCmpKindUnit = {fg = "#FAEFE5", bg = "#935F5F"},
BlinkCmpKindValue = {fg = "#FAEFE5", bg = "#B34B55"},
BlinkCmpKindVariable = {fg = "#FAEFE5", bg = "#7762A1"},
BlinkCmpLabel = {fg = "#170C21"},
BlinkCmpLabelDeprecated = {fg = "#8B6724", strikethrough = true},
BlinkCmpLabelMatch = {fg = "#4F7654", bold = true},
BlinkCmpMenu = {fg = "#C7A88D", blend = 20},
BlinkCmpMenuSelection = {bg = "#EAD0BC", bold = true, nocombine = true},
Blue = {fg = "#336AC9"},
BlueBG = {bg = "#336AC9"},
BlueSpecial = {sp = "#336AC9"},
Bold = {bold = true, nocombine = true},
BoldItalic = {bold = true, italic = true, nocombine = true},
BoldItalicUndercurl = {bold = true, italic = true, nocombine = true, undercurl = true},
BoldItalicUnderdash = {bold = true, italic = true, nocombine = true, underdashed = true},
BoldItalicUnderdot = {bold = true, italic = true, nocombine = true, underdotted = true},
BoldItalicUnderline = {bold = true, italic = true, nocombine = true, underline = true},
BoldReverse = {bold = true, nocombine = true, reverse = true},
BoldUndercurl = {bold = true, nocombine = true, undercurl = true},
BoldUnderdash = {bold = true, nocombine = true, underdashed = true},
BoldUnderdot = {bold = true, nocombine = true, underdotted = true},
BoldUnderline = {bold = true, nocombine = true, underline = true},
Boolean = {fg = "#975C67"},
["@boolean"] = {link = "Boolean"},
BrightBlack = {fg = "#131016"},
BrightBlackBG = {bg = "#131016"},
BrightBlackSpecial = {sp = "#131016"},
BrightBlue = {fg = "#406DB3"},
BrightBlueBG = {bg = "#406DB3"},
BrightBlueSpecial = {sp = "#406DB3"},
BrightCyan = {fg = "#63706E"},
BrightCyanBG = {bg = "#63706E"},
BrightCyanSpecial = {sp = "#63706E"},
BrightGreen = {fg = "#5E7440"},
BrightGreenBG = {bg = "#5E7440"},
BrightGreenSpecial = {sp = "#5E7440"},
BrightGrey = {fg = "#776975"},
BrightGreyBG = {bg = "#776975"},
BrightGreySpecial = {sp = "#776975"},
BrightOrange = {fg = "#986038"},
BrightOrangeBG = {bg = "#986038"},
BrightOrangeSpecial = {sp = "#986038"},
BrightPurple = {fg = "#7762A1"},
BrightPurpleBG = {bg = "#7762A1"},
BrightPurpleSpecial = {sp = "#7762A1"},
BrightRed = {fg = "#935F5F"},
BrightRedBG = {bg = "#935F5F"},
BrightRedSpecial = {sp = "#935F5F"},
BrightWhite = {fg = "#F5F1E2"},
BrightWhiteBG = {bg = "#F5F1E2"},
BrightWhiteSpecial = {sp = "#F5F1E2"},
BrightYellow = {fg = "#8B6724"},
BrightYellowBG = {bg = "#8B6724"},
BrightYellowSpecial = {sp = "#8B6724"},
Character = {fg = "#63706E"},
["@character"] = {link = "Character"},
CmpItemAbbr = {fg = "#170C21", blend = 20, nocombine = true},
CmpItemAbbrDeprecated = {fg = "#8B6724", blend = 20},
CmpItemAbbrMatch = {fg = "#4F7654", blend = 20, bold = true, nocombine = true},
CmpItemAbbrMatchFuzzy = {fg = "#985F43", blend = 20, bold = true, nocombine = true},
CmpItemKind = {fg = "#FAEFE5", bg = "#736B6F", blend = 20},
CmpItemKindClass = {fg = "#FAEFE5", bg = "#336AC9"},
CmpItemKindColor = {fg = "#975C67", bg = "None"},
CmpItemKindConstant = {fg = "#FAEFE5", bg = "#5E7262"},
CmpItemKindConstructor = {fg = "#FAEFE5", bg = "#131016", sp = "#8150D5", nocombine = true, underdotted = true},
CmpItemKindCopilot = {fg = "#FAEFE5", bg = "#131016"},
CmpItemKindEnum = {fg = "#FAEFE5", bg = "#417671", sp = "#B44E1D", bold = true, nocombine = true, underline = true},
CmpItemKindEnumMember = {fg = "#FAEFE5", bg = "#63706E"},
CmpItemKindEvent = {fg = "#FAEFE5", bg = "#786399", bold = true, italic = true, nocombine = true},
CmpItemKindField = {fg = "#FAEFE5", bg = "#776975"},
CmpItemKindFile = {fg = "#FAEFE5", bg = "#5E7262"},
CmpItemKindFolder = {fg = "#FAEFE5", bg = "#4F7654", bold = true, nocombine = true, underline = true},
CmpItemKindFunction = {fg = "#FAEFE5", bg = "#406DB3"},
CmpItemKindInterface = {fg = "#FAEFE5", bg = "#5E7440"},
CmpItemKindKeyword = {fg = "#FAEFE5", bg = "#786399", bold = true, nocombine = true},
CmpItemKindMethod = {fg = "#FAEFE5", bg = "#526F96", nocombine = true, underdotted = true},
CmpItemKindModule = {fg = "#FAEFE5", bg = "#985F43", bold = true, nocombine = true},
CmpItemKindOperator = {fg = "#FAEFE5", bg = "#427671"},
CmpItemKindProperty = {fg = "#FAEFE5", bg = "#8B6725"},
CmpItemKindReference = {fg = "#FAEFE5", bg = "#8B6724"},
CmpItemKindSnippet = {fg = "#FAEFE5", bg = "#986038"},
CmpItemKindStruct = {fg = "#FAEFE5", bg = "#5E7440", bold = true, nocombine = true},
CmpItemKindText = {fg = "#FAEFE5", bg = "#150E1C", italic = true, nocombine = true},
CmpItemKindTypeParameter = {fg = "#FAEFE5", bg = "#4F7654", nocombine = true, underdotted = true},
CmpItemKindUnit = {fg = "#FAEFE5", bg = "#935F5F"},
CmpItemKindValue = {fg = "#FAEFE5", bg = "#B34B55"},
CmpItemKindVariable = {fg = "#FAEFE5", bg = "#7762A1"},
CmpItemMenu = {fg = "#C7A88D", blend = 20, italic = true, nocombine = true},
ColorColumn = {bg = "#F8E8DB"},
Comment = {fg = "#C7A88D", italic = true, nocombine = true},
["@comment"] = {link = "Comment"},
["@text.literal"] = {link = "Comment"},
Conceal = {fg = "#F1D9C2"},
Conditional = {fg = "#935F5F"},
["@conditional"] = {link = "Conditional"},
Constant = {fg = "#5E7262"},
["@constant"] = {link = "Constant"},
CurSearch = {bg = "#E8C6AA"},
Cursor = {nocombine = true, reverse = true},
CursorIM = {link = "Cursor"},
lCursor = {link = "Cursor"},
CursorColumn = {bg = "#F8E8DB"},
CursorLine = {bg = "#F8E8DB"},
CursorLineNr = {fg = "#7762A1", bg = "#F8E8DB"},
CursorLineFold = {link = "CursorLineNr"},
Cyan = {fg = "#427671"},
CyanBG = {bg = "#427671"},
CyanSpecial = {sp = "#427671"},
Debug = {fg = "#63706E", sp = "#427671", nocombine = true, underdashed = true},
["@debug"] = {link = "Debug"},
Define = {fg = "#417671"},
["@constant.macro"] = {link = "Define"},
["@define"] = {link = "Define"},
Delimiter = {fg = "#714D2E"},
["@punctuation"] = {link = "Delimiter"},
DiagnosticError = {fg = "#935F5F", bg = "#F4DDE0"},
DiagnosticFloatingError = {fg = "#975C67"},
DiagnosticFloatingHint = {fg = "#526F96"},
DiagnosticFloatingInfo = {fg = "#786399"},
DiagnosticFloatingOk = {fg = "#5E7262"},
DiagnosticFloatingWarn = {fg = "#8B6725"},
DiagnosticHint = {fg = "#406DB3", bg = "#D9E3F5"},
DiagnosticInfo = {fg = "#7762A1", bg = "#E6DFF4"},
DiagnosticOk = {fg = "#5E7440", bg = "#A3F5B5"},
DiagnosticSignError = {fg = "#935F5F"},
DiagnosticSignHint = {fg = "#406DB3"},
DiagnosticSignInfo = {fg = "#7762A1"},
DiagnosticSignOk = {fg = "#5E7440"},
DiagnosticSignWarn = {fg = "#8B6724"},
DiagnosticUnderlineError = {sp = "#935F5F", nocombine = true, undercurl = true},
DiagnosticUnderlineHint = {sp = "#406DB3", nocombine = true, undercurl = true},
DiagnosticUnderlineInfo = {sp = "#7762A1", nocombine = true, undercurl = true},
DiagnosticUnderlineOk = {sp = "#5E7440", nocombine = true, undercurl = true},
DiagnosticUnderlineWarn = {sp = "#8B6724", nocombine = true, undercurl = true},
DiagnosticVirtualTextError = {fg = "#935F5F", bg = "#F4DDE0", italic = true, nocombine = true},
DiagnosticVirtualTextHint = {fg = "#406DB3", bg = "#D9E3F5", italic = true, nocombine = true},
DiagnosticVirtualTextInfo = {fg = "#7762A1", bg = "#E6DFF4", italic = true, nocombine = true},
DiagnosticVirtualTextOk = {fg = "#5E7440", bg = "#A3F5B5", italic = true, nocombine = true},
DiagnosticVirtualTextWarn = {fg = "#8B6724", bg = "#F6DFC6", italic = true, nocombine = true},
DiagnosticWarn = {fg = "#8B6724", bg = "#F6DFC6"},
DiffAdd = {bg = "#F9FEF4", sp = "#5E7440"},
NeogitDiffAddHighlight = {link = "DiffAdd"},
DiffChange = {bg = "#FFFFFF", bold = true, italic = true, nocombine = true},
NeogitDiffContextHighlight = {link = "DiffChange"},
DiffDelete = {fg = "#EBC9AB", bg = "#F4F0F0"},
NeogitDiffDeleteHighlight = {link = "DiffDelete"},
DiffText = {bg = "#FFFFFF", sp = "#7762A1", nocombine = true, underdotted = true},
DimBlack = {fg = "#150E1C"},
DimBlackBG = {bg = "#150E1C"},
DimBlackSpecial = {sp = "#150E1C"},
DimBlue = {fg = "#526F96"},
DimBlueBG = {bg = "#526F96"},
DimBlueSpecial = {sp = "#526F96"},
DimCyan = {fg = "#417671"},
DimCyanBG = {bg = "#417671"},
DimCyanSpecial = {sp = "#417671"},
DimGreen = {fg = "#5E7262"},
DimGreenBG = {bg = "#5E7262"},
DimGreenSpecial = {sp = "#5E7262"},
DimGrey = {fg = "#736B6F"},
DimGreyBG = {bg = "#736B6F"},
DimGreySpecial = {sp = "#736B6F"},
DimOrange = {fg = "#985F43"},
DimOrangeBG = {bg = "#985F43"},
DimOrangeSpecial = {sp = "#985F43"},
DimPurple = {fg = "#786399"},
DimPurpleBG = {bg = "#786399"},
DimPurpleSpecial = {sp = "#786399"},
DimRed = {fg = "#975C67"},
DimRedBG = {bg = "#975C67"},
DimRedSpecial = {sp = "#975C67"},
DimWhite = {fg = "#FAEFE5"},
DimWhiteBG = {bg = "#FAEFE5"},
DimWhiteSpecial = {sp = "#FAEFE5"},
DimYellow = {fg = "#8B6725"},
DimYellowBG = {bg = "#8B6725"},
DimYellowSpecial = {sp = "#8B6725"},
Directory = {fg = "#406DB3"},
EndOfBuffer = {fg = "#F1D9C2"},
Error = {fg = "#F5F1E2", bg = "#935F5F"},
ErrorMsg = {fg = "#935F5F"},
Exception = {fg = "#935F5F", nocombine = true, underdashed = true},
["@exception"] = {link = "Exception"},
EyelinerPrimary = {fg = "#427671", sp = "#986038", nocombine = true, underdashed = true},
EyelinerSecondary = {fg = "#417671", sp = "#985F43", nocombine = true, underdashed = true},
Float = {fg = "#946313"},
["@float"] = {link = "Float"},
FloatBorder = {fg = "#736B6F"},
FloatTitle = {fg = "#776975"},
FoldColumn = {fg = "#786399", bg = "#F8E8DB"},
Folded = {fg = "#786399"},
Foreground = {fg = "#170C21"},
ForegroundBG = {bg = "#170C21"},
ForegroundSpecial = {sp = "#170C21"},
Function = {fg = "#406DB3", bold = true, italic = true, nocombine = true},
["@function"] = {link = "Function"},
["@method"] = {link = "Function"},
GitSignsAdd = {fg = "#5E7440", bg = "#F8E8DB", nocombine = true},
GitSignsAddNr = {fg = "#5E7262", bg = "#F8E8DB", nocombine = true},
GitSignsChange = {fg = "#406DB3", bg = "#F8E8DB", nocombine = true},
GitSignsChangeNr = {fg = "#526F96", bg = "#F8E8DB", nocombine = true},
GitSignsChangedelete = {fg = "#8B6724", bg = "#F8E8DB", nocombine = true},
GitSignsChangedeleteNr = {fg = "#8B6725", bg = "#F8E8DB", nocombine = true},
GitSignsDelete = {fg = "#935F5F", bg = "#F8E8DB", nocombine = true},
GitSignsDeleteNr = {fg = "#975C67", bg = "#F8E8DB", nocombine = true},
GitSignsTopdelete = {fg = "#935F5F", bg = "#F8E8DB", nocombine = true},
GitSignsTopdeleteNr = {fg = "#975C67", bg = "#F8E8DB", nocombine = true},
GitSignsUntracked = {fg = "#986038", bg = "#F8E8DB", nocombine = true},
GitSignsUntrackedNr = {fg = "#985F43", bg = "#F8E8DB", nocombine = true},
Green = {fg = "#4F7654"},
GreenBG = {bg = "#4F7654"},
GreenSpecial = {sp = "#4F7654"},
Grey = {fg = "#716B70"},
GreyBG = {bg = "#716B70"},
GreySpecial = {sp = "#716B70"},
Identifier = {fg = "#8150D5"},
["@namespace"] = {link = "Identifier"},
["@parameter"] = {link = "Identifier"},
["@text.reference"] = {link = "Identifier"},
["@variable"] = {link = "Identifier"},
Ignore = {fg = "#FAEFE5"},
IncSearch = {fg = "#170C21", bg = "#4F7654"},
Include = {fg = "#8B6725"},
["@include"] = {link = "Include"},
Italic = {italic = true, nocombine = true},
ItalicReverse = {italic = true, nocombine = true, reverse = true},
ItalicUndercurl = {italic = true, nocombine = true, undercurl = true},
ItalicUnderdash = {italic = true, nocombine = true, underdashed = true},
ItalicUnderdot = {italic = true, nocombine = true, underdotted = true},
ItalicUnderline = {italic = true, nocombine = true, underline = true},
Keyword = {fg = "#786399"},
["@keyword"] = {link = "Keyword"},
Label = {fg = "#8B6725"},
["@label"] = {link = "Label"},
LineNr = {fg = "#E2BD9C", bg = "#F8E8DB"},
LineNrAbove = {fg = "#E2BD99"},
LineNrBelow = {fg = "#E2BD99"},
LspCodeLens = {fg = "#526F96"},
LspCodeLensSeparator = {fg = "#776975"},
LspInlayHint = {fg = "#BBC8AE", italic = true, nocombine = true, underdotted = true},
LspReferenceRead = {fg = "#786399"},
LspReferenceText = {fg = "#8150D5"},
LspReferenceWrite = {fg = "#336AC9"},
LspSignatureActiveParameter = {fg = "#427671", nocombine = true, underdouble = true},
Macro = {fg = "#786399"},
["@function.macro"] = {link = "Macro"},
["@macro"] = {link = "Macro"},
MatchParen = {fg = "#8B6724"},
ModeMsg = {fg = "#736B6F"},
MoreMsg = {fg = "#8B6725"},
MsgArea = {fg = "#150E1C"},
MsgSeparator = {fg = "#736B6F"},
NeogitHunkHeader = {fg = "#7762A1", bg = "#FAEFE5", nocombine = true},
NeogitHunkHeaderHighlight = {fg = "#7762A1", bg = "#FAEFE5", bold = true, nocombine = true, underline = true},
NeotestAdapterName = {fg = "#8150D5", bold = true, nocombine = true},
NeotestBorder = {fg = "#7762A1", nocombine = true},
NeotestCanvas = {fg = "#716B70", nocombine = true},
NeotestDir = {fg = "#946313", nocombine = true},
NeotestExpandMarker = {fg = "#716B70", nocombine = true},
NeotestFailed = {fg = "#B34B55", bold = true, nocombine = true},
NeotestFile = {fg = "#4F7654", italic = true, nocombine = true},
NeotestFocused = {bg = "#F5F1E2", nocombine = true},
NeotestIndent = {fg = "#FAEFE5", nocombine = true},
NeotestMarked = {fg = "#B44E1D", bold = true, nocombine = true, underdotted = true},
NeotestNamespace = {fg = "#7762A1", nocombine = true},
NeotestPassed = {fg = "#5E7440", bold = true, nocombine = true},
NeotestRunning = {fg = "#946313", nocombine = true, underdashed = true},
NeotestSkipped = {fg = "#986038", nocombine = true, underdotted = true},
NeotestTarget = {fg = "#427671", nocombine = true},
NeotestTest = {fg = "#336AC9", bold = true, nocombine = true},
NeotestUnknown = {fg = "#736B6F", italic = true, nocombine = true},
NeotestWinSelect = {fg = "#776975", nocombine = true},
NoCombine = {nocombine = true},
NonText = {fg = "#E9C9AA"},
TelescopeBorder = {link = "NonText"},
NormalFloat = {fg = "#170C21", bg = "#FAEFE5", blend = 12},
StatusLineNC = {link = "NormalFloat"},
TelescopeNormal = {link = "NormalFloat"},
NotifyDEBUGBody = {fg = "#2B1D4D"},
NotifyDEBUGBorder = {fg = "#526F96"},
NotifyDEBUGIcon = {fg = "#406DB3"},
NotifyDEBUGTitle = {fg = "#336AC9", bold = true, nocombine = true},
NotifyERRORBody = {fg = "#331E35"},
NotifyERRORBorder = {fg = "#975C67"},
NotifyERRORIcon = {fg = "#935F5F"},
NotifyERRORTitle = {fg = "#B34B55", bold = true, nocombine = true},
NotifyINFOBody = {fg = "#301C46"},
NotifyINFOBorder = {fg = "#786399"},
NotifyINFOIcon = {fg = "#7762A1"},
NotifyINFOTitle = {fg = "#8150D5", bold = true, nocombine = true},
NotifyTRACEBody = {fg = "#361E31"},
NotifyTRACEBorder = {fg = "#985F43"},
NotifyTRACEIcon = {fg = "#986038"},
NotifyTRACETitle = {fg = "#B44E1D", bold = true, nocombine = true},
NotifyWARNBody = {fg = "#33202D"},
NotifyWARNBorder = {fg = "#8B6725"},
NotifyWARNIcon = {fg = "#8B6724"},
NotifyWARNTitle = {fg = "#946313", bold = true, nocombine = true},
Number = {fg = "#B44E1D"},
["@number"] = {link = "Number"},
Operator = {fg = "#427671"},
["@operator"] = {link = "Operator"},
Orange = {fg = "#B44E1D"},
OrangeBG = {bg = "#B44E1D"},
OrangeSpecial = {sp = "#B44E1D"},
Pmenu = {fg = "#736B6F"},
PmenuExtra = {fg = "#150E1C"},
PmenuExtraSel = {fg = "#946313"},
PmenuKind = {fg = "#170C21", bg = "#716B70"},
PmenuKindSel = {bg = "#CCFAF3", blend = 30},
PmenuSbar = {fg = "#E2BD99"},
PmenuSel = {bg = "#D5FAD9", blend = 30},
PmenuThumb = {fg = "#736B6F"},
PreCondit = {fg = "#985F43"},
PreProc = {fg = "#776975"},
["@preproc"] = {link = "PreProc"},
Purple = {fg = "#8150D5"},
PurpleBG = {bg = "#8150D5"},
PurpleSpecial = {sp = "#8150D5"},
Question = {fg = "#526F96"},
QuickFixLine = {fg = "#131016", bg = "#776975"},
Red = {fg = "#B34B55"},
RedBG = {bg = "#B34B55"},
RedSpecial = {sp = "#B34B55"},
Repeat = {fg = "#5E7440"},
["@repeat"] = {link = "Repeat"},
Reverse = {nocombine = true, reverse = true},
Search = {bg = "#FAEFE5"},
SignColumn = {bg = "#F8E8DB"},
CursorLineSign = {link = "SignColumn"},
SnippetVirtTextChoiceActive = {fg = "#5E7440"},
SnippetVirtTextChoicePassive = {fg = "#8B6724"},
SnippetVirtTextChoiceSnippetPassive = {fg = "#776975"},
SnippetVirtTextChoiceUnvisited = {fg = "#406DB3"},
SnippetVirtTextChoiceVisited = {fg = "#7762A1"},
SnippetVirtTextInsertActive = {fg = "#5E7440"},
SnippetVirtTextInsertPassive = {fg = "#8B6724"},
SnippetVirtTextInsertSnippetPassive = {fg = "#776975"},
SnippetVirtTextInsertUnvisited = {fg = "#406DB3"},
SnippetVirtTextInsertVisited = {fg = "#7762A1"},
SnippetVirtTextSnippetActive = {fg = "#5E7440"},
SnippetVirtTextSnippetPassive = {fg = "#8B6724"},
SnippetVirtTextSnippetSnippetPassive = {fg = "#776975"},
SnippetVirtTextSnippetUnvisited = {fg = "#406DB3"},
SnippetVirtTextSnippetVisited = {fg = "#7762A1"},
Special = {fg = "#131016", sp = "#8150D5", nocombine = true, underdotted = true},
["@constant.builtin"] = {link = "Special"},
["@constructor"] = {link = "Special"},
["@function.builtin"] = {link = "Special"},
SpecialChar = {fg = "#427671", sp = "#B44E1D", nocombine = true, underdouble = true},
["@character.special"] = {link = "SpecialChar"},
["@string.escape"] = {link = "SpecialChar"},
["@string.special"] = {link = "SpecialChar"},
SpecialComment = {fg = "#6C5263", sp = "#336AC9", nocombine = true, underdotted = true},
SpecialKey = {fg = "#8B6724", nocombine = true, underdouble = true},
SpellBad = {sp = "#975C67", nocombine = true, underdashed = true},
SpellCap = {sp = "#427671", nocombine = true, underdashed = true},
SpellLocal = {sp = "#4F7654", nocombine = true, underdashed = true},
SpellRare = {sp = "#7762A1", nocombine = true, underdashed = true},
Standout = {nocombine = true, standout = true},
Statement = {fg = "#975C67"},
WinBar = {link = "StatusLine"},
WinBarNC = {link = "StatusLineNC"},
StorageClass = {fg = "#417671", italic = true, nocombine = true, underdotted = true},
["@storageclass"] = {link = "StorageClass"},
StrikeThrough = {nocombine = true, strikethrough = true},
String = {fg = "#150E1C"},
["@string"] = {link = "String"},
Structure = {fg = "#5E7440", italic = true, nocombine = true, underdotted = true},
["@structure"] = {link = "Structure"},
TabLine = {bg = "#F1D9C2"},
TabLineFill = {bg = "#ECCFB4", blend = 50},
TabLineSel = {bg = "#F8E8DB"},
Tag = {fg = "#986038", sp = "#336AC9", nocombine = true, underdotted = true},
["@tag"] = {link = "Tag"},
TelescopeMatching = {fg = "#985F43", bold = true, nocombine = true},
TelescopePromptNormal = {link = "TelescopeNormal"},
TelescopePromptPrefix = {fg = "#B49C89"},
TelescopeSelection = {fg = "#526F96", bg = "#BFD0ED"},
TelescopeSelectionCaret = {fg = "#935F5F", bg = "#EBC6CB"},
TelescopeTitle = {fg = "#336AC9", bold = true, nocombine = true},
TermCursor = {nocombine = true, reverse = true},
TermCursorNC = {bg = "#E8C6AA"},
Title = {fg = "#776975"},
["@text.title"] = {link = "Title"},
Todo = {fg = "#F5F1E2", bg = "#406DB3"},
["@text.todo"] = {link = "Todo"},
Type = {fg = "#4F7654", italic = true, nocombine = true, underdotted = true},
["@type"] = {link = "Type"},
Typedef = {fg = "#526F96", italic = true, nocombine = true, underdotted = true},
["@type.definition"] = {link = "Typedef"},
Undercurl = {nocombine = true, undercurl = true},
Underdash = {nocombine = true, underdashed = true},
Underdot = {nocombine = true, underdotted = true},
Underdouble = {nocombine = true, underdouble = true},
Underline = {nocombine = true, underline = true},
Underlined = {nocombine = true, underline = true},
["@text.underline"] = {link = "Underlined"},
VertSplit = {fg = "#8A7B77"},
Visual = {bg = "#F4C790"},
VisualNOS = {bg = "#E2A14D"},
WarningMsg = {fg = "#8B6724"},
White = {fg = "#FAEFE5"},
WhiteBG = {bg = "#FAEFE5"},
WhiteSpecial = {sp = "#FAEFE5"},
Whitespace = {fg = "#E2BD99"},
WildMenu = {fg = "#F5F1E2", bg = "#985F43"},
Winseparator = {fg = "#E9C9AA"},
Yellow = {fg = "#946313"},
YellowBG = {bg = "#946313"},
YellowSpecial = {sp = "#946313"},
["@field"] = {fg = "#786399"},
["@property"] = {fg = "#786399"},
["@text.uri"] = {sp = "#406DB3", nocombine = true, underline = true},
	-- PATCH_CLOSE
	-- content here will not be touched
}

-- colorschemes generally want to do this
cmd.highlight('clear')
vim.g.colors_name = 'crepuscular_dawn'
opt.background = 'light'

-- Sets the colorscheme to be Crepuscular
cmd.colorscheme(vim.g.colors_name)

-- apply highlight groups
for group, attrs in pairs(colors) do
	api.nvim_set_hl(0, group, attrs)
end
