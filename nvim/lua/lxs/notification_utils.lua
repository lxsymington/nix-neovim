---@mod lxs.notification_utils
---
---@brief [[
---Notification utilities
---@brief ]]

local M = {}

---A holder for notification data, `get_notif_data` has a closure over this
M.client_notifs = {}

---Gets notification data, this mostly seems useful for LSP notifications atm
function M.get_notif_data(client_id, token)
	if not M.client_notifs[client_id] then
		M.client_notifs[client_id] = {}
	end

	if not M.client_notifs[client_id][token] then
		M.client_notifs[client_id][token] = {}
	end

	return M.client_notifs[client_id][token]
end

---The frames to use in a notification's loading spinner
M.spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }

---A function to apply the spinner animations to a notification
function M.update_spinner(client_id, token)
	local notif_data = M.get_notif_data(client_id, token)

	if notif_data.spinner then
		local new_spinner = (notif_data.spinner + 1) % #M.spinner_frames
		notif_data.spinner = new_spinner

		notif_data.notification = vim.notify(nil, nil, {
			hide_from_history = true,
			icon = M.spinner_frames[new_spinner],
			replace = notif_data.notification,
		})

		vim.defer_fn(function()
			M.update_spinner(client_id, token)
		end, 100)
	end
end

function M.notify_output(command, opts)
	local output = ''
	local notification

	local notify = function(msg, level)
		local notify_opts = vim.tbl_extend(
			'keep',
			opts or {},
			{ title = table.concat(command, ' '), replace = notification }
		)
		notification = vim.notify(msg, level, notify_opts)
	end

	local on_data = function(_, data)
		output = output .. table.concat(data, '\n')
		notify(output, 'info')
	end

	vim.fn.jobstart(command, {
		on_stdout = on_data,
		on_stderr = on_data,
		on_exit = function(_, code)
			if #output == 0 then
				notify('No output of command, exit code: ' .. code, 'warn')
			end
		end,
	})
end

function M.format_title(title, client_name)
	return client_name .. (#title > 0 and ': ' .. title or '')
end

function M.format_message(message, percentage)
	return (percentage and percentage .. '%\t' or '') .. (message or '')
end

return M
