require "nvchad.autocmds"


-- Firenvim
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "www.markdowntopdf.com_*.txt",
  command = "set filetype=markdown",
})

vim.api.nvim_create_autocmd({ "UIEnter" }, {
  callback = function(event)
    local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
    if client ~= nil and client.name == "Firenvim" then
      vim.o.laststatus = 3
      vim.o.guifont = "JetBrainsMono Nerd Font:h10"
      vim.o.linespace = -2
      require("base46").load_all_highlights()
    end
  end,
})

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "markdown", "md" },
--   callback = function()
--     -- fold all headings by default
--     vim.opt_local.foldmethod = "expr"
--     vim.opt_local.foldexpr = "v:lua.MarkdownFoldExpr(v:lnum)"
--     vim.opt_local.foldenable = true
--     vim.opt_local.foldlevel = 0    -- fold everything initially
--     vim.opt_local.foldlevelstart = 0
--   end,
-- })
--
-- function MarkdownFoldExpr(lnum)
--   local line = vim.fn.getline(lnum)
--   if line:match("^#") then
--     local level = #line:match("^(#+)")
--     return ">" .. level
--   end
--   return "="
-- end
