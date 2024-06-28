local notify_utils = require('lxs.notification_utils')
local notify = require('notify')
local keymap = vim.keymap
local cmd = vim.cmd
local log = vim.log
local lsp = vim.lsp

notify.setup({
	top_down = false,
})

vim.notify = notify

-- Notifications –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
keymap.set('n', '<Leader>N', function()
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

	local val = result.value

	if not val.kind then
		return
	end

	local notif_data = notify_utils.get_notif_data(client_id, result.token)

	if val.kind == 'begin' then
		local message = notify_utils.format_message(val.message, val.percentage)

		notif_data.notification = vim.notify(message, log.levels.INFO, {
			title = notify_utils.format_title(val.title, lsp.get_client_by_id(client_id).name),
			icon = notify_utils.spinner_frames[1],
			timeout = false,
			hide_from_history = false,
		})

		notif_data.spinner = 1
		notify_utils.update_spinner(client_id, result.token)
	elseif val.kind == 'report' and notif_data then
		notif_data.notification =
			vim.notify(notify_utils.format_message(val.message, val.percentage), log.levels.INFO, {
				replace = notif_data.notification,
				hide_from_history = false,
			})
	elseif val.kind == 'end' and notif_data then
		notif_data.notification = vim.notify(
			val.message and notify_utils.format_message(val.message) or 'Complete',
			log.levels.INFO,
			{
				icon = '',
				replace = notif_data.notification,
				timeout = 3000,
			}
		)

		notif_data.spinner = nil
	end
end

lsp.handlers['textDocument/hover'] = lsp.with(lsp.handlers.hover, {
	border = 'rounded',
})

lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, {
	border = 'rounded',
})
