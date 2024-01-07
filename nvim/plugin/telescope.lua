if vim.g.did_load_telescope_plugin then
	return
end
vim.g.did_load_telescope_plugin = true

local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local fn = vim.fn
local fs = vim.fs
local keymap = vim.keymap
local loop = vim.loop
local tbl_extend = vim.tbl_extend

local layout_config = {
	width = function(_, cols, _)
		return math.min(240, math.floor(cols * 0.8))
	end,
	height = function(_, _, lines)
		return math.min(60, math.floor(lines * 0.75))
	end,
	prompt_position = 'top',
	flex = {
		horizontal = {
			preview_width = function(_, cols, _)
				return math.min(120, math.floor(cols * 0.6 * 0.8))
			end,
		},
		vertical = {
			width = function(_, cols, _)
				return math.min(120, math.floor(cols * 0.8))
			end,
			preview_height = function(_, _, lines)
				return math.min(45, math.floor(lines * 0.5))
			end,
		},
	},
}

local function initialise_worksapces()
	local seccl_directory = fs.normalize(loop.os_homedir() .. '/Development/Seccl')
	local development_directory = fs.normalize(loop.os_homedir() .. '/Development')
	local base_dir = (fn.isdirectory(seccl_directory) == 1) and seccl_directory
		or development_directory

	local directory_iterator = fs.dir(base_dir)
	local projects = {}

	for name, type in directory_iterator do
		if type == 'directory' then
			projects = tbl_extend('error', projects, {
				[name] = fs.normalize(base_dir .. '/' .. name),
			})
		end
	end

	return tbl_extend('error', {
		['conf'] = fs.normalize(loop.os_homedir() .. '/.config'),
		['data'] = fs.normalize(loop.os_homedir() .. '/.local/share'),
	}, projects)
end

-- Fall back to find_files if not in a git repo
local project_files = function()
	local opts = {} -- define here if you want to define something
	local ok = pcall(builtin.git_files, opts)
	if not ok then
		builtin.find_files(opts)
	end
end

---@param picker function the telescope picker to use
local function grep_current_file_type(picker)
	local current_file_ext = vim.fn.expand('%:e')
	local additional_vimgrep_arguments = {}
	if current_file_ext ~= '' then
		additional_vimgrep_arguments = {
			'--type',
			current_file_ext,
		}
	end
	local conf = require('telescope.config').values
	picker({
		vimgrep_arguments = vim.tbl_flatten({
			conf.vimgrep_arguments,
			additional_vimgrep_arguments,
		}),
	})
end

--- Grep the string under the cursor, filtering for the current file type
local function grep_string_current_file_type()
	grep_current_file_type(builtin.grep_string)
end

--- Live grep, filtering for the current file type
local function live_grep_current_file_type()
	grep_current_file_type(builtin.live_grep)
end

--- Like live_grep, but fuzzy (and slower)
local function fuzzy_grep(opts)
	opts = vim.tbl_extend('error', opts or {}, { search = '', prompt_title = 'Fuzzy grep' })
	builtin.grep_string(opts)
end

local function fuzzy_grep_current_file_type()
	grep_current_file_type(fuzzy_grep)
end

local function frecent()
	local opts = {
		border = true,
		layout_strategy = 'vertical',
		layout_config = {
			anchor = 'CENTER',
			height = function(_, _, lines)
				return math.min(30, math.floor(lines * 0.75))
			end,
			mirror = 'true',
			preview_height = function(_, _, lines)
				return math.min(10, math.floor(lines * 0.75))
			end,
			prompt_position = 'bottom',
			width = function(_, cols, _)
				return math.min(100, math.floor(cols * 0.8))
			end,
		},
		path_display = { shorten = 3 },
	}

	telescope.extensions.frecency.frecency(opts)
end

keymap.set('n', '?f', builtin.find_files, { desc = '[telescope] find files' })
keymap.set('n', '?O', builtin.oldfiles, { desc = '[telescope] old files' })
keymap.set('n', '?g', builtin.live_grep, { desc = '[telescope] live grep' })
keymap.set('n', '?G', fuzzy_grep, { desc = '[telescope] fuzzy grep' })
keymap.set('n', '?ft', fuzzy_grep_current_file_type, { desc = '[telescope] fuzzy grep filetype' })
keymap.set('n', '?p', project_files, { desc = '[telescope] project files' })
keymap.set('n', '?q', builtin.quickfix, { desc = '[telescope] quickfix list' })
keymap.set('n', '?c', builtin.command_history, { desc = '[telescope] command history' })
keymap.set('n', '?l', builtin.loclist, { desc = '[telescope] loclist' })
keymap.set('n', '?r', builtin.registers, { desc = '[telescope] registers' })
keymap.set('n', '?b', builtin.buffers, { desc = '[telescope] buffers' })
keymap.set('n', '?s', builtin.lsp_document_symbols, { desc = '[telescope] lsp document symbols' })
keymap.set(
	'n',
	'?S',
	builtin.lsp_dynamic_workspace_symbols,
	{ desc = '[telescope] lsp dynamic workspace symbols' }
)

keymap.set('n', '?;', builtin.symbols, { desc = '[telescope] find symbols' })

keymap.set('n', '?vm', builtin.marks, { desc = '[telescope] find marks' })

keymap.set('n', '?vh', builtin.help_tags, { desc = '[telescope] find help tags' })

keymap.set('n', '?hz', frecent, { desc = '[telescope] frecent files' })

telescope.setup({
	defaults = {
		path_display = {
			'truncate',
		},
		layout_strategy = 'flex',
		layout_config = layout_config,
		mappings = {
			i = {
				['<C-q>'] = actions.send_to_qflist,
				['<C-l>'] = actions.send_to_loclist,
				-- ['<esc>'] = actions.close,
				['<C-s>'] = actions.cycle_previewers_next,
				['<C-a>'] = actions.cycle_previewers_prev,
			},
			n = {
				q = actions.close,
				['<Leader>q'] = actions.send_selected_to_qflist + actions.open_qflist,
			},
		},
		preview = {
			treesitter = true,
		},
		history = {
			path = vim.fn.stdpath('data') .. '/telescope_history.sqlite3',
			limit = 1000,
		},
		color_devicons = true,
		set_env = { ['COLORTERM'] = 'truecolor' },
		prompt_prefix = '   ',
		selection_caret = '➜ ',
		entry_prefix = '  ',
		initial_mode = 'insert',
		vimgrep_arguments = {
			'rg',
			'-L',
			'--color=never',
			'--no-heading',
			'--with-filename',
			'--line-number',
			'--column',
			'--smart-case',
		},
		winblend = 10,
	},
	extensions = {
		aerial = {
			show_nesting = {
				['_'] = false, -- This key will be the default
				json = true, -- You can set the option for specific filetypes
				yaml = true,
			},
		},
		frecency = {
			default_workspace = 'CWD',
			show_scores = true,
			ignore_patterns = { '*/.git/*', '*/node_modules/*', '*/tmp/*' },
			workspaces = initialise_worksapces(),
		},
		fzy_native = {
			override_generic_sorter = false,
			override_file_sorter = true,
		},
	},
})

telescope.load_extension('fzy_native')
telescope.load_extension('aerial')
telescope.load_extension('frecency')
