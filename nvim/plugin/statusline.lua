if vim.g.did_load_statusline_plugin then
	return
end
vim.g.did_load_statusline_plugin = true

local nougat = require('nougat')
local color = require('nougat.color').get()
local core = require('nougat.core')
local Bar = require('nougat.bar')
local Item = require('nougat.item')
local sep = require('nougat.separator')
local lsp_server_nut = require('nougat.nut.lsp.servers')

local nut = {
	buf = {
		diagnostic_count = require('nougat.nut.buf.diagnostic_count').create,
		fileencoding = require('nougat.nut.buf.fileencoding').create,
		fileformat = require('nougat.nut.buf.fileformat').create,
		filename = require('nougat.nut.buf.filename').create,
		filestatus = require('nougat.nut.buf.filestatus').create,
		filetype = require('nougat.nut.buf.filetype').create,
		filetype_icon = require('nougat.nut.buf.filetype_icon').create,
	},
	git = {
		branch = require('nougat.nut.git.branch').create,
		status = require('nougat.nut.git.status'),
	},
	tab = {
		tablist = {
			close = require('nougat.nut.tab.tablist.close').create,
			diagnostic_count = require('nougat.nut.tab.tablist.diagnostic_count').create,
			icon = require('nougat.nut.tab.tablist.icon').create,
			label = require('nougat.nut.tab.tablist.label').create,
			modified = require('nougat.nut.tab.tablist.modified').create,
			tabs = require('nougat.nut.tab.tablist').create,
		},
	},
	mode = require('nougat.nut.mode').create,
	spacer = require('nougat.nut.spacer').create,
	truncation_point = require('nougat.nut.truncation_point').create,
}

local mode = nut.mode({
	sep_left = sep.space(true),
	sep_right = sep.space(true),
})

local search = Item({
	prepare = function(_, ctx)
		local data = ctx.ctx
		data.search_highlight = vim.v.hlsearch == 1
		data.search_active, data.search_data =
			pcall(vim.fn.searchcount, { maxcount = 0, recalculate = 1 })
	end,
	prefix = '🔎',
	content = {
		Item({
			hidden = function(_, ctx)
				return not ctx.ctx.search_active
			end,
			content = function(_, ctx)
				local data = ctx.ctx

				if
					data.search_active
					and type(data.search_data.current) == 'number'
					and type(data.search_data.current) == 'number'
				then
					return string.format('%d∕%d', data.search_data.current, data.search_data.total)
				end

				return ''
			end,
			sep_left = sep.space(),
			sep_right = sep.none(),
			hl = { fg = color.magenta },
		}),
		Item({
			content = function(_, ctx)
				local data = ctx.ctx
				return string.format('%s', data.search_highlight and '' or '')
			end,
			sep_left = sep.space(),
			sep_right = sep.none(),
			hl = { fg = color.accent.blue },
		}),
	},
	sep_left = sep.space(),
	sep_right = sep.space(),
})

local filename = Item({
	content = {
		nut.buf.filetype_icon({
			sep_left = sep.none(),
		}),
		nut.buf.filename({
			sep_left = sep.space(),
			hl = {
				fg = color.blue,
			},
		}),
		nut.buf.filestatus({
			config = {
				modified = '🖋',
				nomodifiable = '🔒',
				readonly = '🔏',
			},
			sep_left = sep.space(),
		}),
		nut.buf.fileformat({
			hl = 'Grey',
			sep_left = sep.space(),
			suffix = '·',
			sep_right = sep.none(),
		}),
		nut.buf.fileencoding({
			hl = 'DimGrey',
			sep_left = sep.none(),
			sep_right = sep.none(),
		}),
	},
	sep_left = sep.space(),
	sep_right = sep.space(),
})

