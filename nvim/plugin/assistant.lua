local copilot = require('copilot')
local copilot_cmp = require('copilot_cmp')

-- Copilot –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
copilot.setup({
	suggestion = { enabled = true, auto_trigger = false },
	panel = { enabled = true },
})

copilot_cmp.setup()
