local g = vim.g
-- many plugins annoyingly require a call to a 'setup' function to be loaded,
-- even with default configs

require('nvim-surround').setup()

-- Enable EditorConfig
g.editorconfig = true

-- let sqlite.lua (which some plugins depend on) know where to find sqlite
g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')
