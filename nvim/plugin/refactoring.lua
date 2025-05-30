local refactoring = require('refactoring')

-- Refactoring –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
require('refactoring').setup({})

-- prompt for a refactor to apply when the remap is triggered
vim.keymap.set({ 'n', 'x' }, 'grs', function()
	refactoring.select_refactor()
end, { desc = 'Select refactor' })
-- Note that not all refactor support both normal and visual mode
