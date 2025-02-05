--[[ vim.cmd.packadd({
	args = { 'jirac' },
	bang = true,
})
local jirac = require('jirac')

local system = vim.system

local email = system(
	{ 'op', 'read', 'op://Private/Atlassian/username', '--no-newline' },
	{ text = true }
):wait().stdout

local api_key = system(
	{ 'op', 'read', 'op://Private/Atlassian/api_token', '--no-newline' },
	{ text = true }
):wait().stdout

jirac.setup({
	email = email,
	jira_domain = 'seccltech.atlassian.net',
	api_key = api_key,
	config = {
		default_project_key = 'SECCL',
		keymaps = {
			['refresh-window'] = {
				mode = 'n',
				key = '<F5>',
			},
		},
		window_width = 150,
		window_height = 50,
	},
}) ]]
