local g = vim.g

if g.did_load_plugins_plugin then
	return
end
g.did_load_plugins_plugin = true

-- many plugins annoyingly require a call to a 'setup' function to be loaded,
-- even with default configs

-- Indent Blankline ————————————————————————————————————————————————————————————
require('ibl').setup({
	indent = { char = '┊' },
	scope = {
		char = '│',
		highlight = { 'Function', 'Label' },
		show_exact_scope = true,
	},
	whitespace = { highlight = { 'Whitespace', 'NonText' } },
})

-- Comment —————————————————————————————————————————————————————————————————————
require('Comment').setup({
	pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})

-- Enable EditorConfig
g.editorconfig = true

-- let sqlite.lua (which some plugins depend on) know where to find sqlite
g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')
