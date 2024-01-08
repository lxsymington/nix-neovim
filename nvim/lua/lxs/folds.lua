local api = vim.api
local bo = vim.bo
local wo = vim.wo
local v = vim.v
local split = vim.split
local tbl_contains = vim.tbl_contains
local treesitter = vim.treesitter

local M = {}

-- List of file types to use default fold text for
local fold_exclusions = { 'vim' }

local function is_ignored()
	if wo.diff then
		return wo.diff
	end
	return tbl_contains(fold_exclusions, bo.filetype)
end

function M.foldtext()
	if is_ignored() then
		return treesitter.foldtext()
	end

	local treesitter_fold = treesitter.foldtext()

	if type(treesitter_fold) == 'string' then
		return treesitter_fold
	end

	-- append string to treesitter fold text which is a lua table list
	table.insert(treesitter_fold, { ' … ', 'Folded' })

	local lines_count = v.foldend - v.foldstart + 1
	local count_text = '(' .. lines_count .. ' lines)'

	table.insert(treesitter_fold, { count_text, 'Folded' })

	--NOTE: foldcolumn can now be set to a value of auto:Count e.g auto:5
	--so we split off the auto portion so we can still get the line count
	local parts = split(wo.foldcolumn, ':')
	local column_size = parts[#parts]
	local fold_segments = vim.tbl_map(function(segment)
		return segment[1]
	end, treesitter_fold)

	local fold_string = table.concat(fold_segments, '')
	local fold_string_length = #fold_string
	local text_length = fold_string_length + column_size
	local status_column_width = 7
	local fold_fill_char = vim.opt.fillchars:get().fold

	local fold_fill_char_repeat = api.nvim_win_get_width(0) - (text_length + status_column_width)

	table.insert(treesitter_fold, #treesitter_fold, {
		string.rep(fold_fill_char, fold_fill_char_repeat),
		'Folded',
	})

	return treesitter_fold
end

return M
