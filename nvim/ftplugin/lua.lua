local lint = require('lint')
local lspconfig = require('lspconfig')
local lazydev = require('lazydev')
local icons = require('mini.icons')

vim.bo.comments = ':---,:--'

-- Check if lua-language-server is available
if vim.fn.executable('lua-language-server') == 1 then
	lspconfig.lua_ls.setup({
		name = 'luals',
		capabilities = require('lxs.lsp').make_client_capabilities(),
		on_init = function(client)
			local path = client.workspace_folders[1].name
			if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
				return
			end

			client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
				runtime = {
					-- Tell the language server which version of Lua you're using
					-- (most likely LuaJIT in the case of Neovim)
					version = 'LuaJIT',
				},
				-- Make the server aware of Neovim runtime files
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
						-- Depending on the usage, you might want to add additional paths here.
						'${3rd}/luv/library',
						'${3rd}/busted/library',
					},
				},
			})
		end,
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
				telemetry = {
					enable = false,
				},
				hint = { -- inlay hints (supported in Neovim >= 0.10)
					enable = true,
				},
			},
		},
	})
end

lint.linters_by_ft = {
	lua = { 'selene' },
}

local icon, _hl, _is_default = icons.get('file', vim.fn.expand('%'))
local ns = lint.get_namespace('selene')
vim.diagnostic.config(
	vim.tbl_deep_extend('force', vim.diagnostic.config(), {
		virtual_text = {
			suffix = string.format(' ⁅%s selene⁆', icon),
		},
	}),
	ns
)

lazydev.setup({
	library = {
		-- See the configuration section for more details
		-- Load luvit types when the `vim.uv` word is found
		{ path = 'luvit-meta/library', words = { 'vim%.uv' } },
	},
	integrations = {
		lspconfig = true,
		cmp = true,
	},
})
