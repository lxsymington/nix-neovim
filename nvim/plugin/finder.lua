if vim.g.did_load_telescope_plugin then
	return
end
vim.g.did_load_telescope_plugin = true

local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local themes = require('telescope.themes')
local fn = vim.fn
local fs = vim.fs
local keymap = vim.keymap
local loop = vim.loop
local tbl_extend = vim.tbl_extend

local centred_opts = {
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
	path_display = { shorten = { len = 5, exclude = { -1 } } },
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

--- Like live_grep, but fuzzy (and slower)
local function fuzzy_grep(opts)
	opts = tbl_extend('error', opts or {}, { search = '', prompt_title = 'Fuzzy grep' })
	builtin.grep_string(opts)
end

local function frecent()
	telescope.extensions.frecency.frecency(centred_opts)
end

local function buffers()
	builtin.buffers(centred_opts)
end

local function builtins()
	builtin.builtin(centred_opts)
end

local function definitions()
	builtin.lsp_definitions(themes.get_ivy())
end

local function references()
	builtin.lsp_references(themes.get_ivy())
end

local function document_symbols()
	builtin.lsp_document_symbols(themes.get_ivy())
end

local function workspace_symbols()
	builtin.lsp_workspace_symbols(themes.get_ivy())
end

local function dynamic_workspace_symbols()
	builtin.lsp_dynamic_workspace_symbols(themes.get_ivy())
end

local function symbols()
	local opts = {
		border = true,
		layout_strategy = 'cursor',
		layout_config = {
			height = function(_, _, lines)
				return math.min(10, math.floor(lines * 0.2))
			end,
			width = function(_, cols, _)
				return math.min(40, math.floor(cols * 0.4))
			end,
		},
	}

	builtin.symbols(opts)
end

keymap.set('n', '<Leader>/f', builtin.find_files, { desc = '[telescope] find files' })
keymap.set('n', '<Leader>/O', builtin.oldfiles, { desc = '[telescope] old files' })
keymap.set('n', '<Leader>/g', builtin.live_grep, { desc = '[telescope] live grep' })
keymap.set('n', '<Leader>/j', builtin.jumplist, { desc = '[telescope] jumplist' })
keymap.set('n', '<Leader>/d', definitions, { desc = '[telescope] definitions' })
keymap.set('n', '<Leader>/r', references, { desc = '[telescope] references' })
keymap.set('n', '<Leader>/G', fuzzy_grep, { desc = '[telescope] fuzzy grep' })
keymap.set('n', '<Leader>/p', project_files, { desc = '[telescope] project files' })
keymap.set('n', '<Leader>/b', buffers, { desc = '[telescope] buffers' })
keymap.set('n', '<Leader>/B', builtins, { desc = '[telescope] builtins' })
keymap.set('n', '<Leader>/s', document_symbols, { desc = '[telescope] lsp document symbols' })
keymap.set('n', '<Leader>/£', workspace_symbols, { desc = '[telescope] lsp workspace symbols' })
keymap.set(
	'n',
	'<Leader>/S',
	dynamic_workspace_symbols,
	{ desc = '[telescope] lsp dynamic workspace symbols' }
)
keymap.set('n', '<Leader>/;', symbols, { desc = '[telescope] find symbols' })
keymap.set('n', '<Leader>/.', builtin.resume, { desc = '[telescope] resume' })
keymap.set('n', '<Leader>/vm', builtin.marks, { desc = '[telescope] find marks' })
keymap.set('n', '<Leader>/vh', builtin.help_tags, { desc = '[telescope] find help tags' })
keymap.set('n', '<Leader>/vk', builtin.keymaps, { desc = '[telescope] find keymaps' })
keymap.set('n', '<Leader><Leader>', frecent, { desc = '[telescope] frecent files' })

local layout_config = {
	width = function(_, cols, _)
		return math.min(180, math.floor(cols * 0.8))
	end,
	height = function(_, _, lines)
		return math.min(60, math.floor(lines * 0.75))
	end,
	prompt_position = 'top',
	flex = {
		mirror = true,
		horizontal = {
			mirror = true,
			preview_width = function(_, cols, _)
				return math.min(100, math.floor(cols * (5 / 9)))
			end,
		},
		vertical = {
			prompt_position = 'top',
			width = function(_, cols, _)
				return math.min(100, math.floor(cols * 0.8))
			end,
			preview_height = function(_, _, lines)
				return math.min(45, math.floor(lines * 0.5))
			end,
		},
	},
}

telescope.setup({
	defaults = {
		path_display = {
			shorten = { len = 5, exclude = { -1 } },
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
			limit = 1000,
		},
		color_devicons = true,
		set_env = { ['COLORTERM'] = 'truecolor' },
		prompt_prefix = '   ',
		selection_caret = '➜ ',
		entry_prefix = '  ',
		initial_mode = 'insert',
		sorting_strategy = 'ascending',
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
