local map = vim.keymap.set

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

-- NOTE: replaced by zellij.nvim
-- map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
-- map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
-- map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
-- map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

-- Resize window
map("n", "<M-Left>", ":vertical resize -2<CR>", { silent = true })
map("n", "<M-Right>", ":vertical resize +2<CR>", { silent = true })
map("n", "<M-Up>", ":resize +2<CR>", { silent = true })
map("n", "<M-Down>", ":resize -2<CR>", { silent = true })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

-- map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
-- map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })
map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })

map({ "n", "x" }, "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- tabufline
if require("nvconfig").ui.tabufline.enabled then
  map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })

  map("n", "<tab>", function()
    require("nvchad.tabufline").next()
  end, { desc = "buffer goto next" })

  map("n", "<S-tab>", function()
    require("nvchad.tabufline").prev()
  end, { desc = "buffer goto prev" })

  map("n", "<leader>x", function()
    require("nvchad.tabufline").close_buffer()
  end, { desc = "buffer close" })
end

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- new terminals
map("n", "<leader>h", function()
  require("nvchad.term").new { pos = "sp" }
end, { desc = "terminal new horizontal term" })

map("n", "<leader>v", function()
  require("nvchad.term").new { pos = "vsp" }
end, { desc = "terminal new vertical term" })

-- toggleable
map({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "terminal toggleable vertical term" })

map({ "n", "t" }, "<A-t>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal toggleable horizontal term" })

map({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })
map("n", "<leader>gl", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle blame" })
-- Shared toggle state

local transparency_toggle = Snacks.toggle.new {
  id = "transparency",
  name = "Transparency",
  get = function()
    return vim.g.ui_transparent
  end,
  set = function(state)
    vim.g.ui_transparent = state
  end,
}
transparency_toggle:map("<leader>ut", { desc = "Toggle transparency" })
-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "whichkey query lookup" })

map("n", ";", ":", { desc = "CMD enter command mode" })
-- map("t", "<ESC>", [[<C-\><C-n>]])
map("i", "jk", "<ESC>")
map("n", "-", "<cmd>Oil<CR>", { desc = "Oil" })
-- NOTE: replaced with mini.move
-- keep visual mode when indenting
-- map("v", "<", "<gv")
-- map("v", ">", ">gv")

map("n", "<leader>uH", function()
  require("illuminate").toggle_visibility_buf()
  vim.notify(
    string.format("references underline toggled %s", require("illuminate.engine").invisible_bufs),
    vim.log.levels.INFO
  )
end, { desc = "Toggle references underline" })
map("n", "[r", function()
  require("illuminate").goto_prev_reference(wrap)
end, { desc = "Next Reference" })
map("n", "]r", function()
  require("illuminate").goto_next_reference(wrap)
end, { desc = "Prev Reference" })

map({ "n", "x" }, "ga", require("tiny-code-action").code_action)

map("n", "gs", function()
  vim.diagnostic.open_float(nil, {
    -- border = "none",
    style = "minimal",
  })
end, { desc = "LSP diagnostic" })

map("n", "gy", function()
  local diag = vim.diagnostic.get(0, { lnum = vim.fn.line "." - 1 }) -- english comment: get diagnostics on this line
  if #diag == 0 then
    vim.notify("No diagnostics on this line", vim.log.levels.ERROR)
    return
  end

  -- english comment: copy the first diagnostic message
  local msg = diag[1].message
  vim.fn.setreg("+", msg) -- copy to system clipboard

  vim.notify("Diagnostic copied", vim.log.levels.INFO)
end, {
  desc = "Copy diagnostic message",
})

-- NOTE: replaced by snacks nvim
-- vim.keymap.set("n", "<leader>h", function()
--   vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
--   vim.notify(vim.lsp.inlay_hint.is_enabled() and "Inlay Hints Enabled" or "Inlay Hints Disabled", vim.log.levels.INFO)
-- end, { desc = "Toggle Inlay Hints" })

vim.keymap.set("n", "<leader>tn", ":tabnew<CR>")
vim.keymap.set("n", "<leader>tq", ":tabclose<CR>")
vim.keymap.set("n", "<leader>ts", ":tab split<CR>")
vim.keymap.set("n", "<leader><Tab>", ":tabnext<CR>")
vim.keymap.set("n", "<leader><S-Tab>", ":tabprevious<CR>")

-- save
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
