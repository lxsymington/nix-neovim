local notify_utils = require('lxs.notification_utils')
local notify = require('notify')
local keymap = vim.keymap
local cmd = vim.cmd
local lsp = vim.lsp
local LSP_Progress = notify_utils.LSP_Progress

notify.setup({
	max_height = function()
		return vim.api.nvim_win_get_height(0)
	end,
	stages = 'fade',
})

vim.notify = notify

-- Notifications –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
keymap.set('n', '<Leader>/n', function()
	local telescope_available, telescope = pcall(require, 'telescope')

	if telescope_available then
		local opts = require('telescope.themes').get_dropdown({
			border = true,
		})

		telescope.extensions.notify.notify(opts)
	else
		cmd.Notifications()
	end
end, { desc = 'Notifications', silent = true })

keymap.set('n', '<Leader>Nx', notify.dismiss, { desc = 'Notifications', silent = true })

-- LSP Handlers ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
lsp.handlers['window/showMessage'] = function(_, result, ctx)
	local client = lsp.get_client_by_id(ctx.client_id)
	local lvl = ({
		'ERROR',
		'WARN',
		'INFO',
		'DEBUG',
	})[result.type]

	if client == nil then
		return
	end

	vim.notify_once(result.message, lvl, {
		title = 'LSP | ' .. client.name,
		timeout = 10000,
		keep = function()
			return lvl == 'ERROR' or lvl == 'WARN'
		end,
	})
end

--[[ local progress_handler = LSP_Progress:new()
lsp.handlers['$/progress'] = function(_, result, context)
	-- TODO: consume the currently ignored error
	progress_handler:handle_progress_message(_, result, context)
end ]]

lsp.handlers['textDocument/hover'] = lsp.with(lsp.handlers.hover, {
	border = 'rounded',
})

lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, {
	border = 'rounded',
})
