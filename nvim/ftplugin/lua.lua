local lint = require('lint')

vim.bo.comments = ':---,:--'

local lua_ls_cmd = 'lua-language-server'

-- Check if lua-language-server is available
if vim.fn.executable(lua_ls_cmd) ~= 1 then
	return
end

local root_files = {
	'.luarc.json',
	'.luarc.jsonc',
	'.luacheckrc',
	'.stylua.toml',
	'stylua.toml',
	'selene.toml',
	'selene.yml',
	'.git',
}

vim.lsp.start({
	name = 'luals',
	cmd = { lua_ls_cmd },
	root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
	capabilities = require('lxs.lsp').make_client_capabilities(),
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			completion = {
				callSnippet = 'Replace',
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global, etc.
				globals = {
					'vim',
					'describe',
					'it',
					'assert',
					'stub',
				},
				disable = {
					'duplicate-set-field',
				},
			},
			workspace = {
				checkThirdParty = false,
				library = {
					'${3rd}/luv/library',
					unpack(vim.api.nvim_get_runtime_file('', true)),
				},
			},
			telemetry = {
				enable = false,
			},
			hint = { -- inlay hints (supported in Neovim >= 0.10)
				enable = true,
			},
		},
	},
})

lint.linters_by_ft = {
	lua = { 'selene' },
}

local ns = lint.get_namespace('selene')
vim.diagnostic.config({
	virtual_text = {
		suffix = ' 🚩 selene',
	},
}, ns)
