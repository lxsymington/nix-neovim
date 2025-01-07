---@mod lxs.ecmascript
---
---@brief [[
---ECMAScript related functions
---@brief ]]
local lint = require('lint')

local fs = vim.fs
local opt = vim.opt

local M = {}

function M.start()
	local tslint_config_file = fs.find('tslint.json', { upward = true })[1]

	if tslint_config_file then
		lint.linters_by_ft = {
			typescript = { 'tslint' },
			typescriptreact = { 'tslint' },
			['typescript.tsx'] = { 'tslint' },
		}
	end

	opt.wildignore:append([[ '*/node_modules/*' ]])

	opt.spelloptions = 'camel'
end

return M
