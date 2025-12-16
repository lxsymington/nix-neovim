if vim.g.did_load_session_plugin then
	return
end
vim.g.did_load_session_plugin = true

local session = require('resession')
local keymap = vim.keymap
local api = vim.api
local fn = vim.fn
local trim = vim.trim
local v = vim.v

session.setup({
	autosave = {
		enabled = true,
		interval = 60,
		notify = true,
	},
	extensions = {
		aerial = {},
		quickfix = {},
		overseer = {},
	},
})

keymap.set('n', '<Leader>sw', session.save, { desc = 'Session Write' })
keymap.set('n', '<Leader>sr', session.load, { desc = 'Session Read' })

api.nvim_create_autocmd('VimLeavePre', {
	callback = function()
		-- Always save a special session named "last"
		session.save('last')
	end,
})

local function get_session_name()
	local name = fn.getcwd()
	local branch = trim(fn.system('git branch --show-current'))
	if v.shell_error == 0 then
		return name .. branch
	else
		return name
	end
end

api.nvim_create_autocmd('VimEnter', {
	callback = function()
		-- Only load the session if nvim was started with no args
		if fn.argc(-1) == 0 then
			session.load(get_session_name(), { dir = 'dirsession', silence_errors = true })
		end
	end,
})

api.nvim_create_autocmd('VimLeavePre', {
	callback = function()
		session.save(get_session_name(), { dir = 'dirsession', notify = false })
	end,
})
