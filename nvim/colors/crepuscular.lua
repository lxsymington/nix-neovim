local lush = require('lush')
local notify_once = vim.notify_once
local g = vim.g
local log = vim.log

g.colors_name = 'crepuscular'

notify_once('Loaded ' .. g.colors_name, log.levels.INFO, {
	title = 'Crepuscular',
	timeout = 1000,
})

package.loaded['lxs.' .. g.colors_name] = nil
local theme = require('lxs.' .. g.colors_name)
lush.apply(theme)
