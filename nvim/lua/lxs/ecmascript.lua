---@mod lxs.ecmascript
---
---@brief [[
---ECMAScript related functions
---@brief ]]
local opt = vim.opt

local M = {}

function M.start()
	opt.wildignore:append([[ '*/node_modules/*' ]])

	opt.spelloptions = 'camel'
end

return M
