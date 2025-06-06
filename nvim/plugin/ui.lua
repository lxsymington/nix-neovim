local opt = vim.opt

-- UI –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
-- Keeps X lines visible when scrolling
opt.scrolloff = 5

-- Enabel auto indent
opt.autoindent = true

-- Copy the previous indentation on autoindenting
opt.copyindent = true

-- Syntax aware indent correction
opt.cindent = true
opt.smartindent = true

-- Highlight matching parens
opt.showmatch = true

-- Show command in bottom bar
opt.showcmd = true

-- Enables the highlighting of search results
opt.hlsearch = true

-- Show search matches as you type
opt.incsearch = true

-- Preview effects of :s as you type
opt.inccommand = 'split'

-- Visual autocomplete of command menu
opt.wildmenu = true

-- Wildmode settings
opt.wildmode = { 'longest:full', 'full' }

-- Wild options
opt.wildoptions = 'pum'

-- Highlights the current line
opt.cursorline = true

-- Set the amount of time before a redraw is abandoned
opt.redrawtime = 200

-- Redraws only when needed
opt.lazyredraw = true

-- Keep 50 lines of command line history
opt.history = 50

-- Always show the sign column
opt.signcolumn = 'yes:2'

-- Make splits remain equal
opt.equalalways = true
opt.eadirection = 'both'

-- Display the foldcolumn
opt.foldcolumn = '1'

-- Enable folding by default
opt.foldenable = true

-- Sets the initial fold state
opt.foldlevelstart = 3

-- Use an expression for the foldmethod
opt.foldmethod = 'expr'

-- Use tree-sitter for the foldexpr
opt.foldexpr = 'nvim_treesitter#foldexpr()'

-- Match the indent for the fold display
opt.foldtext = ''

-- Set maximum nesting of folds
opt.foldnestmax = 20

-- Set the minimum size of the fold
opt.foldminlines = 1

-- Enable pseudo-transparency for popup menus
opt.pumblend = 10

-- minimum width of the popup menu
opt.pumwidth = 30

-- maximum width of the popup menu
opt.pummaxwidth = 80

-- Enable pseudo-transparency for floating windows
opt.winblend = 10

-- Set characters to fill the statuslines and vertical separators.
opt.fillchars = {
	stl = ' ', -- ' ' or '^' statusline of the current window
	stlnc = ' ', -- ' ' or '=' statusline of the non-current windows
	vert = '│', -- '│' or '|' vertical separators |:vsplit|
	fold = '╌', -- '·' or '-' filling 'foldtext'
	foldopen = '▽', -- '-' mark the beginning of a fold
	foldclose = '▶', -- '+' show a closed fold
	foldsep = '┆', -- '│' or '|' open fold middle marker
	diff = '╳', -- '-' deleted lines of the 'diff' option | alternatives = ☷ ▧ ▩ ⣿ ▒ ░ ░ ▚ ▞ ─ ╱ ╳
	msgsep = '━', -- ' ' message separator 'display'
	eob = '∅', -- '~' empty lines at the end of a buffer
}

-- Use a global status bar
opt.laststatus = 3

-- let Vim set the text of the window icon
opt.icon = true

-- string to use for the Vim icon text
opt.iconstring = ''

-- whether concealable text is shown or hidden
opt.conceallevel = 2

-- whether concealable text is hidden in cursor line
opt.concealcursor = 'nc'

-- Vim cmd line height is only visible during use
-- opt.cmdheight = 0

-- Default to using a 'rounded' border for floating windows
-- opt.winborder = 'rounded'
