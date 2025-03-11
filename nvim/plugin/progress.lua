local fidget = require('fidget')

fidget.setup({
	-- Options related to LSP progress subsystem
	progress = {
		display = {
			progress_icon = { 'meter' },
		},
	},
	-- Options related to notification subsystem
	notification = {
		-- Options related to how notifications are rendered as text
		view = {
			icon_separator = ' ⟫ ', -- Separator between group name and icon
			group_separator = '┉┉┉┉┉┉┉┉┉┉', -- Separator between notification groups
		},
	},
})
