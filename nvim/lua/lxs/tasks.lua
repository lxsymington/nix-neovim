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
			vim.cmd.packadd({
				args = { 'overseer.nvim' },
				bang = true,
			})

			local overseer = require('overseer')

			-- Overseer ——————————————————————————————————————————————————————————————————
			overseer.setup({
				component_aliases = {
					default = {
						{ 'display_duration', detail_level = 2 },
						'on_output_summarize',
						'on_exit_set_status',
						{ 'on_complete_notify', system = 'always' },
						{ 'on_complete_dispose', require_view = { 'SUCCESS', 'FAILURE' } },
					},
					default_neotest = {
						'on_output_summarize',
						'on_exit_set_status',
						'on_complete_notify',
						'on_complete_dispose',
					},
				},
				task_list = {
					default_detail = 2,
					separator = '▰▰▰▰▰▰▰▰▰▰',
					min_width = { 60, 0.15 },
					max_height = { 20, 0.2 },
					min_height = 12,
				},
			})

			self.overseer = overseer

			return overseer
		end

		if key == 'compiler' then
			vim.cmd.packadd({
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
	vim.print(overseer)

	if overseer ~= nil then
		cmd.OverseerToggle()
	end
end

Tasks.build = function(self)
	local overseer = self.instance.overseer
	vim.print(overseer)

	if overseer ~= nil then
		cmd.OverseerBuild()
	end
end

Tasks.action = function(self)
	local overseer = self.instance.overseer
	vim.print(overseer)

	if overseer ~= nil then
		cmd.OverseerTaskAction()
	end
end

Tasks.quick_action = function(self)
	local overseer = self.instance.overseer
	vim.print(overseer)

	if overseer ~= nil then
		cmd.OverseerQuickAction()
	end
end

Tasks.run = function(self)
	local overseer = self.instance.overseer
	vim.print(overseer)

	if overseer ~= nil then
		cmd.OverseerRun()
	end
end

Tasks.compile = function(self)
	local compiler = self.instance.compiler
	vim.print(compiler)

	if compiler ~= nil then
		cmd.CompilerOpen()
	end
end

return Tasks
