-- vim.keymap.set("n", "zc", function()
--   require("origami").h()
-- end, { desc = "Fold" })
--
-- vim.keymap.set("n", "zo", function()
--   require("origami").l()
-- end, { desc = "Unfold" })
--
-- vim.keymap.set("n", "zo", function()
--   require("origami").l()
-- end, { desc = "Unfold" })
--
-- vim.keymap.set("n", "z^", function()
--   require("origami").caret()
-- end, { desc = "FoldAll" })
--
-- vim.keymap.set("n", "z$", function()
--   require("origami").dollar()
-- end, { desc = "UnfoldAll" })

-- default settings
require("origami").setup {
  useLspFoldsWithTreesitterFallback = { enabled = true },
  pauseFoldsOnSearch = true,
  foldtext = {
    enabled = true,
    padding = 3,
    lineCount = {
      template = "󰘖 %d", -- `%d` is replaced with the number of folded lines
      hlgroup = "Comment",
    },
    diagnosticsCount = true, -- uses hlgroups and icons from `vim.diagnostic.config().signs`
    gitsignsCount = true, -- requires `gitsigns.nvim`
    disableOnFt = { "snacks_picker_input" }, ---@type string[]
  },
  autoFold = {
    enabled = false,
    kinds = { "comment", "imports" }, ---@type lsp.FoldingRangeKind[]
  },
  foldKeymaps = {
    setup = false, -- modifies `h`, `l`, and `$`
    closeOnlyOnFirstColumn = false,
  },
}
