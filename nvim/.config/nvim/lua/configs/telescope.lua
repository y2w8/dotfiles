dofile(vim.g.base46_cache .. "telescope")
require('telescope').load_extension('glyph')
-- local previewers = require "telescope.previewers"
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "telescope find lsp symbols" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope lsp_references<CR>", { desc = "telescope find lsp references" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help Pages" })
vim.keymap.set("n", "<leader>fm", "<cmd>Telescope man_pages<CR>", { desc = "Man Pages" })
vim.keymap.set("n", "<leader>fH", "<cmd>Telescope highlights<CR>", { desc = "Highlight" })
vim.keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })
vim.keymap.set("n", "<leader>fi", "<cmd>Telescope glyph<CR>", { desc = "Icons" })
-- vim.keymap.set("n", "<leader>fH", "<cmd>Telescope highlight<CR>", { desc = "Highlight" })
-- vim.keymap.set("n", "<leader>fH", "<cmd>Telescope highlight<CR>", { desc = "Highlight" })
vim.keymap.set("n", "<leader>ft", "<cmd>Telescope<CR>", { desc = "Builtin" })

return {
  defaults = {
    prompt_prefix = "   ",
    selection_caret = " ",
    entry_prefix = " ",
    sorting_strategy = "ascending",

    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
      },
      width = 0.87,
      height = 0.80,
    },
    mappings = {
      n = { ["q"] = require("telescope.actions").close },
    },
  },
  -- pickers = {
  --   live_grep = {
  --     previewer = previewers.vim_buffer_cat.new, -- for grep specifically
  --   },
  --   grep_string = {
  --     previewer = previewers.vim_buffer_cat.new,
  --   },
  -- },
  extensions_list = { "themes", "terms" },
  extensions = {},
}


