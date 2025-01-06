local g = vim.g
local opt = vim.opt

if g.neovide then
	g.neovide_floating_blur_amount_x = 3.0
	g.neovide_floating_blur_amount_y = 3.0
	g.neovide_padding_bottom = 8
	g.neovide_padding_left = 8
	g.neovide_padding_right = 8
	g.neovide_padding_top = 8
	g.neovide_theme = 'auto'
	g.neovide_transparency = 0.0
	g.neovide_window_blurred = true
	g.neovide_input_macos_option_key_is_meta = 'only_left'

	opt.guifont = 'CommitMono_Nerd_Font_Propo,RecMono_Nerd_Font_Propo:h12'
	opt.linespace = 4
end
