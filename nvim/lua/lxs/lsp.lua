---@mod lxs.lsp
---
---@brief [[
---LSP related functions
---@brief ]]

local api = vim.api
local bo = vim.bo
local env = vim.env
local fn = vim.fn
local log = vim.log
local keymap = vim.keymap
local lsp = vim.lsp
local notify = vim.notify
local opt_local = vim.opt_local
local tbl_deep_extend = vim.tbl_deep_extend
local tbl_isempty = vim.tbl_isempty
local uv = vim.uv

local M = {}

---Gets a 'ClientCapabilities' object, describing the LSP client capabilities
---Extends the object with capabilities provided by plugins.
---@return lsp.ClientCapabilities
function M.make_client_capabilities()
	local capabilities = lsp.protocol.make_client_capabilities()
	-- Add any additional plugin capabilities here.
	capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
	-- Make sure to follow the instructions provided in the plugin's docs.
	return capabilities
end

local function document_highlight(bufnr, client)
	if not client then
		return
	end

	if client.server_capabilities.documentHighlightProvider then
		-- Highlight the current symbol in the document
		-- Clear highlight when leaving the current symbol in the document
		local highlight_group = api.nvim_create_augroup('LSP Document Highlight', { clear = true })
		api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
			buffer = bufnr,
			callback = lsp.buf.document_highlight,
			group = highlight_group,
		})
		api.nvim_create_autocmd('CursorMoved', {
			buffer = bufnr,
			callback = lsp.buf.clear_references,
			group = highlight_group,
		})
	end
end

local function preview_location_callback(_, result)
	if result == nil or tbl_isempty(result) then
		return nil
	end

	local buf, _ = lsp.util.preview_location(result[1], { border = 'rounded' })
	if buf then
		local cur_buf = api.nvim_get_current_buf()
		bo[buf].filetype = bo[cur_buf].filetype
	end
end

local function peek_definition()
	local params = lsp.util.make_position_params()
	return lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end

local function peek_type_definition()
	local params = lsp.util.make_position_params()
	return lsp.buf_request(0, 'textDocument/typeDefinition', params, preview_location_callback)
end

local function refresh_codeLens(bufnr, client)
	if not client then
		return
	end

	local group = api.nvim_create_augroup(string.format('lsp-%s-%s', bufnr, client.id), {})

	if
		(
			type(client.server_capabilities.codeLensProvider) == 'boolean'
			and client.server_capabilities.codeLensProvider == true
		)
		or (
			type(client.server_capabilities.codeLensProvider) == 'table'
			and client.server_capabilities.codeLensProvider.resolveProvider
		)
	then
		api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost', 'TextChanged' }, {
			group = group,
			callback = function()
				lsp.codelens.refresh({ bufnr = bufnr })
			end,
			buffer = bufnr,
		})
		lsp.codelens.refresh({ bufnr = bufnr })
	end
end

function M.attach(client, bufnr)
	opt_local.signcolumn = 'yes'
	bo[bufnr].bufhidden = 'hide'

	-- Enable completion triggered by <c-x><c-o>
	bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

	local function desc(description)
		return { noremap = true, silent = true, buffer = bufnr, desc = description }
	end
	keymap.set('n', 'gD', lsp.buf.declaration, desc('[lsp] go to declaration'))
	keymap.set('n', 'gd', lsp.buf.definition, desc('[lsp] go to definition'))
	keymap.set('n', 'gT', lsp.buf.type_definition, desc('[lsp] go to type definition'))
	keymap.set('n', 'K', function()
		lsp.buf.hover({
			border = 'rounded',
		})
	end, desc('[lsp] hover'))
	keymap.set('n', "g'", peek_definition, desc('[lsp] peek definition'))
	keymap.set('n', 'g"', peek_type_definition, desc('[lsp] peek type definition'))
	keymap.set('n', 'gI', lsp.buf.implementation, desc('[lsp] go to implementation'))
	keymap.set('n', 'g%', lsp.buf.references, desc('[lsp] find references'))
	keymap.set('n', 'gs', lsp.buf.signature_help, desc('[lsp] signature help'))
	keymap.set('n', 'gW#', lsp.buf.workspace_symbol, desc('[lsp] workspace symbol'))
	keymap.set('n', 'gWa', lsp.buf.add_workspace_folder, desc('[lsp] add workspace folder'))
	keymap.set('n', 'gWr', lsp.buf.remove_workspace_folder, desc('[lsp] remove workspace folder'))
	keymap.set('n', 'gWl', function()
		notify(vim.iter(lsp.buf.list_workspace_folders()):join(', '), log.levels.INFO, {
			title = 'LSP Workspaces',
		})
	end, desc('[lsp] list workspace folders'))
	keymap.set('n', 'gR', lsp.buf.rename, desc('[lsp] rename'))
	keymap.set('n', 'g#', lsp.buf.document_symbol, desc('[lsp] document symbol'))
	keymap.set('n', 'g.', lsp.buf.code_action, desc('[lsp] code action'))
	keymap.set('n', 'gl', lsp.codelens.run, desc('[lsp] run code lens'))
	keymap.set('n', 'gL', lsp.codelens.refresh, desc('[lsp] refresh code lenses'))
	keymap.set('n', 'gF', function()
		lsp.buf.format({ async = true })
	end, desc('[lsp] format buffer'))
	keymap.set('n', 'gh', function()
		lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
	end, desc('[lsp] toggle inlay hints'))
	keymap.set('n', 'g$', function()
		lsp.buf.typehierarchy('subtypes')
	end, desc('[lsp] type hierarchy subtypes'))

	-- Auto-refresh code lenses
	refresh_codeLens(bufnr, client)

	document_highlight(bufnr, client)

	lsp.inlay_hint.enable(true, { bufnr = bufnr })
