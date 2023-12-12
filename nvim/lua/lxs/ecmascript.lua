---@mod lxs.ecmascript
---
---@brief [[
---ECMAScript related functions
---@brief ]]
local lint = require('lint')

local api = vim.api
local fs = vim.fs
local keymap = vim.keymap
local lsp = vim.lsp

local M = {}

local function organize_imports(buf)
	local params = {
		command = '_typescript.organizeImports',
		title = 'Organise imports',
		arguments = { api.nvim_buf_get_name(buf or 0) },
	}

	lsp.buf_request_sync(buf or 0, 'workspace/executeCommand', params, 1000)
end

local root_files = {
	'package.json',
	'tsconfig.json',
}

function M.start()
	-- TODO: Conditionally use Deno if it's available
	lsp.start({
		name = 'tsserver',
		cmd = { 'typescript-language-server', '--stdio' },
		init_options = { hostInfo = 'neovim' },
		root_dir = fs.dirname(fs.find(root_files, { upward = true })[1]),
		single_file_support = true,
		capabilities = require('lxs.lsp').make_client_capabilities(),
		on_attach = function(_, buf)
			keymap.set('n', '@I', function()
				organize_imports(buf)
			end, { buffer = buf, desc = 'Organise imports' })
		end,
	})

	lint.linters_by_ft = {
		-- typescript = { 'tslint' },
		-- typescriptreact = { 'tslint' },
		-- ['typescript.tsx'] = { 'tslint' },
	}
end

return M
