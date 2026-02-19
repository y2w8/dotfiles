local betterTerm = require('betterTerm')

-- Toggle the first terminal (ID defaults to index_base, which is 0)
vim.keymap.set({"n", "t"}, "<C-;>", function() betterTerm.open() end, { desc = "Toggle terminal" })

-- Open a specific terminal
vim.keymap.set({"n", "t"}, "<C-/>", function() betterTerm.toggle_termwindow() end, { desc = "Toggle the window with all terminals" })

-- Cycle to the right
vim.keymap.set({"n", "t"}, "<Shift-l>", function() betterTerm.cycle(1) end, { desc = "Cycle terminals to the right" })

-- Cycle to the left
vim.keymap.set({"n", "t"}, "<Shift-h>", function() betterTerm.cycle(-1) end, { desc = "Cycle terminals to the left" })

-- Select a terminal to focus
vim.keymap.set("n", "<leader>tt", betterTerm.select, { desc = "Select terminal" })

-- Rename the current terminal
vim.keymap.set("n", "<leader>tr", betterTerm.rename, { desc = "Rename terminal" })

-- Toggle the tabs bar
vim.keymap.set("n", "<leader>tb", betterTerm.toggle_tabs, { desc = "Toggle terminal tabs" })
