vim.keymap.set("v", "<C-r>", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>")
vim.keymap.set("v", "<C-s>", "<CMD>SearchReplaceWithinVisualSelection<CR>")
vim.keymap.set("v", "<C-b>", "<CMD>SearchReplaceWithinVisualSelectionCWord<CR>")

vim.keymap.set("n", "<leader>rs", "<CMD>SearchReplaceSingleBufferSelections<CR>")
vim.keymap.set("n", "<leader>ro", "<CMD>SearchReplaceSingleBufferOpen<CR>")
vim.keymap.set("n", "<leader>rw", "<CMD>SearchReplaceSingleBufferCWord<CR>")
vim.keymap.set("n", "<leader>rW", "<CMD>SearchReplaceSingleBufferCWORD<CR>")
vim.keymap.set("n", "<leader>re", "<CMD>SearchReplaceSingleBufferCExpr<CR>")
vim.keymap.set("n", "<leader>rf", "<CMD>SearchReplaceSingleBufferCFile<CR>")

vim.keymap.set("n", "<leader>rbs", "<CMD>SearchReplaceMultiBufferSelections<CR>")
vim.keymap.set("n", "<leader>rbo", "<CMD>SearchReplaceMultiBufferOpen<CR>")
vim.keymap.set("n", "<leader>rbw", "<CMD>SearchReplaceMultiBufferCWord<CR>")
vim.keymap.set("n", "<leader>rbW", "<CMD>SearchReplaceMultiBufferCWORD<CR>")
vim.keymap.set("n", "<leader>rbe", "<CMD>SearchReplaceMultiBufferCExpr<CR>")
vim.keymap.set("n", "<leader>rbf", "<CMD>SearchReplaceMultiBufferCFile<CR>")

return {
  -- optionally override defaults
  default_replace_single_buffer_options = "gcI",
  default_replace_multi_buffer_options = "egcI",
}
