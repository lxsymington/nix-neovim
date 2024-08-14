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
M.spinner_frames = {
	'▮▯▯▯▯▯▯',
	'▯▮▯▯▯▯▯',
	'▯▮▮▯▯▯▯',
	'▯▯▮▮▮▯▯',
	'▯▯▯▯▮▮▯',
	'▯▯▯▯▯▮▯',
	'▯▯▯▯▯▯▮',
}

M.progress_icons = setmetatable({
	complete = '▬',
	incomplete = '▭',
}, {
	__index = function(self, key)
		if type(key) == 'number' then
			local total_increments = 20
			local increment = math.floor(key / (100 / total_increments))
			return self.complete:rep(increment) .. self.incomplete:rep(total_increments - increment)
		end

		return rawget(self, key)
	end,
})

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

function M.format_message(message, percentage)
	return vim.tbl_filter(function(v)
		return not not v
	end, {
		message,
		string.format('%d%% %s', percentage, M.progress_icons[percentage]),
	})
end

return M
