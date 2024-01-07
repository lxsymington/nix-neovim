local g = vim.g
-- many plugins annoyingly require a call to a 'setup' function to be loaded,
-- even with default configs

-- Satellite –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
require('satellite').setup({})

-- Hover Hints –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
require('hoverhints').setup({})

-- Indent Blankline ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
require('ibl').setup()

-- Nvim Surround –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
require('nvim-surround').setup()

-- Comment –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
require('Comment').setup({
	pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})

-- Enable EditorConfig
g.editorconfig = true

-- let sqlite.lua (which some plugins depend on) know where to find sqlite
g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')