end

-- `lspconfig` does not support `ftplugin` files 😢
function M.setup()
	local lspconfig = require('lspconfig')
	local schemastore = require('schemastore')

	-- Check if lua-language-server is available
	if fn.executable('lua-language-server') == 1 then
		lspconfig.lua_ls.setup({
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
	end

	if fn.executable('vscode-eslint-language-server') == 1 then
		lspconfig.eslint.setup({
			capabilities = require('lxs.lsp').make_client_capabilities(),
			on_attach = require('lxs.lsp').attach,
		})
	end

	if fn.executable('deno') == 1 then
		lspconfig.denols.setup({
			capabilities = require('lxs.lsp').make_client_capabilities(),
			on_attach = require('lxs.lsp').attach,
			root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc'),
		})
	end

	if fn.executable('tsserver') == 1 and fn.executable('vtsls') == 1 then
		require('lspconfig.configs').vtsls = require('vtsls').lspconfig -- set default server config, optional but recommended

		-- If the lsp setup is taken over by other plugin, it is the same to call the counterpart setup function
		require('lspconfig').vtsls.setup({
			capabilities = require('lxs.lsp').make_client_capabilities(),
			on_attach = require('lxs.lsp').attach,
			settings = {
				typescript = {
					inlayHints = {
						parameterNames = { enabled = 'literals' },
						parameterTypes = { enabled = true },
						variableTypes = { enabled = true },
						propertyDeclarationTypes = { enabled = true },
						functionLikeReturnTypes = { enabled = true },
						enumMemberValues = { enabled = true },
					},
				},
			},
		})

		-- TODO: establish if this is best placed elsewhere
		lsp.commands['editor.action.showReferences'] = function(command, ctx)
			local locations = command.arguments[3]
			local client = lsp.get_client_by_id(ctx.client_id)
			if locations and #locations > 0 then
				local items = lsp.util.locations_to_items(locations, client.offset_encoding)
				fn.setloclist(0, {}, ' ', { title = 'References', items = items, context = ctx })
				api.nvim_command('lopen')
			end
		end
	end

	if fn.executable('terraform') == 1 then
		lspconfig.terraform_lsp.setup({
			capabilities = require('lxs.lsp').make_client_capabilities(),
			on_attach = require('lxs.lsp').attach,
		})
	end

	if fn.executable('yaml-language-server') == 1 then
		lspconfig.yamlls.setup({
			capabilities = require('lxs.lsp').make_client_capabilities(),
			on_attach = require('lxs.lsp').attach,
			settings = {
				yaml = {
					schemaStore = {
						-- You must disable built-in schemaStore support if you want to use
						-- this plugin and its advanced options like `ignore`.
						enable = false,
						-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
						url = '',
					},
					schemas = schemastore.yaml.schemas(),
				},
			},
		})
	end

	if fn.executable('nixd') == 1 then
		lspconfig.nixd.setup({
			capabilities = require('lxs.lsp').make_client_capabilities(),
			on_attach = require('lxs.lsp').attach,
			settings = {
				nixd = {
					nixpkgs = {
						expr = 'import <nixpkgs> { }',
					},
					formatting = {
						command = { 'nixfmt' },
					},
				},
			},
		})
	end

	if fn.executable('vscode-json-language-server') == 1 then
		lspconfig.jsonls.setup({
			capabilities = require('lxs.lsp').make_client_capabilities(),
			on_attach = require('lxs.lsp').attach,
			settings = {
				json = {
					schemas = schemastore.json.schemas(),
					validate = { enable = true },
				},
			},
		})
	end

	if fn.executable('ast-grep') == 1 then
		lspconfig.ast_grep.setup({
			capabilities = require('lxs.lsp').make_client_capabilities(),
			on_attach = require('lxs.lsp').attach,
		})
	end

	if fn.executable('biome') == 1 then
		require('lspconfig').biome.setup({
			capabilities = require('lxs.lsp').make_client_capabilities(),
			on_attach = require('lxs.lsp').attach,
		})
	end
end

return M
