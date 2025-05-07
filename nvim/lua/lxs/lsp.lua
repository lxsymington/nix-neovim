---@mod lxs.lsp
---
---@brief [[
---LSP related functions
---@brief ]]

local api = vim.api
local bo = vim.bo
local fn = vim.fn
local log = vim.log
local keymap = vim.keymap
local lsp = vim.lsp
local notify = vim.notify
local opt_local = vim.opt_local
local tbl_isempty = vim.tbl_isempty

local M = {}

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
	local params = lsp.util.make_position_params(0, 'utf-8')
	return lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end

local function peek_type_definition()
	local params = lsp.util.make_position_params(0, 'utf-8')
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

local function show_references(command, ctx)
	local locations = command.arguments[3]
	local client = lsp.get_client_by_id(ctx.client_id)
	if locations and #locations > 0 then
		local items = lsp.util.locations_to_items(locations, client.offset_encoding)
		fn.setloclist(0, {}, ' ', { title = 'References', items = items, context = ctx })
		api.nvim_command('lopen')
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
	keymap.set('n', 'gp', peek_definition, desc('[lsp] peek definition'))
	keymap.set('n', 'gP', peek_type_definition, desc('[lsp] peek type definition'))
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

	lsp.commands['editor.action.showReferences'] = show_references
end

function M.setup()
	-- Check if lua-language-server is available
	if fn.executable('lua-language-server') == 1 then
		vim.lsp.enable('lua_ls')
	end

	if fn.executable('vscode-eslint-language-server') == 1 then
		vim.lsp.enable('eslint')
	end

	if fn.executable('deno') == 1 then
		vim.lsp.enable('denols')
	end

	if fn.executable('tsserver') == 1 and fn.executable('vtsls') == 1 then
		vim.lsp.enable('vtsls')
	end

	if fn.executable('terraform') == 1 then
		vim.lsp.enable('terraform_lsp')
	end

	if fn.executable('yaml-language-server') == 1 then
		vim.lsp.enable('yamlls')
	end

	if fn.executable('nixd') == 1 then
		vim.lsp.enable('nixd')
	end

	if fn.executable('vscode-json-language-server') == 1 then
		vim.lsp.enable('jsonls')
	end

	if fn.executable('ast-grep') == 1 then
		vim.lsp.enable('ast_grep')
	end

	if fn.executable('biome') == 1 then
		vim.lsp.enable('biome')
	end

	if fn.executable('harper-ls') == 1 then
		vim.lsp.enable('harper_ls')
	end
end

return M
