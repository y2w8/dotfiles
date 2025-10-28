return {
  "CRAG666/betterTerm.nvim",
  opts = {
    prefix = "Term_",
    index_base = 1,
    startInserted = false,
    position = "right",
    size = 20,
    jump_tab_mapping = "<A-$tab>",
  },
  keys = {
    {
      mode = { "n", "t" },
      "<C-;>",
      function()
        require("betterTerm").open()
      end,
      desc = "Toggle terminal",
    },
    {
      mode = { "n", "t" },
      "<C-/>",
      function()
        require("betterTerm").open(1)
      end,
      desc = "Toggle terminal 1",
    },
    {
      "<leader>tt",
      function()
        require("better").select()
      end,
      desc = "Select terminal",
    },
    {
      "<leader>tr",
      function()
        require("betterTerm").rename()
      end,
      desc = "Rename terminal",
    },
    {
      "<leader>tb",
      function()
        require("betterTerm").toggle_tabs()
      end,
      desc = "Toggle terminal tabs",
    },
  },
}
