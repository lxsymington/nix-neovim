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
			sign = { name = { 'Diagnostic' }, maxwidth = 2, auto = true },
			click = 'v:lua.ScSa',
		},
		{
			text = { builtin.lnumfunc, ' ' },
			condition = { true, builtin.not_empty },
			click = 'v:lua.ScLa',
		},
		{
			sign = { name = { '.*' }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
			click = 'v:lua.ScSa',
		},
	},
	setopt = true,
	thousands = ',',
})
