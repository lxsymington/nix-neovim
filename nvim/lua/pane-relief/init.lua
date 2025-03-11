local M = {}

local api = vim.api
local defer_fn = vim.defer_fn
local iter = vim.iter
local split = vim.split

local pane_relief_namespace = api.nvim_create_namespace('pane_relief')

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

M.ui = api.nvim_list_uis()[1]

function M.create_notification_pane()
	local buf = api.nvim_create_buf(false, true)

	api.nvim_buf_set_lines(buf, 0, -1, true, M.lines)

	local win_handle = vim.schedule_wrap(api.nvim_open_win)(buf, false, {
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

	defer_fn(function()
		api.nvim_win_close(win_handle, true)
		api.nvim_buf_delete(buf, { force = true })
	end, 5000)

	return win_handle
end

local glyph_dimensions = {
	col = 5,
	row = 4,
}

M.numbers = setmetatable({
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
}, {
	__index = function(self, key)
		if type(key) ~= 'number' then
			return nil
		end

		if math.abs(key) < 10 then
			return rawget(self, math.max(key - 1, 0))
		end
	end,
})

function M.identify_tab_panes()
	local wins = api.nvim_tabpage_list_wins(0)

	local focusable_wins = iter(wins)
		:filter(function(win)
			local win_config = api.nvim_win_get_config(win)

			return win_config.focusable == true
		end)
		:totable()

	iter(ipairs(focusable_wins)):each(function(i, win)
		local buf = api.nvim_create_buf(false, true)
		api.nvim_buf_set_lines(buf, 0, -1, true, split(M.numbers[i], '\n'))

		local win_handle = vim.schedule_wrap(api.nvim_open_win)(buf, false, {
			relative = 'win',
			border = 'shadow',
			focusable = false,
			fixed = true,
			height = glyph_dimensions.row,
			width = glyph_dimensions.col,
			style = 'minimal',
			win = win,
			col = api.nvim_win_get_width(win) / 2 - glyph_dimensions.col,
			row = api.nvim_win_get_height(win) / 2 - glyph_dimensions.row,
		})

		vim.defer_fn(
			vim.schedule_wrap(function()
				api.nvim_win_close(win_handle, true)
				api.nvim_buf_delete(buf, { force = true })
			end),
			5000
		)
	end)
end

function M.register()
	local sequence = api.nvim_replace_termcodes('<C-W>', true, true, true)

	vim.on_key(function(keys)
		local mode = api.nvim_get_mode().mode
		if not mode:match('n') then
			return
		end

		if keys ~= sequence then
			return
		end

		M.identify_tab_panes()
	end, pane_relief_namespace)
end

return M
