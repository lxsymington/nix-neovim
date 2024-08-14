local notify_utils = require('lxs.notification_utils')
local notify = require('notify')
local keymap = vim.keymap
local cmd = vim.cmd
local log = vim.log
local lsp = vim.lsp

notify.setup({
	top_down = false,
	stages = 'fade',
})

vim.notify = notify

-- Notifications –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
keymap.set('n', '<Leader>N/', function()
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

lsp.handlers['$/progress'] = function(_, result, ctx)
	local client_id = ctx.client_id
	local client = lsp.get_client_by_id(client_id)
	local notification_title = { client and client.name, 'LSP ⁃ Progress' }

	local val = result.value or {}

	if not val.kind then
		return
	end

	-- TODO: Use a single notification per client
	local percentage_default = val.kind == 'end' and 100 or 0
	local notif_data = notify_utils.get_notif_data(client_id, result.token)
	local formatted_message =
		notify_utils.format_message(val.message, val.percentage or percentage_default)

	vim.print(formatted_message)

	if val.kind == 'begin' then
		notif_data.spinner = 1
		notif_data.notification = vim.notify(formatted_message, log.levels.INFO, {
			hide_from_history = false,
			icon = notify_utils.spinner_frames[notif_data.spinner],
			timeout = false,
			title = notification_title,
		})

		notify_utils.update_spinner(client_id, result.token)

		return
	end

	if val.kind == 'report' and notif_data then
		notif_data.notification = vim.notify(formatted_message, nil, {
			-- `:h notify.Options` all options not supplied here are inherited from the replaced notification
			replace = notif_data.notification,
		})
		return
	end

	if val.kind == 'end' and notif_data then
		notif_data.notification = vim.notify(formatted_message or 'Complete', nil, {
			icon = '',
			replace = notif_data.notification,
			timeout = 3000,
		})

		notif_data.spinner = nil
	end
end

lsp.handlers['textDocument/hover'] = lsp.with(lsp.handlers.hover, {
	border = 'rounded',
})

lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, {
	border = 'rounded',
})
