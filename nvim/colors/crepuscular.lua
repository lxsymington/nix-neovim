local lush = require('lush')

vim.notify_once('Loaded ' .. vim.g.colors_name, vim.log.levels.INFO, {
	title = 'Crepuscular',
	timeout = 1000,
})

package.loaded['lxs.' .. vim.g.colors_name] = nil
local theme = require('lxs.' .. vim.g.colors_name)
lush.apply(theme)
