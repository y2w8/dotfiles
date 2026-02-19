return {
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    dependencies = {
      {
        "igorlfs/nvim-dap-view",
        opts = require "configs.dapview",
      },
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require "configs.dap"
    end,
  },

  {
    "nvim-neotest/neotest",
    keys = {
      { "<leader>mr", "<cmd>Neotest run<cr>" },
      { "<leader>ms", "<cmd>Neotest summary<cr>" },
      { "<leader>mo", "<cmd>Neotest output<cr>" },
      { "<leader>mp", "<cmd>Neotest output-panel<cr>" },
      {
        "<leader>md",
        function()
          require("neotest").run.run { suite = false, strategy = "dap" }
        end,
      },
    },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "rustaceanvim.neotest",
        },
      }
    end,
  },

  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = { "stevearc/overseer.nvim", "nvim-telescope/telescope.nvim" },
    opts = {},
  },

  {
    "stevearc/overseer.nvim",
    commit = "6271cab7ccc4ca840faa93f54440ffae3a3918bd",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1,
      },
    },
  },

  {
    "aznhe21/actions-preview.nvim",
    config = require "configs.extra.actions-preview",
  },
  {
    "rachartier/tiny-code-action.nvim",
    event = "LspAttach",
    opts = require "configs.tiny-code-actions",
  },
}
