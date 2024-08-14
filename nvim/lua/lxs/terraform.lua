---@mod lxs.terraform
---
---@brief [[
---Terraform related function
---@brief ]]

local lspconfig = require('lspconfig')
local lint = require('lint')
local icons = require('mini.icons')

local M = {}

function M.start()
	if vim.fn.executable('terraform') ~= 1 then
		return
	end

	lspconfig.terraform.setup({
		capabilities = require('lxs.lsp').make_client_capabilities(),
	})

	lint.linters_by_ft = {
		tf = { 'terraform_validate' },
		terraform = { 'terraform_validate' },
		['terraform-vars'] = { 'terraform_validate' },
	}

	local icon, _hl, _is_default = icons.get('file', vim.fn.expand('%'))
	local ns = lint.get_namespace('terraform_validate')
	vim.diagnostic.config(
		vim.tbl_deep_extend('force', vim.diagnostic.config(), {
			virtual_text = {
				suffix = string.format(' ⁅%s terraform validate⁆', icon),
			},
		}),
		ns
	)
end

return M
