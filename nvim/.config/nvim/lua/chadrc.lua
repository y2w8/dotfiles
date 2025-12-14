-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "catppuccin-mocha",
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
M.nvdash = { load_on_startup = false }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
-- }

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    require("nvim-autopairs").remove_rule(">")
    require("nvim-autopairs").remove_rule("<")
    -- أهم سطر: تعطيل auto CR
    vim.b.autopairs_cr = false
  end,
})
return M
