local auc = vim.api.nvim_create_autocmd
local aug = vim.api.nvim_create_augroup

auc('TextYankPost', {
	group = aug('my-highlight', { clear = true }),
	callback = function() vim.highlight.on_yank() end,
})
