local env = vim.env
local tbl_deep_extend = vim.tbl_deep_extend
local uv = vim.uv

vim.lsp.config('lua_ls', {
	capabilities = require('lxs.lsp').make_client_capabilities(),
	on_attach = require('lxs.lsp').attach,
	on_init = function(client)
		local path = client.workspace_folders[1].name
		if uv.fs_stat(path .. '/.luarc.json') or uv.fs_stat(path .. '/.luarc.jsonc') then
			return
		end

		client.config.settings.Lua = tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT',
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					env.VIMRUNTIME,
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
