---@mod lxs.dap
---
---@brief [[
---DAP related functions
---@brief ]]

local notify_utils = require('lxs.notification_utils')
local dap_ok, dap = pcall(require, 'dap')
local dap_view_ok, dap_view = pcall(require, 'dap-view')
local dap_virtual_text_ok, dap_virtual_text = pcall(require, 'dap.virtual_text')
local api = vim.api
local fn = vim.fn
local keymap = vim.keymap
local notify = vim.notify
local log_level = vim.log.levels

local M = {}

-- DAP Configuration ――――――――――――――――――――――――――――――――――――――――――――――――――――
function M.start()
	if not dap_ok then
		return
	end

	-- Defaults ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
	dap.defaults.stepping_granularity = 'statement'
	dap.defaults.terminal_win_cmd = '80vsplit new'
	dap.defaults.switchbuf = 'usevisible,usetab,uselast'
	dap.defaults.fallback.external_terminal = {
		command = '/usr/bin/alacritty',
		args = { '-e' },
	}

	-- Adapters ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
	local js_adapter = {
		type = 'server',
		host = 'localhost',
		port = '${port}',
		executable = {
			command = 'js-debug',
			args = { '${port}' },
		},
	}

	dap.adapters['pwa-node'] = js_adapter
	dap.adapters.javascript = js_adapter
	dap.adapters.node = js_adapter

	-- Configurations ―――――――――――――――――――――――――――――――――――――――――――――――――――――
	local outFiles = {
		'${workspaceFolder}/**/*.[mc]?[jt]s',
		'!**/node_modules/**',
		'**/node_modules/@seccl/**/*.[mc]?[jt]s',
		'!**/node_modules/@seccl/**/node_modules/**',
	}
	local resolveSourceMapLocations = {
		'**',
		'!**/node_modules/**',
		'**/node_modules/@seccl/**',
		'!**/node_modules/@seccl/**/node_modules/**',
	}
	local skipFiles = {
		'<node_internals>/**',
		'${workspaceFolder}/node_modules/**',
		'!${workspaceFolder}/node_modules/@seccl/**',
	}

	local js_configuration = {
		{
			type = 'pwa-node',
			request = 'launch',
			name = 'Launch file',
			program = '${file}',
			cwd = '${workspaceFolder}',
			outFiles = outFiles,
			resolveSourceMapLocations = resolveSourceMapLocations,
			skipFiles = skipFiles,
		},
		{
			type = 'pwa-node',
			request = 'attach',
			name = 'Attach to process',
			processId = require('dap.utils').pick_process,
			cwd = '${workspaceFolder}',
			outFiles = outFiles,
			resolveSourceMapLocations = resolveSourceMapLocations,
			skipFiles = skipFiles,
		},
	}

	dap.configurations['pwa-node'] = js_configuration
	dap.configurations.javascript = js_configuration
	dap.configurations.typescript = js_configuration
	dap.configurations.npm = {
		type = 'node-terminal',
		request = 'launch',
		name = 'Launch npm script',
		command = function()
			return coroutine.create(function(dap_run_coroutine)
				local npm_project_directory = vim.fs.root(0, 'package.json')

				if not npm_project_directory then
					notify('package.json not found', log_level.ERROR)
					coroutine.resume(dap_run_coroutine, dap.ABORT)
					return
				end

				local package_json_content =
					fn.readfile(vim.fs.joinpath(npm_project_directory, 'package.json'))
				local package_data = vim.json.decode(table.concat(package_json_content, '\n'))

				if not package_data.scripts then
					notify('No scripts found in package.json', log_level.ERROR)
					coroutine.resume(dap_run_coroutine, dap.ABORT)
					return
				end

				local scripts = vim.tbl_keys(package_data.scripts)

				vim.ui.select(
					scripts,
					{ prompt = 'Select an npm script to debug:' },
					function(selected_script)
						if not selected_script then
							notify('No script selected', log_level.WARN)
							coroutine.resume(dap_run_coroutine, dap.ABORT)
							return
						end

						coroutine.resume(dap_run_coroutine, string.format('npm run-script %s', selected_script))
					end
				)
			end)
		end,
		smartStep = true,
		sourceMap = true,
		cwd = '${workspaceFolder}',
		outFiles = outFiles,
		resolveSourceMapLocations = resolveSourceMapLocations,
		skipFiles = skipFiles,
	}

	-- Events ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
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

	vim.fn.sign_define('DapBreakpoint', {
		text = '⭓',
		culhl = 'DapBreakpointLine',
		linehl = 'DapBreakpointLine',
		numhl = 'DapBreakpointNumber',
		texthl = 'DapBreakpoint',
	})
	vim.fn.sign_define('DapBreakpointCondition', {
		text = '⬔',
		culhl = 'DapBreakpointConditionLine',
		linehl = 'DapBreakpointConditionLine',
		numhl = 'DapBreakpointConditionNumber',
		texthl = 'DapBreakpointCondition',
	})
	vim.fn.sign_define('DapLogPoint', {
		text = '⭔',
		culhl = 'DapLogPointLine',
		linehl = 'DapLogPointLine',
		numhl = 'DapLogPointNumber',
		texthl = 'DapLogPoint',
	})
	vim.fn.sign_define('DapStopped', {
		text = '⮕',
		culhl = 'DapStoppedLine',
		linehl = 'DapStoppedLine',
		numhl = 'DapStoppedNumber',
		texthl = 'DapStopped',
	})
	vim.fn.sign_define('DapBreakpointRejected', {
		text = '⭕',
		culhl = 'DapBreakpointRejectedLine',
		linehl = 'DapBreakpointRejectedLine',
		numhl = 'DapBreakpointRejectedNumber',
		texthl = 'DapBreakpointRejected',
	})

	-- View ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
	if dap_view_ok then
		dap_view.setup({
			winbar = {
				show = true,
				default_section = 'scopes',
				controls = {
					enabled = true,
				},
			},
			windows = {
				height = 15,
				terminal = {
					-- 'left'|'right'|'above'|'below': Terminal position in layout
					position = 'left',
					-- Hide the terminal when starting a new session
					start_hidden = false,
				},
			},
			-- Controls how to jump when selecting a breakpoint or navigating the stack
			switchbuf = 'usetab,usevisible',
			follow_tab = true,
		})

		dap.listeners.before.attach['dap-view-config'] = function()
			dap_view.open()
		end
		dap.listeners.before.launch['dap-view-config'] = function()
			dap_view.open()
		end
		dap.listeners.before.event_terminated['dap-view-config'] = function()
			dap_view.close()
		end
		dap.listeners.before.event_exited['dap-view-config'] = function()
			dap_view.close()
		end

		keymap.set('n', '<Leader>dv', function()
			require('dap-view').toggle()
		end, {
			silent = true,
			desc = 'DAP » toggle view',
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
	keymap.set('n', '<Leader>d=', function()
		dap.set_breakpoint(nil, nil, fn.input('Log point message: '))
	end, {
		desc = 'DAP » Toggle Log Point',
		silent = true,
	})
	keymap.set('n', '<Leader>d?', function()
		dap.set_breakpoint(fn.input('Breakpoint condition: '))
	end, {
		desc = 'DAP » Toggle Conditional Breakpoint',
		silent = true,
	})
	keymap.set('n', '<Leader>db', function()
		dap.toggle_breakpoint()
	end, {
		desc = 'DAP » Toggle Breakpoint',
		silent = true,
	})
	keymap.set('n', '<Leader>dc', function()
		dap.continue()
	end, {
		desc = 'DAP » Launch/Continue',
		silent = true,
	})
	keymap.set('n', '<Leader>di', function()
		dap.step_into()
	end, {
		desc = 'DAP » Step Into',
		silent = true,
	})
	keymap.set('n', '<Leader>dl', function()
		dap.run_last()
	end, {
		desc = 'DAP » Re-run Last Session',
		silent = true,
	})
	keymap.set('n', '<Leader>do', function()
		dap.step_out()
	end, {
		desc = 'DAP » Step Out',
		silent = true,
	})
	keymap.set('n', '<Leader>dR', function()
		dap.restart()
	end, {
		desc = 'DAP » Restart',
		silent = true,
	})
	keymap.set('n', '<Leader>d!', function()
		dap.terminate()
	end, {
		desc = 'DAP » Terminate',
		silent = true,
	})
	keymap.set('n', '<Leader>dr', function()
		dap.repl.open()
	end, {
		desc = 'DAP » Open REPL',
		silent = true,
	})
	keymap.set('n', '<Leader>dp', function()
		dap.preview()
	end, {
		desc = 'DAP » Preview',
		silent = true,
	})
	keymap.set('n', '<Leader>ds', function()
		dap.step_over({})
	end, {
		desc = 'DAP » Step Over',
		silent = true,
	})
	keymap.set('n', '<Leader>djb', function()
		dap_view.jump_to_view('breakpoints')
	end, {
		desc = 'DAP » Jump » Breakpoints',
		silent = true,
	})
	keymap.set('n', '<Leader>djc', function()
		dap_view.jump_to_view('console')
	end, {
		desc = 'DAP » Jump » Console',
		silent = true,
	})
	keymap.set('n', '<Leader>dje', function()
		dap_view.jump_to_view('exceptions')
	end, {
		desc = 'DAP » Jump » Exceptions',
		silent = true,
	})
	keymap.set('n', '<Leader>djr', function()
		dap_view.jump_to_view('repl')
	end, {
		desc = 'DAP » Jump » Repl',
		silent = true,
	})
	keymap.set('n', '<Leader>djs', function()
		dap_view.jump_to_view('scopes')
	end, {
		desc = 'DAP » Jump » Scopes',
		silent = true,
	})
	keymap.set('n', '<Leader>djt', function()
		dap_view.jump_to_view('threads')
	end, {
		desc = 'DAP » Jump » Threads',
		silent = true,
	})
	keymap.set('n', '<Leader>djw', function()
		dap_view.jump_to_view('watches')
	end, {
		desc = 'DAP » Jump » Watches',
		silent = true,
	})
	keymap.set('n', '<Leader>dt', function()
		dap.run(dap.configurations.npm, { new = true })
	end, {
		desc = 'DAP » Tasks',
		silent = true,
	})
end

return M
