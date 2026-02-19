-- Window navigation
vim.keymap.set({ "n", "t" }, "<C-k>", "<cmd>ZellijUp<CR>", { desc = "Move up", silent = true })
vim.keymap.set({ "n", "t" }, "<C-j>", "<cmd>ZellijDown<CR>", { desc = "Move down", silent = true })
vim.keymap.set({ "n", "t" }, "<C-h>", "<cmd>ZellijLeftSmart<CR>", { desc = "Move left", silent = true })
vim.keymap.set({ "n", "t" }, "<C-l>", "<cmd>ZellijRightSmart<CR>", { desc = "Move right", silent = true })

-- Tab actions
vim.keymap.set("n", "<leader>zt", ":ZellijNewTab<CR>", { desc = "New Zellij Tab", silent = true })
vim.keymap.set("n", "<leader>zr", ":ZellijRenameTab<CR>", { desc = "Rename Zellij Tab", silent = true })
vim.keymap.set("n", "<leader>zl", ":ZellijMoveTabLeft<CR>", { desc = "Move Tab Left", silent = true })
vim.keymap.set("n", "<leader>zL", ":ZellijMoveTabRight<CR>", { desc = "Move Tab Right", silent = true })

-- Pane actions
vim.keymap.set("n", "<leader>zp", ":ZellijNewPane<CR>", { desc = "New Zellij Pane", silent = true })
vim.keymap.set("n", "<leader>zn", ":ZellijRenamePane<CR>", { desc = "Rename Zellij Pane", silent = true })
vim.keymap.set("n", "<leader>zu", ":ZellijMovePaneUp<CR>", { desc = "Move Pane Up", silent = true })
vim.keymap.set("n", "<leader>zd", ":ZellijMovePaneDown<CR>", { desc = "Move Pane Down", silent = true })
vim.keymap.set("n", "<leader>zh", ":ZellijMovePaneLeft<CR>", { desc = "Move Pane Left", silent = true })
vim.keymap.set("n", "<leader>zR", ":ZellijMovePaneRight<CR>", { desc = "Move Pane Right", silent = true })

return {}
