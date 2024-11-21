---@mod lxs.terraform
---
---@brief [[
---Terraform related function
---@brief ]]

local lint = require('lint')
local icons = require('mini.icons')

local diagnostic = vim.diagnostic
local fn = vim.fn
local tbl_deep_extend = vim.tbl_deep_extend

local M = {}

function M.start()
	if fn.executable('terraform') ~= 1 then
		return
	end

	lint.linters_by_ft = {
		tf = { 'terraform_validate' },
		terraform = { 'terraform_validate' },
		['terraform-vars'] = { 'terraform_validate' },
	}

	local icon, _hl, _is_default = icons.get('file', fn.expand('%'))
	local ns = lint.get_namespace('terraform_validate')
	diagnostic.config(
		tbl_deep_extend('force', diagnostic.config(), {
			virtual_text = {
				suffix = string.format(' ⁅%s terraform validate⁆', icon),
			},
		}),
		ns
	)
end

return M
