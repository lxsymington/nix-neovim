---@mod lxs.terraform
---
---@brief [[
---Terraform related function
---@brief ]]

local lint = require('lint')

local fs = vim.fs
local lsp = vim.lsp

local M = {}
local root_files = {
	'.terraform',
	'.git',
}

function M.start()
	lsp.start({
		name = 'terraform',
		cmd = { 'terraform-ls', 'serve' },
		filetypes = { 'terraform', 'terraform-vars' },
		root_dir = fs.dirname(fs.find(root_files, { upward = true })[1]),
		capabilities = require('lxs.lsp').make_client_capabilities(),
	})

	lint.linters_by_ft = {
		tf = { 'terraform_validate' },
		terraform = { 'terraform_validate' },
		['terraform-vars'] = { 'terraform_validate' },
	}
end

return M
