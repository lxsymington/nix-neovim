---@mod lxs.dap
---
---@brief [[
---DAP related functions
---@brief ]]

local notify_utils = require('lxs.notification_utils')
local dap_ok, dap = pcall(require, 'dap')
local dapui_ok, dapui = pcall(require, 'dapui')
local dap_virtual_text_ok, dap_virtual_text = pcall(require, 'dap.virtual_text')
local api = vim.api
local fn = vim.fn
local keymap = vim.keymap
local notify = vim.notify
local log_level = vim.log.levels

local M = {}

-- DAP Configuration ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
function M.start()
	if not dap_ok then
		return
	end

	-- Adapters ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
	dap.adapters.javascript = {
		type = 'server',
		host = 'localhost',
		port = '${port}',
		executable = {
			command = 'js-debug',
			args = { '${port}' },
		},
	}

	-- Display ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
	dap.defaults.fallback.terminal_win_cmd = '80vsplit new'
	dap.defaults.fallback.external_terminal = {
		command = 'tmux',
		args = {
			'split-window',
			'-h',
			'-l',
			'80',
		},
	}

	-- Events ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
	dap.listeners.before['event_progressStart']['progress-notifications'] = function(session, body)
		local notif_data = notify_utils.get_notif_data('dap', body.progressId)

		local message = notify_utils.format_message(body.message, body.percentage)
		notif_data.notification = notify(message, log_level.INFO, {
			title = notify_utils.format_title(body.title, session.config.type),
			icon = notify_utils.spinner_frames[1],
			timeout = false,
			hide_from_history = false,
		})

		notif_data.notification.spinner = { 1, notify_utils.update_spinner('dap', body.progressId) }
	end

	dap.listeners.before['event_progressUpdate']['progress-notifications'] = function(_, body)
		local notif_data = notify_utils.get_notif_data('dap', body.progressId)
		notif_data.notification =
			notify(notify_utils.format_message(body.message, body.percentage), log_level.INFO, {
				replace = notif_data.notification,
				hide_from_history = false,
			})
	end

	dap.listeners.before['event_progressEnd']['progress-notifications'] = function(_, body)
		local notif_data = notify_utils.client_notifs['dap'][body.progressId]
		notif_data.notification = notify(
			body.message and notify_utils.format_message(body.message) or 'Complete',
			log_level.INFO,
			{
				icon = '',
				replace = notif_data.notification,
				timeout = 3000,
			}
		)
		notif_data.spinner = nil
	end

	dap.listeners.after['event_initialized']['me'] = function()
		for _, buf in pairs(api.nvim_list_bufs()) do
			local keymaps = api.nvim_buf_get_keymap(buf, 'n')
			for _, kmap in pairs(keymaps) do
				if kmap.lhs == 'K' then
					table.insert(keymap_restore, kmap)
					keymap.del('n', 'K', { buffer = buf })
				end
			end
		end

		keymap.set('n', 'K', require('dap.ui.widgets').hover, {
			silent = true,
			desc = 'DAP » Hover',
		})
	end

	dap.listeners.after['event_terminated']['me'] = function()
		for _, kmap in pairs(keymap_restore) do
			keymap.set(kmap.mode, kmap.lhs, kmap.rhs, {
				buffer = kmap.buffer,
				silent = kmap.silent == 1,
			})
		end
		keymap_restore = {}
	end

	-- UI ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
	if dapui_ok then
		dapui.setup({
			layouts = {
				{
					elements = {
						{ id = 'scopes', size = 0.5 },
						{ id = 'watches', size = 0.125 },
						{ id = 'stacks', size = 0.25 },
						{ id = 'breakpoints', size = 0.125 },
					},
					size = 80,
					position = 'left',
				},
				{
					elements = {
						'repl',
						'console',
					},
					size = 10,
					position = 'bottom',
				},
			},
		})

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		keymap.set('n', '<Leader>D', function()
			require('dapui').toggle({})
		end, {
			silent = true,
			desc = 'DAP » toggle UI',
		})
	end

	-- Allow `nvim-dap` to attempt to load settings from VSCode's launch.json
	api.nvim_create_user_command('DebugLoadLaunchJS', function()
		require('dap.ext.vscode').load_launchjs()
	end, {
		desc = 'DAP » Load Launch JS',
	})

	-- Virtual text ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
	if dap_virtual_text_ok then
		dap_virtual_text.setup()
	end
end

function M.keymaps()
	keymap.set('n', '<Leader>D=', function()
		require('dap').set_breakpoint(nil, nil, fn.input('Log point message: '))
	end, {
		desc = 'DAP » Toggle Log Point',
		silent = true,
	})
	keymap.set('n', '<Leader>D?', function()
		require('dap').set_breakpoint(fn.input('Breakpoint condition: '))
	end, {
		desc = 'DAP » Toggle Conditional Breakpoint',
		silent = true,
	})
	keymap.set('n', '<Leader>Db', function()
		require('dap').toggle_breakpoint()
	end, {
		desc = 'DAP » Toggle Breakpoint',
		silent = true,
	})
	keymap.set('n', '<Leader>Dc', function()
		require('dap').continue()
	end, {
		desc = 'DAP » Launch/Continue',
		silent = true,
	})
	keymap.set('n', '<Leader>Di', function()
		require('dap').step_into()
	end, {
		desc = 'DAP » Step Into',
		silent = true,
	})
	keymap.set('n', '<Leader>Dl', function()
		require('dap').run_last()
	end, {
		desc = 'DAP » Re-run Last Session',
		silent = true,
	})
	keymap.set('n', '<Leader>Do', function()
		require('dap').step_out()
	end, {
		desc = 'DAP » Step Out',
		silent = true,
	})
	keymap.set('n', '<Leader>Dr', function()
		require('dap').repl.open()
	end, {
		desc = 'DAP » Open REPL',
		silent = true,
	})
	keymap.set('n', '<Leader>Ds', function()
		require('dap').step_over({})
	end, {
		desc = 'DAP » Step Over',
		silent = true,
	})
end

return M
