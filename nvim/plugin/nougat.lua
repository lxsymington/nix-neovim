local nougat = require('nougat')
local core = require('nougat.core')
local Bar = require('nougat.bar')
local Item = require('nougat.item')
local sep = require('nougat.separator')

local nut = {
	buf = {
		diagnostic_count = require('nougat.nut.buf.diagnostic_count').create,
		filename = require('nougat.nut.buf.filename').create,
		filetype = require('nougat.nut.buf.filetype').create,
	},
	git = {
		branch = require('nougat.nut.git.branch').create,
		status = require('nougat.nut.git.status'),
	},
	tab = {
		tablist = {
			tabs = require('nougat.nut.tab.tablist').create,
			close = require('nougat.nut.tab.tablist.close').create,
			icon = require('nougat.nut.tab.tablist.icon').create,
			label = require('nougat.nut.tab.tablist.label').create,
			modified = require('nougat.nut.tab.tablist.modified').create,
		},
	},
	mode = require('nougat.nut.mode').create,
	spacer = require('nougat.nut.spacer').create,
	truncation_point = require('nougat.nut.truncation_point').create,
}

---@type nougat.color
local color = require('nougat.color').get()

local mode = nut.mode({
	sep_left = sep.space(true),
	sep_right = sep.space(true),
})

local filename = (function()
	local item = Item({
		prepare = function(_, ctx)
			local bufnr, data = ctx.bufnr, ctx.ctx
			data.readonly = vim.api.nvim_get_option_value('readonly', {})
			data.modifiable = vim.api.nvim_get_option_value('modifiable', {})
			data.modified = vim.api.nvim_get_option_value('modified', {})
		end,
		content = {
			Item({
				hl = { fg = color.fg },
				hidden = function(_, ctx)
					return not ctx.ctx.readonly
				end,
				suffix = ' ',
				content = '󰏯 ',
			}),
			Item({
				hl = { fg = color.fg },
				hidden = function(_, ctx)
					return ctx.ctx.modifiable
				end,
				content = '',
				suffix = ' ',
			}),
			nut.buf.filename({
				hl = { fg = color.fg },
				prefix = function(_, ctx)
					local data = ctx.ctx
					if data.readonly or not data.modifiable then
						return ' '
					end
					return ''
				end,
				suffix = function(_, ctx)
					local data = ctx.ctx
					if data.modified then
						return ' '
					end
					return ''
				end,
			}),
			Item({
				hl = { fg = color.fg },
				hidden = function(_, ctx)
					return not ctx.ctx.modified
				end,
				content = '󰐖',
			}),
		},
	})

	return item
end)()

local macros = Item({
	hl = { fg = color.green },
	prepare = function(_, ctx)
		local data = ctx.ctx
		data.recording = vim.fn.reg_recording()
		data.executing = vim.fn.reg_executing()
	end,
	prefix = function(_, ctx)
		local data = ctx.ctx
		if data.recording ~= '' then
			return '󰄀 @ '
		elseif data.executing ~= '' then
			return '󱉺 @ '
		end
		return ''
	end,
	content = function(_, ctx)
		local data = ctx.ctx
		if data.recording ~= '' then
			return data.recording
		elseif data.executing ~= '' then
			return data.executing
		end
		return ''
	end,
	hidden = function(_, ctx)
		local data = ctx.ctx
		return data.recording == '' and data.executing == ''
	end,
})

local ruler = (function()
	local scroll_hl = {
		[true] = { bg = color.bg3 },
		[false] = { bg = color.bg4 },
	}

	local item = Item({
		content = {
			Item({
				hl = { fg = color.magenta },
				sep_left = sep.none(true),
				content = core.group({
					core.code('l'),
					':',
					core.code('c'),
				}, { align = 'left', min_width = 8 }),
				suffix = ' ',
			}),
			Item({
				hl = function(_, ctx)
					return scroll_hl[ctx.is_focused]
				end,
				prefix = ' ',
				content = core.code('P'),
				sep_right = sep.none(true),
			}),
		},
		sep_right = sep.space(true),
	})

	return item
end)()

-- renders space only when item is rendered
---@param item NougatItem
local function paired_space(item)
	return Item({
		content = sep.space().content,
		hidden = item,
	})
end

local stl = Bar('statusline')
stl:add_item(mode)
stl:add_item(sep.space())
stl:add_item(nut.git.branch({
	hl = { fg = color.magenta },
	prefix = ' ',
	suffix = ' ',
}))
stl:add_item(sep.space())
local gitstatus = stl:add_item(nut.git.status.create({
	hl = { fg = color.fg },
	content = {
		nut.git.status.count('added', {
			hl = { fg = color.green },
			prefix = '󰐖 ',
			suffix = function(_, ctx)
				return (ctx.gitstatus.changed > 0 or ctx.gitstatus.removed > 0) and ' ' or ''
			end,
		}),
		nut.git.status.count('changed', {
			hl = { fg = color.blue },
			prefix = '󱕍 ',
			suffix = function(_, ctx)
				return ctx.gitstatus.removed > 0 and ' ' or ''
			end,
		}),
		nut.git.status.count('removed', {
			hl = { fg = color.red },
			prefix = '󰍵 ',
		}),
	},
}))
stl:add_item(paired_space(gitstatus))
stl:add_item(filename)
stl:add_item(sep.space())
stl:add_item(nut.spacer())
stl:add_item(nut.truncation_point())
stl:add_item(macros)
stl:add_item(nut.buf.filetype({
	hl = { fg = color.blue },
}))
stl:add_item(sep.space())
local diagnostic_count = stl:add_item(nut.buf.diagnostic_count({
	config = {
		error = { prefix = ' ' },
		warn = { prefix = ' ' },
		info = { prefix = ' ' },
		hint = { prefix = '󰌶 ' },
	},
}))
stl:add_item(paired_space(diagnostic_count))
stl:add_item(ruler)

local stl_inactive = Bar('statusline')
stl_inactive:add_item(mode)
stl_inactive:add_item(sep.space())
stl_inactive:add_item(filename)
stl_inactive:add_item(sep.space())
stl_inactive:add_item(nut.spacer())
stl_inactive:add_item(ruler)

nougat.set_statusline(function(ctx)
	return ctx.is_focused and stl or stl_inactive
end)

local tal = Bar('tabline')

tal:add_item(nut.tab.tablist.tabs({
	active_tab = {
		hl = { bg = color.bg, fg = color.blue },
		prefix = ' ',
		suffix = ' ',
		content = {
			nut.tab.tablist.icon({ suffix = ' ' }),
			nut.tab.tablist.label({}),
			nut.tab.tablist.modified({ prefix = ' ', config = { text = '●' } }),
			nut.tab.tablist.close({ prefix = ' ', config = { text = '󰅖' } }),
		},
		sep_left = sep.space(),
		sep_right = sep.space(),
	},
	inactive_tab = {
		hl = { bg = color.bg2, fg = color.fg2 },
		prefix = ' ',
		suffix = ' ',
		content = {
			nut.tab.tablist.icon({ suffix = ' ' }),
			nut.tab.tablist.label({}),
			nut.tab.tablist.modified({ prefix = ' ', config = { text = '●' } }),
			nut.tab.tablist.close({ prefix = ' ', config = { text = '󰅖' } }),
		},
		sep_left = sep.space(),
		sep_right = sep.space(),
	},
}))

nougat.set_tabline(tal)
