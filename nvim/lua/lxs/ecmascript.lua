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

local ecmascript_root_files = {
	'package.json',
	'tsconfig.json',
}

local eslint_root_files = {
	'.eslintrc',
	'.eslintrc.cjs',
	'.eslintrc.js',
	'.eslintrc.json',
	'.eslintrc.yaml',
	'.eslintrc.yml',
}

function M.start()
	-- TODO: Conditionally use Deno if it's available
	lsp.start({
		name = 'tsserver',
		cmd = { 'typescript-language-server', '--stdio' },
		init_options = { hostInfo = 'neovim' },
		root_dir = fs.dirname(fs.find(ecmascript_root_files, { upward = true })[1]),
		single_file_support = true,
		capabilities = require('lxs.lsp').make_client_capabilities(),
		on_attach = function(_, buf)
			keymap.set('n', 'goi', function()
				organize_imports(buf)
			end, { buffer = buf, desc = 'Organise imports' })
		end,
	})

	local eslint_config_file = fs.find(eslint_root_files, { upward = true })[1]

	if eslint_config_file then
		lsp.start({
			name = 'eslint',
			cmd = { 'eslint-langserver', '--stdio' },
			root_dir = fs.dirname(eslint_config_file),
			init_options = {
				provideFormatter = true,
			},
			capabilities = require('lxs.lsp').make_client_capabilities(),
			settings = {
				codeAction = {
					disableRuleComment = {
						enable = true,
						location = 'separateLine',
					},
					showDocumentation = {
						enable = true,
					},
				},
				onIgnoredFiles = 'off',
				problems = {
					shortenToSingleLine = false,
				},
				validate = 'on',
				format = true,
				workingDirecotry = {
					mode = 'auto',
				},
			},
			on_new_config = function(config, new_root_dir)
				config.settings.workspaceFolder = {
					uri = new_root_dir,
					name = vim.fs.basename(new_root_dir),
				}
			end,
		})
	end

	lint.linters_by_ft = {
		typescript = { 'tslint' },
		typescriptreact = { 'tslint' },
		['typescript.tsx'] = { 'tslint' },
	}

	opt.wildignore:append([[ '*/node_modules/*' ]])
end

return M
