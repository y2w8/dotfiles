-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "C-h", ":wincmd h")
vim.keymap.set("n", "C-j", ":wincmd j")
vim.keymap.set("n", "C-k", ":wincmd k")
vim.keymap.set("n", "C-l", ":wincmd l")

local wk = require("which-key")

wk.add({
  { "<leader>r", group = "Run/Build" },
  { "<leader>rr", "<cmd>lua require('user.runner').auto_run()<CR>", desc = "Auto Run/Build (Smart)" },
  -- يمكنك الاحتفاظ بالخيارات المباشرة لو بغيت
  { "<leader>rj", "<cmd>lua require('user.runner').java()<CR>", desc = "Run Java (UI Select)" },
  { "<leader>rp", "<cmd>lua require('user.runner').python()<CR>", desc = "Run Python" },
  { "<leader>rc", "<cmd>lua require('user.runner').cpp()<CR>", desc = "Run C++" },
  { "<leader>ro", "<cmd>lua require('user.runner').go()<CR>", desc = "Run Go" },
})