local macros = Item({
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

local ruler = Item({
	content = {
		Item({
			hl = {
				fg = color.blue,
			},
			content = core.group({
				core.code('l'),
				':',
				core.code('c'),
			}, { align = 'left', min_width = 8 }),
			sep_left = sep.none(),
			sep_right = sep.none(),
		}),
		Item({
			hl = {
				fg = color.green,
			},
			content = core.code('P'),
			sep_left = sep.none(),
			sep_right = sep.none(),
		}),
	},
	sep_left = sep.none(),
	sep_right = sep.none(),
})

local copilot = Item({
	ctx = { value = nil },
	init = function(item)
		require('copilot.api').register_status_notification_handler(function(data)
			item.ctx.value = data.status
			require('nougat').refresh_statusline()
		end)
	end,
	prefix = '  ⋅ ',
	content = function(item)
		return item.ctx.value
	end,
})

-- renders space only when item is rendered
---@param item NougatItem
local function paired_space(item)
	return Item({
		content = sep.space().content,
		hidden = item,
	})
end

local lsp_servers = lsp_server_nut.create({
	-- whatever you set here, will be available as `item.ctx`
	-- doc: https://github.com/MunifTanjim/nougat.nvim/tree/main/lua/nougat/item#ctx
	ctx = {
		content = {
			lua_ls = 'LuaLS',
		},
		hl = {
			lua_ls = { fg = color.cyan },
		},
	},
	hl = { fg = color.green },
	sep_left = sep.space(),
	config = {
		content = function(client, item)
			if client.name == 'copilot' then
				-- if you return nothing, that lsp server will be hidden.
				-- so 'copilot' lsp will be hidden
				return
			end

			return {
				-- `item.ctx.content` has value for `lua_ls`, so it'll be displayed as `LuaLS`.
				-- Other LSP servers will be displayed as default `client.name`
				content = item.ctx.content[client.name] or client.name,
				-- `item.ctx.hl` has value for `lua_ls`, so it'll be displayed with `cyan` color.
				-- Other LSP servers will have default/no colors.
				hl = item.ctx.hl[client.name],
			}
		end,
		sep = ' ',
	},
	suffix = ' ',
})

local stl = Bar('statusline')
stl:add_item(mode)
stl:add_item(sep.space())
stl:add_item(nut.git.branch({
	prefix = ' ',
	hl = {
		fg = color.magenta,
	},
}))
stl:add_item(sep.space())
local gitstatus = stl:add_item(nut.git.status.create({
	content = {
		nut.git.status.count('added', {
			prefix = '󰐖 ',
			suffix = function(_, ctx)
				return (ctx.gitstatus.changed > 0 or ctx.gitstatus.removed > 0) and ' ' or ''
			end,
			hl = { fg = color.green },
		}),
		nut.git.status.count('changed', {
			prefix = '󱕍 ',
			suffix = function(_, ctx)
				return ctx.gitstatus.removed > 0 and ' ' or ''
			end,
			hl = { fg = color.yellow },
		}),
		nut.git.status.count('removed', {
			prefix = '󰍵 ',
			hl = { fg = color.red },
		}),
	},
}))
stl:add_item(paired_space(gitstatus))
stl:add_item(filename)
stl:add_item(nut.spacer())
stl:add_item(nut.truncation_point())
stl:add_item(lsp_servers)
stl:add_item(search)
stl:add_item(nut.spacer())
stl:add_item(nut.truncation_point())
stl:add_item(copilot)
stl:add_item(paired_space(copilot))
stl:add_item(macros)
stl:add_item(paired_space(macros))
stl:add_item(nut.buf.filetype({}))
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
		prefix = ' ',
		suffix = ' ',
		content = {
			nut.tab.tablist.icon({ sep_right = sep.space() }),
			nut.tab.tablist.label({
				hl = 'Foreground',
			}),
			nut.tab.tablist.modified({
				sep_left = sep.space(),
				config = { text = '●' },
				hl = 'Yellow',
			}),
			nut.tab.tablist.close({
				sep_left = sep.space(),
				config = { text = '󰅖' },
				hl = 'Red',
			}),
		},
		hl = 'TabLineSel',
		sep_left = sep.space(),
		sep_right = sep.space(),
	},
	hl = 'TabLineFill',
	inactive_tab = {
		prefix = ' ',
		suffix = ' ',
		content = {
			nut.tab.tablist.icon({ sep_right = sep.space() }),
			nut.tab.tablist.label({
				hl = 'DimGrey',
			}),
			nut.tab.tablist.diagnostic_count({
				sep_left = sep.space(),
			}),
			nut.tab.tablist.modified({
				sep_left = sep.space(),
				config = { text = '●' },
				hl = 'DimYellow',
			}),
			nut.tab.tablist.close({
				sep_left = sep.space(),
				config = { text = '󰅖' },
				hl = 'DimRed',
			}),
		},
		hl = 'TabLine',
		sep_left = sep.space(),
		sep_right = sep.space(),
	},
}))

nougat.set_tabline(tal)
