---@mod testing.mocha
---
---@brief [[
---testing helpers that encapsulate the mocha test framework
---@brief ]]

---Mocha configuration file locations In priority order
local config_locations = {
	'.mocharc.js',
	'.mocharc.yaml',
	'.mocharc.yml',
	'.mocharc.jsonc',
	'.mocharc.json',
}

---Get the path to the project root
local project_root = vim.fs.root(0, config_locations)

---If the project root is nil exit early
-- TODO: implement a way to handle this case

---establish the mocha configuration file
local config_location_iter = vim.iter(config_locations)
---Get the first match as they are in priority order
local matched_config_locations = config_location_iter:find(function(filename)
	return vim.uv.fs_stat(vim.fs.joinpath(project_root, filename))
end)

local js_spec_query = [[
  ((pair
    key: (property_identifier) @func_name (#eq? @func_name "spec")
    value: (array (string) @spec.files)
  )) @spec.assignment
]]

local yaml_spec_query = [[
  ((block_mapping_pair
    key: (flow_node (plain_scalar (string_scalar))) @func_name (#eq? @func_name "spec")
    value: (block_node (block_sequence (block_sequence_item [(flow_node) (block_node)] @spec.files)))
  )) @spec.assignment
]]

-- use the spec values to glob the files
-- This tends to be much faster that using the dry run functionality
-- The dry run functionality could still be used to enrich the data
-- For mocha it isn't necessary to worry about parameterized tests
