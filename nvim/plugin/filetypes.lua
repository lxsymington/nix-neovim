local filetype = vim.filetype

filetype.add({
	filename = {
		['.nycrc'] = 'json',
		['api-extractor.json'] = 'jsonc',
	},
})
