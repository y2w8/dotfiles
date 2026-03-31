return {
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      -- "sindrets/diffview.nvim", -- optional - Diff integration
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gG", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    },
    config = function()
      require "configs.git.neogit"
    end
  },

  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    opts = { picker = "telescope", enable_builtin = true },
    config = function()
      require "configs.git.octo"
    end,
  },
}
