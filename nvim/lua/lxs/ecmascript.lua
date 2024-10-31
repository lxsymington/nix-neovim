---@mod lxs.ecmascript
---
---@brief [[
---ECMAScript related functions
---@brief ]]
local lspconfig = require('lspconfig')
local lint = require('lint')
local typescript_tools = require('typescript-tools')

local api = vim.api
local fn = vim.fn
local fs = vim.fs
local keymap = vim.keymap
local lsp = vim.lsp
local opt = vim.opt

local M = {}

local function organize_imports(buf)
	local params = {
		command = '_typescript.organizeImports',
		title = 'Organise imports',
		arguments = { api.nvim_buf_get_name(buf or 0) },
	}

	lsp.buf_request_sync(buf or 0, 'workspace/executeCommand', params, 1000)
end

function M.start()
	if fn.executable('tsserver') == 1 then
		typescript_tools.setup({
			name = 'typescript-language-server',
			capabilities = require('lxs.lsp').make_client_capabilities(),
			on_attach = function(_, buf)
				keymap.set('n', 'goi', function()
					organize_imports(buf)
				end, { buffer = buf, desc = 'Organise imports' })
			end,
			settings = {
				expose_as_code_action = 'all',
				tsserver_file_preferences = {
					includeInlayParameterNameHints = 'all',
					includeCompletionsForModuleExports = true,
					quotePreference = 'auto',
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayVariableTypeHintsWhenTypeMatchesName = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
				tsserver_format_options = {
					allowIncompleteCompletions = false,
					allowRenameOfImportPath = false,
				},
			},
		})
	end

	if fn.executable('vscode-eslint-language-server') == 1 then
		lspconfig.eslint.setup({
			capabilities = require('lxs.lsp').make_client_capabilities(),
		})
	end

	if fn.executable('deno') == 1 then
		lspconfig.denols.setup({
			root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc'),
		})
	end

	local tslint_config_file = fs.find('tslint.json', { upward = true })[1]

	if tslint_config_file then
		lint.linters_by_ft = {
			typescript = { 'tslint' },
			typescriptreact = { 'tslint' },
			['typescript.tsx'] = { 'tslint' },
		}
	end

	opt.wildignore:append([[ '*/node_modules/*' ]])
end

return M
