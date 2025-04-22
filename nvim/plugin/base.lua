local opt = vim.opt
local g = vim.g
local fn = vim.fn

-- General ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
-- Sets encoding to UTF-8
opt.fileencoding = 'utf-8'

-- Do not add BOM marks
opt.bomb = false

-- Use host system format
opt.fileformats = { 'unix', 'dos', 'mac' }

-- Enables syntax highlighting
opt.syntax = 'enable'

-- Sets the backspace behaviour to conventional
opt.backspace = { 'indent', 'eol', 'start' }

-- Change the default leader ('\') character for custom mappings
g.mapleader = ' '
g.maplocalleader = ' '

-- When a new horizontal split is opened it is opened below
opt.splitbelow = true

-- When a new vertical split is opened it is opened to the right
opt.splitright = true

-- the behaviour when switching between buffers.
opt.switchbuf = { 'usetab', 'useopen', 'newtab' }

-- Enables line numbers
opt.number = true
opt.relativenumber = true

-- Force the cursor onto a new line after 100 characters
opt.textwidth = 100

-- Creates a visual boundary
opt.colorcolumn = { '81', '+1' }

-- Displays invisibles
opt.list = true

-- Sets characters to display for invisible characters
opt.listchars = {
	space = '┈',
	tab = '╾┈╼',
	eol = '␤',
	nbsp = '␠',
	extends = '↩',
	precedes = '↪',
	conceal = '⊹',
}

-- Sets ambiguous width characters to be single width
opt.ambiwidth = 'single'

-- Hide the default mode text (e.g. -- INSERT -- below the statusline)
opt.showmode = false

-- Enable the mouse
opt.mouse = 'a'

-- Set the chord timeout length to 100ms
opt.timeoutlen = 300
opt.ttimeoutlen = 100

-- configure text wrapping within the editor space
opt.wrap = true
opt.wrapmargin = 5
opt.linebreak = true
opt.showbreak = '↪'

-- Set wrapped lines to continue visual indentation
opt.breakindent = true

-- Set breakindent options
opt.breakindentopt = {
	'list:-1',
	'min:15',
	'shift:0',
	'sbr',
}

-- Hide abandoned buffers instead of unloading them
opt.hidden = true

-- Enable auto-saving
opt.autowrite = true
opt.autowriteall = true

-- Enable auto-reading
opt.autoread = true

-- ask what to do about unsaved/read-only files
opt.confirm = true

-- Do not keep a backup file, use versions instead
opt.backup = false
opt.writebackup = false

-- Set a shorter time before the CursorHold event is triggered
opt.updatetime = 300

-- Don't show |ins-completion-menu| messages
opt.shortmess:append('c')

-- Improve mergetool and diff experience by using git's built in diff
opt.diffopt = {
	'indent-heuristic',
	'algorithm:patience',
	'filler',
	'iblank',
	'internal',
	'iwhiteall',
	'linematch:20',
}

-- Keep an undo file (undo changes after closing)
if fn.has('persistent_undo') then
	opt.undofile = true
end

-- Visual spaces per tab
opt.tabstop = 2

-- Size of a <TAB> character
opt.shiftwidth = 2

-- Number of spaces per tab
opt.softtabstop = 2

-- Use multiples of shiftwidth when indenting with '<' and '>'
opt.shiftround = true

-- Insert spaces when pressing tab
opt.expandtab = true

-- Insert tabs on the start of a line according to shiftwidth not tabstop
opt.smarttab = true

-- ignore case in search patterns
opt.ignorecase = true

-- adjust case of match for keyword completion
opt.infercase = true

-- pairs of characters that "%" can match
opt.matchpairs:append('<:>')

-- number formats recognized for CTRL-A command
opt.nrformats:append('unsigned')

-- Enable spell checking
opt.spell = true
opt.spelllang = 'en_gb'

-- Add sub folders to vim's search path
opt.path:append('**')

-- Enable virtual editing
opt.virtualedit = 'block'

-- Enable project specific settings
opt.exrc = true

-- Keep the text on the same screen line when opening, closing or resizing horizontal splits
opt.splitkeep = 'screen'
