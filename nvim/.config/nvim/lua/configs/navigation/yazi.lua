vim.keymap.set({ "n", "v" }, "<leader>-", "<cmd>Yazi<cr>", { desc = "Open yazi at the current file" })
vim.keymap.set("n", "<leader>y", "<cmd>Yazi cwd<cr>", { desc = "Open yazi cwd" })
vim.keymap.set("n", "<c-up>", "<cmd>Yazi toggle<cr>", { desc = "Resume the last yazi session" })

return {
  open_for_directories = false,
  keymaps = {
    show_help = "<f1>",
  },
}
