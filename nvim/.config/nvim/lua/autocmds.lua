require "nvchad.autocmds"

vim.api.nvim_create_autocmd({'BufEnter'}, {
    pattern = "www.markdowntopdf.com_*.txt",
    command = "set filetype=markdown"
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
