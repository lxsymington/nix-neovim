---@mod lxs.lsp
---
---@brief [[
---LSP related functions
---@brief ]]

local api = vim.api
local keymap = vim.keymap
local lsp = vim.lsp
local M = {}

---Gets a 'ClientCapabilities' object, describing the LSP client capabilities
---Extends the object with capabilities provided by plugins.
---@return lsp.ClientCapabilities
function M.make_client_capabilities()
	local capabilities = lsp.protocol.make_client_capabilities()
	-- Add com_nvim_lsp capabilities
	local cmp_lsp = require('cmp_nvim_lsp')
	local cmp_lsp_capabilities = cmp_lsp.default_capabilities()
	capabilities = vim.tbl_deep_extend('force', capabilities, cmp_lsp_capabilities)
	-- Add any additional plugin capabilities here.
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
	vim.print(result)
	if result == nil or vim.tbl_isempty(result) then
		return nil
	end
	local buf, _ = lsp.util.preview_location(result[1])
	if buf then
		local cur_buf = vim.api.nvim_get_current_buf()
		vim.bo[buf].filetype = vim.bo[cur_buf].filetype
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

	local function buf_refresh_codeLens()
		vim.schedule(function()
			if client.server_capabilities.codeLensProvider then
				lsp.codelens.refresh()
				return
			end
		end)
	end

	local group = api.nvim_create_augroup(string.format('lsp-%s-%s', bufnr, client.id), {})
	if client.server_capabilities.codeLensProvider then
		api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost', 'TextChanged' }, {
			group = group,
			callback = buf_refresh_codeLens,
			buffer = bufnr,
		})
		buf_refresh_codeLens()
	end
end

function M.attach(ev)
	local bufnr = ev.buf
	local client = lsp.get_client_by_id(ev.data.client_id)

	vim.cmd.setlocal('signcolumn=yes')
	vim.bo[bufnr].bufhidden = 'hide'

	-- Enable completion triggered by <c-x><c-o>
	vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

	local function desc(description)
		return { noremap = true, silent = true, buffer = bufnr, desc = description }
	end
	keymap.set('n', 'gD', lsp.buf.declaration, desc('[lsp] go to declaration'))
	keymap.set('n', 'gd', lsp.buf.definition, desc('[lsp] go to definition'))
	keymap.set('n', 'g$', lsp.buf.type_definition, desc('[lsp] go to type definition'))
	keymap.set('n', 'K', lsp.buf.hover, desc('[lsp] hover'))
	keymap.set('n', "g'", peek_definition, desc('[lsp] peek definition'))
	keymap.set('n', 'g"', peek_type_definition, desc('[lsp] peek type definition'))
	keymap.set('n', 'gI', lsp.buf.implementation, desc('[lsp] go to implementation'))
	keymap.set('n', 'g%', lsp.buf.references, desc('[lsp] find references'))
	keymap.set('n', 'gs', lsp.buf.signature_help, desc('[lsp] signature help'))
	keymap.set('n', 'gW#', lsp.buf.workspace_symbol, desc('[lsp] workspace symbol'))
	keymap.set('n', 'gWa', lsp.buf.add_workspace_folder, desc('[lsp] add workspace folder'))
	keymap.set('n', 'gWr', lsp.buf.remove_workspace_folder, desc('[lsp] remove workspace folder'))
	keymap.set('n', 'gWl', function()
		vim.print(lsp.buf.list_workspace_folders())
	end, desc('[lsp] list workspace folders'))
	keymap.set('n', 'gR', lsp.buf.rename, desc('[lsp] rename'))
	keymap.set('n', 'g#', lsp.buf.document_symbol, desc('[lsp] document symbol'))
	keymap.set('n', 'ga', lsp.buf.code_action, desc('[lsp] code action'))
	keymap.set('n', 'gl', lsp.codelens.run, desc('[lsp] run code lens'))
	keymap.set('n', 'gL', lsp.codelens.refresh, desc('[lsp] refresh code lenses'))
	keymap.set('n', 'gF', function()
		lsp.buf.format({ async = true })
	end, desc('[lsp] format buffer'))
	keymap.set('n', 'gh', function()
		lsp.inlay_hint(bufnr)
	end, desc('[lsp] toggle inlay hints'))

	-- Auto-refresh code lenses
	refresh_codeLens(bufnr, client)

	document_highlight(bufnr, client)
end

return M
