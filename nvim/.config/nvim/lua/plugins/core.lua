return {
  -- .env LSP
  {
    "ph1losof/ecolog2.nvim",
    enabled = false,
    lazy = false,
    build = "cargo install ecolog-lsp",
    keys = {
      { "<leader>el", "<cmd>Ecolog list<cr>", desc = "List env variables" },
      { "<leader>ef", "<cmd>Ecolog files select<cr>", desc = "Select env file" },
      { "<leader>eo", "<cmd>Ecolog files open_active<cr>", desc = "Open active env file" },
      { "<leader>er", "<cmd>Ecolog refresh<cr>", desc = "Refresh env variables" },
    },
    config = function()
      require("ecolog").setup()
    end,
  },
  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      { "mason-org/mason.nvim", opts = {} },
    },
    config = function()
      require "configs.lsp"
    end,
  },

  -- Completion
  { import = "nvchad.blink.lazyspec" },
  {
    "Saghen/blink.cmp",
    dependencies = {
      { "MattiasMTS/cmp-dbee", ft = "sql", opts = {} },
      {
        "saghen/blink.compat",
        -- use v2.* for blink.cmp v1.*
        version = "2.*",
        -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
        lazy = false,
        -- make sure to set opts so that lazy.nvim calls blink.compat's setup
        opts = {},
      },
    },
    opts = {
      sources = {
        default = { "lsp", "dbee", "path", "snippets", "buffer" },
        per_filetype = {
          sql = { "dbee", "buffer" }, -- dadbod
          mysql = { "dbee", "buffer" }, --dadbod
          postgresql = { "dbee", "buffer" }, --dadbod
        },
        providers = {
          -- dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
          dbee = { name = "cmp-dbee", module = "blink.compat.source" },
          path = { opts = { show_hidden_files_by_default = true } },
        },
      },
    },
  },

  -- Syntax & Formatting
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "vim", "lua", "vimdoc", "html", "css", "all" },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
  },
  { "stevearc/conform.nvim", opts = require "configs.conform" },
  {
    "windwp/nvim-autopairs",
    opts = { fast_wrap = {}, map_cr = true, disable_filetype = { "TelescopePrompt", "vim" } },
  },
  { "RRethy/vim-illuminate" },
}
