if vim.g.did_load_starter_plugin then
	return
end
vim.g.did_load_starter_plugin = true

local starter = require('mini.starter')

starter.setup({
	evaluate_single = true,
	items = {
		-- Use this if you set up 'mini.sessions'
		starter.sections.builtin_actions(),
		starter.sections.sessions(5, true),
		starter.sections.recent_files(10, true),
		starter.sections.recent_files(10, false),
		starter.sections.telescope(),
	},
	content_hooks = {
		starter.gen_hook.adding_bullet(),
		starter.gen_hook.aligning('center', 'center'),
		starter.gen_hook.indexing('all', { 'Builtin actions' }),
		starter.gen_hook.padding(3, 2),
	},
})
