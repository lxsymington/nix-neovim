local M = {}

M.icons = {
	debug = 'Ⓓ ',
	error = 'Ⓔ ',
	info = 'Ⓘ ',
	warning = 'Ⓦ ',
	trace = 'Ⓣ ',
}

M.width = 60
M.lines = {
	string.format(' %s %s', M.icons.debug, 'Title'),
	string.format('%s', string.rep('╌', M.width)),
	'Some body text for testing purposes.',
}

M.ui = vim.api.nvim_list_uis()[1]

function M.create_notification_pane()
	local buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_lines(buf, 0, -1, true, M.lines)

	local win_handle = vim.api.nvim_open_win(buf, false, {
		anchor = 'SE',
		border = 'rounded',
		col = M.ui.width - 1,
		fixed = false,
		focusable = false,
		footer = string.format('──╸%s╺──', vim.fn.strftime('%T', vim.fn.localtime())),
		footer_pos = 'right',
		height = #M.lines,
		noautocmd = true,
		relative = 'editor',
		row = M.ui.height - 1,
		style = 'minimal',
		title = string.format('──╸%s╺──', 'Pane Relief'),
		title_pos = 'right',
		width = M.width,
		zindex = 1000,
	})

	vim.defer_fn(function()
		vim.api.nvim_win_close(win_handle, true)
		vim.api.nvim_buf_delete(buf, { force = true })
	end, 5000)

	return win_handle
end

M.numbers = {
	[[
▟▛▀▜▙
█▝▖ █
█ ▝▖█
▜▙▄▟▛
  ]],
	[[
 ▗█ 
▝▀█ 
  █ 
▄▄█▄▄
  ]],
	[[
▟▛▀▜▙
  ▗▟▛
 ▟▛▘ 
▟█▄▄▄
  ]],
	[[
▟▛▀▜▙
  ▁▟▛
  ▔▜▙
▜▙▄▟▛
  ]],
	[[
  ▟▌
 ▟▛ 
▟█▄▟▙
   ▐▌
  ]],
	[[
▗█▀▀▀ 
█▙▄▄
▔ ▔▜▙
▜▙▄▟▛
  ]],
	[[
▟▛▀▜▙ 
█▄▄▄
█▔▔▜▙
▜▙▄▟▛
  ]],
	[[
▀▀▀█▛
  ▟▛ 
 ▟▛  
▟▛   
  ]],
	[[
▟▛▀▜▙
▜▙▄▟▛
█▌ ▐█
▜▙▄▟▛
  ]],
	[[
▟▛▀▜▙
█▖ ▗█
▝▀▀▀█
▜▙▄▟▛
  ]],
}

function M.identify_tab_panes()
	local wins = vim.api.nvim_tabpage_list_wins(0)

	local focusable_wins = vim
		.iter(wins)
		:filter(function(win)
			local win_config = vim.api.nvim_win_get_config(win)

			vim.print(win_config)

			return win_config.focusable == true
		end)
		:totable()

	vim.iter(ipairs(focusable_wins)):each(function(i, win)
		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_lines(buf, 0, -1, true, {
			string.format('%d', i),
		})

		local win_handle = vim.api.nvim_open_win(buf, false, {
			relative = 'win',
			border = 'rounded',
			focusable = false,
			fixed = true,
			height = 1,
			width = 1,
			style = 'minimal',
			win = win,
			col = vim.api.nvim_win_get_width(win) / 2,
			row = vim.api.nvim_win_get_height(win) / 2,
		})

		vim.defer_fn(function()
			vim.api.nvim_win_close(win_handle, true)
			vim.api.nvim_buf_delete(buf, { force = true })
		end, 5000)
	end)
end
