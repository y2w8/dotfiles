-- Window navigation
vim.keymap.set({ "n", "t" }, "<C-k>", "<cmd>NeolijUp<CR>", { desc = "Move up", silent = true })
vim.keymap.set({ "n", "t" }, "<C-j>", "<cmd>NeolijDown<CR>", { desc = "Move down", silent = true })
vim.keymap.set({ "n", "t" }, "<C-h>", "<cmd>NeolijLeftSmart<CR>", { desc = "Move left", silent = true })
vim.keymap.set({ "n", "t" }, "<C-l>", "<cmd>NeolijRightSmart<CR>", { desc = "Move right", silent = true })

-- Tab actions
vim.keymap.set("n", "<leader>zt", ":NeolijNewTab<CR>", { desc = "New Zellij Tab", silent = true })
vim.keymap.set("n", "<leader>zr", ":NeolijRenameTab<CR>", { desc = "Rename Zellij Tab", silent = true })
vim.keymap.set("n", "<leader>zl", ":NeolijMoveTabLeft<CR>", { desc = "Move Tab Left", silent = true })
vim.keymap.set("n", "<leader>zL", ":NeolijMoveTabRight<CR>", { desc = "Move Tab Right", silent = true })

-- Pane actions
vim.keymap.set("n", "<leader>zp", ":NeolijNewPane<CR>", { desc = "New Zellij Pane", silent = true })
vim.keymap.set("n", "<leader>zn", ":NeolijRenamePane<CR>", { desc = "Rename Zellij Pane", silent = true })
vim.keymap.set("n", "<leader>zu", ":NeolijMovePaneUp<CR>", { desc = "Move Pane Up", silent = true })
vim.keymap.set("n", "<leader>zd", ":NeolijMovePaneDown<CR>", { desc = "Move Pane Down", silent = true })
vim.keymap.set("n", "<leader>zh", ":NeolijMovePaneLeft<CR>", { desc = "Move Pane Left", silent = true })
vim.keymap.set("n", "<leader>zR", ":NeolijMovePaneRight<CR>", { desc = "Move Pane Right", silent = true })

return {
  vim_zellij_navigator = true
}
