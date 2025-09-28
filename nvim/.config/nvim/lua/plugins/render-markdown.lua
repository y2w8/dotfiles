return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},
  keys = {
    {
      "<leader>m",
      function()
        require("render-markdown").toggle()
      end,
      desc = "Render Markdown",
    },
  },
}
