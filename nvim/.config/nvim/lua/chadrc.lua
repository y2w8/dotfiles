---@diagnostic disable: assign-type-mismatch
-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

vim.g.ui_transparent = vim.g.ui_transparent or true
---@type ChadrcConfig
local M = {}

vim.g.is_firenvim = vim.fn.exists "g:started_by_firenvim" == 1

M.base46 = {
  theme = "catppuccin-mocha",
  transparency = true,
  -- hl_override = {
  --   Folded = { bg = nil, fg = nil }
  -- }
}

-- local my_hl = false
-- if not my_hl then
--   M.base46.hl_override = {
--   blink = {
--     BlinkCmpMenuBorder = { fg = "#252434", bg = "#252434"},
--     BlinkCmpMenu = { bg = "#252434" }
--   }
--   }
-- end
M.nvdash = { enabled = false }
M.ui = {
  tabufline = {
    enabled = not vim.g.is_firenvim,
    order = { "treeOffset", "buffers", "tabs", "btns" },
    lazyload = false,
  },
  statusline = {
    enabled = not vim.g.is_firenvim,
  },
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    require("nvim-autopairs").remove_rule ">"
    require("nvim-autopairs").remove_rule "<"
    vim.b.autopairs_cr = false
  end,
})
return M
