local api = vim.api
local lint = require('lint')

-- Linting –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
local lint_group = api.nvim_create_augroup('lint', { clear = true })
api.nvim_create_autocmd({ 'FileReadPost', 'TextChanged', 'ModeChanged', 'FocusGained' }, {
	group = lint_group,
	callback = function()
		lint.try_lint()
	end,
})

lint.linters.tslint = {
	cmd = 'tslint',
	stdin = false, -- or false if it doesn't support content input via stdin. In that case the filename is automatically added to the arguments.
	append_fname = true, -- Automatically append the file name to `args` if `stdin = false` (default: true)
	args = {}, -- list of arguments. Can contain functions with zero arguments that will be evaluated once the linter is used.
	stream = 'both', -- ('stdout' | 'stderr' | 'both') configure the stream to which the linter outputs the linting result.
	ignore_exitcode = true, -- set this to true if the linter exits with a code != 0 and that's considered normal.
	env = nil, -- custom environment table to use with the external process. Note that this replaces the *entire* environment, it is not additive.
	parser = require('lint.parser').from_errorformat('%f[%l, %c]: %m'), -- errorformat string or function to parse the linter output
}
