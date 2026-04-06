---@diagnostic disable: assign-type-mismatch
-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

vim.g.is_firenvim = vim.fn.exists "g:started_by_firenvim" == 1

vim.g.ui_transparent = not vim.g.is_firenvim

M.base46 = {
  theme = "catppuccin-mocha",
  transparency = not vim.g.is_firenvim,
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
    order = { "treeOffset", "buffers", "tabs" },
    bufwidth = 21,
    lazyload = false,
    buf_close_btn = false
  },
  statusline = {
    enabled = true,
    theme = "vscode_colored",
    order = vim.g.is_firenvim
        and { "mode", "firefile", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd", "cursor" }
      or { "mode", "file", "git_branch", "diagnostics", "context", "%=", "lsp_msg", "%=", "git_status", "cursor", "lsp", "cwd" },
    modules = {
      closer = "%#St_file#%#St_file_sep#" .. "",
      context = " %{%v:lua.require'nvim-navic'.get_location()%}",
      firefile = function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        local filename = vim.fn.fnamemodify(buf_name, ":t")
        local extension = vim.fn.fnamemodify(buf_name, ":e")

        local icon, _ = require("nvim-web-devicons").get_icon(filename, extension, { default = true })

        local clean_name = filename:gsub("^www%.", "")

        clean_name = clean_name:match "^([^._%-]+)" or clean_name

        if #clean_name > 10 then
          clean_name = clean_name:sub(1, 10) .. "..."
        end

        local name = " " .. clean_name .. " "
        return "%#St_file# " .. icon .. name .. "%#St_file_sep#"
      end,
    },
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
