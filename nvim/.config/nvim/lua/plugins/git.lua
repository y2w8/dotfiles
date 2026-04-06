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
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    },
    config = function()
      require "configs.git.neogit"
    end,
  },

  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    opts = { picker = "telescope", enable_builtin = true },
    config = function()
      require "configs.git.octo"
    end,
  },

  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
  },

  {
    "akinsho/git-conflict.nvim",
    version = "*",
    lazy = false,
    config = {
      default_mappings = true, -- disable buffer local mapping created by this plugin
      default_commands = true, -- disable commands created by this plugin
      disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
      list_opener = "copen", -- command or function to open the conflicts list
      highlights = { -- They must have background color, otherwise the default color will be used
        incoming = "DiffAdd",
        current = "DiffText",
      },
    },
  },
}
