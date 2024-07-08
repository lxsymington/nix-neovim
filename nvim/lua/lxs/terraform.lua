---@mod lxs.terraform
---
---@brief [[
---Terraform related function
---@brief ]]

local lspconfig = require('lspconfig')
local lint = require('lint')

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

	local ns = lint.get_namespace('terraform_validate')
	vim.diagnostic.config({
		virtual_text = {
			suffix = ' 🚩 terraform validate',
		},
	}, ns)
end

return M
