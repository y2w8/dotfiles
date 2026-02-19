return {
  -- NOTE: No need i added shader for cursor in ghostty config.
  -- {
  --   "sphamba/smear-cursor.nvim",
  --   lazy = false,
  --   enabled = true,
  --   opts = require "configs.cursor",
  -- },

  {
    "j-hui/fidget.nvim",
    lazy = false,
    -- version = "*", -- alternatively, pin this to a specific version, e.g., "1.6.1"
    config = function()
      require "configs.fidget"
    end,
  },

  {
    "hedyhli/outline.nvim",
    cmd = "Outline",
    config = function()
      vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
      require("outline").setup {}
    end,
  },

  { "folke/todo-comments.nvim", event = "VeryLazy", opts = require "configs.extra.todo-comments" },

  {
    "nvzone/minty",
    cmd = { "Shades", "Huefy" },
  },

  { "nvzone/volt", lazy = true },

  { "nvzone/menu", lazy = true },

  {
    "gisketch/triforce.nvim",
    event = "VeryLazy",
    config = function()
      require("triforce").setup {
        keymap = {
          show_profile = "<leader>tp",
        },
      }
    end,
  },

  -- Discord RPC
  {
    "vyfor/cord.nvim",
    event = "VeryLazy",
    build = ":Cord update",
  },
}
