local color_mode = vim.opt.background:get()
local theme_variant = color_mode == 'dark' and 'dusk' or 'dawn'
local colorscheme_path = 'lxs.' .. vim.g.colors_name .. '.' .. theme_variant

vim.notify_once(string.format('Applying the %s variant', theme_variant), vim.log.levels.INFO, {
	title = 'Crepuscular',
	timeout = 1000,
})

package.loaded[colorscheme_path] = nil
return require(colorscheme_path)
