---@mod lxs.notification_utils
---
---@brief [[
---Notification utilities
---@brief ]]

local log = vim.log
local lsp = vim.lsp

---@alias Progress_Result_Value { kind: 'begin' | 'report' | 'end', message?: string, title?: string, percentage?: integer, cancellable?: boolean }
---@alias Progress_Result { token?: integer, value?: Progress_Result_Value }

---@alias Notification_Store_Symbol table

---@class Notification_Static
---@field protected __store_symbol Notification_Store_Symbol a unique key for the notification's store
---@field protected frames table<string> the frames to use in the spinner
---@field protected progress_bar table<number, string> a table of progress bar characters
local notification_static = {
	__store_symbol = {},
	frames = {
		'▮▯▯▯▯▯▯',
		'▯▮▯▯▯▯▯',
		'▯▮▮▯▯▯▯',
		'▯▯▮▮▮▯▯',
		'▯▯▯▯▮▮▯',
		'▯▯▯▯▯▮▯',
		'▯▯▯▯▯▯▮',
	},
	progress_bar = setmetatable({
		size = 20,
		complete = '▬',
		incomplete = '▭',
	}, {
		__index = function(self, key)
			if type(key) == 'number' then
				local increment = math.floor(key / (100 / self.size))
				return self.complete:rep(increment) .. self.incomplete:rep(self.size - increment)
			end

			return rawget(self, key)
		end,
	}),
}

---@class Token_Entry
---@field token string the token of the progress message
---@field title string the title of the progress message
---@field context string the context of the progress message
---@field percentage integer the percentage of the progress message
---@field progress string the progress of the progress message
---@field protected __phase string the phase of the progress message

---@class LSP_Progress_Notification: Notification_Static an enhanced notification object
---@field private [Notification_Store_Symbol] table<integer, Token_Entry> a store for the notification's tokens
---@field private mt table the metatable for the Notification object
---@field protected frame integer the current frame of the spinner
---@field protected notification_id? integer the id of the associated notification
---@field protected process_update fun(self: LSP_Progress_Notification, result: Progress_Result) a function that processes an LSP progress result and updates the notification
---@field protected store table<integer, Token_Entry> a store for the notification's tokens
---@field protected token_complete fun(self: LSP_Progress_Notification, result: Progress_Result): Token_Entry completes the token life cycle
---@field protected token_initialise fun(self: LSP_Progress_Notification, result: Progress_Result): Token_Entry creates an entry for a token within a client notification
---@field protected token_messages fun(self: LSP_Progress_Notification): table<string> a function to formate the progress message
---@field protected token_update fun(self: LSP_Progress_Notification, result: Progress_Result): Token_Entry updates an entry for a token within a client notification
---@field token_cleanup fun(self: LSP_Progress_Notification, token: integer) cleans up the token from the notification
---@field update_spinner fun(self: LSP_Progress_Notification) a function to update the spinner
---@field settled? boolean a flag to indicate if the notification is settled
local LSP_Progress_Notification = {}

--- Metatable for the Notification object
LSP_Progress_Notification.mt = {
	__index = function(self, key)
		if key == nil or key:match('^__') then
			return nil
		end

		if key == 'store' then
			return rawget(self, notification_static.__store_symbol)
		end

		local self_has_key = vim.tbl_contains(vim.tbl_keys(self), key)
		local static_property_available = not self_has_key
			and vim.tbl_contains(vim.tbl_keys(notification_static), key)
		if static_property_available then
			return notification_static[key]
		end

		return rawget(self, key)
	end,
}

-- TODO: these may not come in order e.g. 'begin', 'report', 'end'
function LSP_Progress_Notification.token_initialise(self, result)
	local store = self.store
	local entry = store[result.token] or {}
	local message = result.value.message or ''
	local resolved_message = vim.tbl_deep_extend('force', entry, {
		token = result.token,
		title = result.value.title,
		context = (not message:match('%d+/%d+')) and message or nil,
		progress = message:match('%d+/%d+'),
		percentage = result.value.percentage,
		__phase = result.value.kind,
	})

	self.store[result.token] = resolved_message

	return resolved_message
end

function LSP_Progress_Notification.token_update(self, result)
	local store = self.store
	local entry = store[result.token] or {}
	local message = result.value.message or ''
	local resolved_message = vim.tbl_deep_extend('force', entry, {
		title = result.value.title,
		context = (not message:match('%d+/%d+')) and result.value.message or nil,
		progress = message:match('%d+/%d+'),
		percentage = result.value.percentage,
		__phase = result.value.kind,
	})

	self.store[result.token] = resolved_message

	return resolved_message
end

function LSP_Progress_Notification.token_complete(self, result)
	local store = self.store
	local entry = store[result.token] or {}
	local resolved_message = vim.tbl_deep_extend('force', entry, {
		title = result.value.title,
		progress = result.value.message or 'Complete',
		percentage = result.value.percentage,
		__phase = result.value.kind,
	})

	self.store[result.token] = resolved_message

	local active_tokens = vim.tbl_keys(self.store)
	local is_last_token = vim.tbl_count(active_tokens) == 1
		and vim.tbl_contains(active_tokens, result.token)

	if is_last_token or vim.tbl_isempty(active_tokens) then
		self.settled = true
	end

	vim.defer_fn(function()
		self:token_cleanup(result.token)
	end, 3000)

	return resolved_message
