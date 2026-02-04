---@mod lxs.tasks
---
---@brief [[
---Task related functions
---@brief ]]
local cmd = vim.cmd
local Tasks = {}

Tasks.instance = setmetatable({}, {
	__index = function(self, key)
		local cached_instance = rawget(self, key)
		if cached_instance ~= nil then
			return cached_instance
		end

		if key == 'overseer' then
			cmd.packadd({
				args = { 'overseer.nvim' },
				bang = true,
			})

			local overseer = require('overseer')

			-- Overseer ——————————————————————————————————————————————————————————————————
			overseer.setup({
				component_aliases = {
					default = {
						'on_exit_set_status',
						{ 'on_complete_notify', system = 'always' },
						{ 'on_complete_dispose', require_view = { 'SUCCESS', 'FAILURE' } },
					},
					default_neotest = {
						'on_complete_dispose',
						'on_complete_notify',
						'on_exit_set_status',
						'on_output_summarize',
					},
				},
				dap = true,
				task_list = {
					default_detail = 2,
					separator = '▰▰▰▰▰▰▰▰▰▰',
					min_width = { 60, 0.15 },
					max_width = { 100, 0.4 },
					max_height = { 20, 0.2 },
					min_height = 12,
				},
			})

			self.overseer = overseer

			return overseer
		end

		if key == 'compiler' then
			cmd.packadd({
				args = { 'compiler.nvim' },
				bang = true,
			})

			-- Compiler ——————————————————————————————————————————————————————————————————
			local compiler = require('compiler')

			compiler.setup({})

			self.compiler = compiler

			return compiler
		end
	end,
})

Tasks.toggle = function(self)
	local overseer = self.instance.overseer

	if overseer ~= nil then
		overseer.toggle()
	end
end

Tasks.action = function(self)
	local overseer = self.instance.overseer

	if overseer ~= nil then
		cmd.OverseerTaskAction()
	end
end

Tasks.run = function(self)
	local overseer = self.instance.overseer

	if overseer ~= nil then
		cmd.OverseerRun()
	end
end

Tasks.compile = function(self)
	local compiler = self.instance.compiler

	if compiler ~= nil then
		cmd.CompilerOpen()
	end
end

vim.api.nvim_create_user_command('Make', function(params)
	-- Insert args at the '$*' in the makeprg
	local cmd, num_subs = vim.o.makeprg:gsub('%$%*', params.args)
	if num_subs == 0 then
		cmd = cmd .. ' ' .. params.args
	end
	local task = Tasks.instance.overseer.new_task({
		cmd = vim.fn.expandcmd(cmd),
		components = {
			{
				'on_output_quickfix',
				open = not params.bang,
				open_height = 8,
				errorformat = vim.o.errorformat,
			},
			'default',
		},
	})
	task:start()
end, {
	desc = 'Run your makeprg as an Overseer task',
	nargs = '*',
	bang = true,
})

vim.api.nvim_create_user_command('Grep', function(params)
	-- Insert args at the '$*' in the grepprg
	local cmd, num_subs = vim.o.grepprg:gsub('%$%*', params.args)
	if num_subs == 0 then
		cmd = cmd .. ' ' .. params.args
	end
	local task = Tasks.instance.overseer.new_task({
		cmd = vim.fn.expandcmd(cmd),
		components = {
			{
				'on_output_quickfix',
				errorformat = vim.o.grepformat,
				open = not params.bang,
				open_height = 8,
				items_only = true,
			},
			-- We don't care to keep this around as long as most tasks
			{ 'on_complete_dispose', timeout = 30 },
			'default',
		},
	})
	task:start()
end, { nargs = '*', bang = true, complete = 'file' })

return Tasks
