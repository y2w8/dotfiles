return {
  -- NOTE: No need i added shader for cursor in ghostty config.
  -- {
  --   "sphamba/smear-cursor.nvim",
  --   lazy = false,
  --   enabled = true,
  --   opts = require "configs.cursor",
  -- },

  {
    dir = "~/Projects/Nvim_Plugins/ui",
    lazy = false
  },

  { "typicode/bg.nvim", lazy = false },

  {
    "SmiteshP/nvim-navic",
    lazy = false,
    config = function()
      local navic = require("nvim-navic")
      navic.setup {
        highlight = true, -- تفعيل الألوان
        separator = " > ",
        depth_limit = 0,
        depth_limit_message = "..",
        lsp = {
          auto_attach = true,
        }
      }
    end,
  },

  {
    "wr9dg17/essential-term.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("essential-term").setup {
        display_mode = "horizontal", -- or "vertical" or "float"
        size = 70, -- percentage of editor height/width
      }
    end,
    keys = {
      { "<C-`>", "<cmd>EssentialTermToggle<cr>", mode = { "n", "t" } },
      { "<C-\\>", "<cmd>EssentialTermToggle<cr>", mode = { "n", "t" } },
      { "<C-t>", "<cmd>EssentialTermNew<cr>", mode = { "n", "t" } },
      { "<C-z>", "<cmd>EssentialTermClose<cr>", mode = { "n", "t" } },
    },
  },

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
    enabled = not vim.g.is_firenvim,
    event = "VeryLazy",
    build = ":Cord update",
  },
}