end

function LSP_Progress_Notification.token_cleanup(self, token)
	if vim.tbl_contains(vim.tbl_keys(self.store), token) then
		self.store[token] = nil
	end

	if vim.tbl_isempty(self.store) then
		self.notification_id = nil
	end
end

function LSP_Progress_Notification.token_messages(self)
	local token_entries = self.store
	local progress_bar = self.progress_bar

	if vim.tbl_isempty(token_entries) then
		return {}
	end

	local message = vim
		.iter(token_entries)
		:fold(setmetatable({}, { __index = table }), function(acc, token_entry)
			local title = token_entry.title or ''
			local context = token_entry.context
			local progress = token_entry.progress or '0/0'
			local title_spacer = string.rep(' ', 50 - #title - #(context or progress))
			local percentage = token_entry.percentage or 0
			local percentage_string = string.format('%d%%', percentage)
			local progress_display = progress_bar[token_entry.percentage]
			local space_repeat = 50 - progress_bar.size - #percentage_string
			local progress_spacer = string.rep(' ', space_repeat)
			local message_header = string.format('%s%s%s', title, title_spacer, context or progress)
			local message_body =
				string.format('%s%s%s', progress_display, progress_spacer, percentage_string)
			acc:insert(message_header)
			acc:insert(message_body)

			return acc
		end)

	return message
end

function LSP_Progress_Notification.update_spinner(self)
	if self.frame and self.notification_id ~= nil then
		local existing_notification = self.notification_id
		self.frame = (self.frame % #self.frames) + 1
		local message = self:token_messages()

		local notification = vim.notify(message, nil, {
			icon = self.settled and '' or self.frames[self.frame],
			replace = existing_notification,
			timeout = self.settled and 3000 or false,
		})

		self.notification_id = notification and notification.id

		vim.defer_fn(function()
			self:update_spinner()
		end, math.floor(1000 / 30))
	end
end

-- TODO: queue updates to target a fixed frame rate

function LSP_Progress_Notification.process_update(self, update)
	if update.value.kind == 'begin' then
		self:token_initialise(update)
		return
	end

	if update.value.kind == 'report' then
		self:token_update(update)
		return
	end

	if update.value.kind == 'end' then
		self:token_complete(update)
		return
	end
end

---@class LSP_Progress_Notification_Params
---@field client_id? integer the reference to the LSP client for the notification

--- The Notification constructor
---@param opts LSP_Progress_Notification_Params the options for the notification
---@return LSP_Progress_Notification notification a new Notification object
function LSP_Progress_Notification.new(self, opts)
	local client = lsp.get_client_by_id(opts.client_id)
	local notification_title = { client and client.name, 'LSP ⁃ Progress' }
	local notification = vim.notify({ '', '', '', '', '', '' }, log.levels.INFO, {
		hide_from_history = false,
		timeout = false,
		title = notification_title,
	})

	local new = setmetatable(
		vim.tbl_deep_extend('error', {}, self, {
			client_id = opts.client_id,
			frame = 1,
			notification_id = notification and notification.id,
			[notification_static.__store_symbol] = {},
		}),
		self.mt
	)

	new:update_spinner()

	return new
end

---@class Progress_Static
---@field protected __store_symbol table a unique key for the notification's store
---@field cache? LSP_Progress a singleton instance
local progress_static = {
	__store_symbol = {},
	cache = nil,
}

---@class LSP_Progress: Progress_Static a class to manage progress notifications
---@field instances table<string, LSP_Progress_Notification> a table of the progress notifications associated with a client
---@field handle_progress_message fun(self: LSP_Progress, _, result: Progress_Result, ctx: lsp.HandlerContext): nil a handler for LSP progress messages
local LSP_Progress = {}

LSP_Progress.mt = {
	__index = function(self, key)
		if key:match('^__') then
			return nil
		end

		local self_has_key = vim.tbl_contains(vim.tbl_keys(self), key)
		local static_property_available = not self_has_key
			and vim.tbl_contains(vim.tbl_keys(progress_static), key)
		if static_property_available then
			return progress_static[key]
		end

		return rawget(self, key)
	end,
}

---A handler for LS progress messages
---@param self LSP_Progress the Progress handler
---@param _ lsp.ResponseError the error response
---@param result Progress_Result the result of the progress message
---@param ctx lsp.HandlerContext the context of the progress message
function LSP_Progress.handle_progress_message(self, _, result, ctx)
	local client_id = ctx.client_id
	local val = result.value or {}

	if not val.kind then
		return
	end

	local instance = self.instances[client_id]

	instance:process_update(result)
end

function LSP_Progress.new(self)
	if progress_static.cache ~= nil then
		return progress_static.cache
	end

	local new = setmetatable(
		vim.tbl_deep_extend('error', {}, self, {
			instances = setmetatable({
				[progress_static.__store_symbol] = {},
			}, {
				__index = function(s, key)
					if not vim.tbl_contains(vim.tbl_keys(rawget(s, progress_static.__store_symbol)), key) then
						local new_notification = LSP_Progress_Notification:new({ client_id = key })
						s[progress_static.__store_symbol][key] = new_notification
						return new_notification
					end

					return rawget(rawget(s, progress_static.__store_symbol), key)
				end,
			}),
		}),
		self.mt
	)

	progress_static.cache = new
	return new
end

return {
	LSP_Progress = LSP_Progress,
}
