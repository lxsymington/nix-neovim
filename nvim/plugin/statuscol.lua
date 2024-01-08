if vim.g.did_load_statuscol_plugin then
  return
end
vim.g.did_load_statuscol_plugin = true

local builtin = require('statuscol.builtin')

-- StatusCol –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
require('statuscol').setup({
	relculright = true,
	segments = {
		{ text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
		{
			sign = { name = { 'Diagnostic' }, maxwidth = 2, colwidth = 1, auto = true },
			click = 'v:lua.ScSa',
		},
		{ text = { builtin.lnumfunc }, click = 'v:lua.ScLa' },
		{
			sign = {
				name = { '.*' },
				namespace = { '.*' },
				maxwidth = 2,
				colwidth = 1,
				wrap = true,
				auto = true,
			},
			click = 'v:lua.ScSa',
		},
		{ text = { '┃' }, condition = { builtin.not_empty } },
	},
	setopt = true,
	thousands = ',',
})
