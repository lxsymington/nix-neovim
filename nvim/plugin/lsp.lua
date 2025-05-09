local fn = vim.fn
local lsp = vim.lsp

if fn.executable('lua-language-server') == 1 then
	lsp.enable('lua_ls')
end

if fn.executable('vscode-eslint-language-server') == 1 then
	lsp.enable('eslint')
end

if fn.executable('deno') == 1 then
	lsp.enable('denols')
end

if fn.executable('tsserver') == 1 and fn.executable('vtsls') == 1 then
	lsp.enable('vtsls')
end

if fn.executable('terraform') == 1 then
	lsp.enable('terraform_lsp')
end

if fn.executable('yaml-language-server') == 1 then
	lsp.enable('yamlls')
end

if fn.executable('nixd') == 1 then
	lsp.enable('nixd')
end

if fn.executable('vscode-json-language-server') == 1 then
	lsp.enable('jsonls')
end

if fn.executable('ast-grep') == 1 then
	lsp.enable('ast_grep')
end

if fn.executable('biome') == 1 then
	lsp.enable('biome')
end

if fn.executable('harper-ls') == 1 then
	lsp.enable('harper_ls')
end
