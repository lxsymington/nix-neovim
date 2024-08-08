local color_mode = vim.opt.background:get()
local theme_variant = color_mode == 'dark' and 'dusk' or 'dawn'
local colorscheme_path = 'lxs.' .. vim.g.colors_name .. '.' .. theme_variant

package.loaded[colorscheme_path] = nil
return require(colorscheme_path)
