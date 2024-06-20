if vim.g.did_load_git_integration_plugin then
	return
end
vim.g.did_load_git_integration_plugin = true

local git = require('mini.git')
local diff = require('mini.diff')

git.setup()

local diff_options = {}

for _, list_item in ipairs(vim.opt.diffopt:get()) do
	local entry = vim.split(list_item, ':', { trimempty = true })
	local key, value = unpack(entry)

	diff_options[key] = value ~= nil and value or true
end

diff.setup({
	view = {
		style = 'sign',
		signs = {
			add = '┃',
			change = '┋',
			delete = '┣',
		},
	},
	options = {
		algorithm = diff_options.algorithm,
		indent_heuristic = diff_options['indent-heuristic'],
		linematch = diff_options['line-match'],
	},
})
