return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },
  { "itchyny/calendar.vim" },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    opts = {
      picker = "telescope",
      enable_builtin = true,
    },
    config = function()
      require "configs.octo"
    end,
    keys = {
      {
        "<leader>gi",
        "<CMD>Octo issue list<CR>",
        desc = "List GitHub Issues",
      },
      {
        "<leader>gp",
        "<CMD>Octo pr list<CR>",
        desc = "List GitHub PullRequests",
      },
      {
        "<leader>gd",
        "<CMD>Octo discussion list<CR>",
        desc = "List GitHub Discussions",
      },
      {
        "<leader>gn",
        "<CMD>Octo notification list<CR>",
        desc = "List GitHub Notifications",
      },
      {
        "<leader>gf",
        function()
          require("octo.utils").create_base_search_command { include_current_repo = true }
        end,
        desc = "Search GitHub",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      -- "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed.
      "nvim-telescope/telescope.nvim", -- optional
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gG", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      dir = vim.fn.stdpath "state" .. "/sessions/", -- directory where session files are saved
      -- minimum number of file buffers that need to be open to save
      -- Set to 0 to always save
      need = 1,
      branch = true, -- use git branch to save session
    },
    keys = {
      {
        mode = "n",
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Load session for current dir",
      },
      {
        mode = "n",
        "<leader>qS",
        function()
          require("persistence").select()
        end,
        desc = "Select session",
      },
      {
        mode = "n",
        "<leader>ql",
        function()
          require("persistence").load { last = true }
        end,
        desc = "Load last session",
      },
      {
        mode = "n",
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "dont save this session",
      },
    },
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
      -- {
      --   "fredrikaverpil/neotest-golang",
      --   build = function()
      --     vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait() -- Optional, but recommended
      --   end,
      -- },
    },
    config = function()
      require("neotest").setup {
        ---@diagnostic disable-next-line: missing-fields
        adapters = {
          require "rustaceanvim.neotest",
          -- require("neotest-golang")({
          --   runner = "gotestsum",
          -- }),
        },
      }
    end,
  },
  {
    "stevearc/oil.nvim",
    lazy = false,
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    config = function()
      require "configs.oil"
    end,
    dependencies = { "nvim-tree/nvim-web-devicons", "JezerM/oil-lsp-diagnostics.nvim", "benomahony/oil-git.nvim" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type flash.config
    opts = {},
    keys = {
      {
        "zk",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "flash",
      },
      {
        "Zk",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "flash treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "remote flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "treesitter search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "toggle flash search",
      },
    },
  },
  {
    "sphamba/smear-cursor.nvim",
    lazy = false,
    enabled = true,
    opts = require "configs.cursor",
  },
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
    "mrcjkb/rustaceanvim",
    ft = "rust",
    version = "^6", -- Recommended
    config = function()
      require "configs.rust"
    end,
    -- lazy = false, -- This plugin is already lazy
  },
  {
    "saecki/crates.nvim",
    tag = "stable",
    config = function()
      require("crates").setup()
    end,
  },
  -- These are some examples, uncomment them if you want to see them work!
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      servers = {},
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    config = function()
      require "configs.lsp"
    end,
  },
  { import = "nvchad.blink.lazyspec" },

  -- If you want to override blink config :
  {
    "Saghen/blink.cmp",
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          sql = { "snippets", "dadbod", "buffer" },
          mysql = { "snippets", "dadbod", "buffer" },
          postgresql = { "snippets", "dadbod", "buffer" },
        },
        -- add vim-dadbod-completion to your completion providers
        providers = {
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
          path = { opts = { show_hidden_files_by_default = true } },
        },
      },
      completion = {
        list = { selection = { preselect = false, auto_insert = true } },
      },
    },
  },
  {
    "windwp/nvim-autopairs",
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
      map_cr = true,
    },
  },
  {
    "hedyhli/outline.nvim",
    event = "VeryLazy",
    config = function()
      -- Example mapping to toggle outline
      vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })

      require("outline").setup {
        -- Your setup opts here (leave empty to use defaults)
      }
    end,
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   event = "InsertEnter",
  --   dependencies = {
  --     {
  --       -- snippet plugin
  --       "L3MON4D3/LuaSnip",
  --       dependencies = "rafamadriz/friendly-snippets",
  --       opts = { history = true, updateevents = "TextChanged,TextChangedI" },
  --       config = function(_, opts)
  --         require("luasnip").config.set_config(opts)
  --         require "nvchad.configs.luasnip"
  --       end,
  --     },
  --
  --     -- autopairing of (){}[] etc
  --     {
  --       "windwp/nvim-autopairs",
  --       opts = {
  --         fast_wrap = {},
  --         disable_filetype = { "TelescopePrompt", "vim" },
  --       },
  --       config = function(_, opts)
  --         require("nvim-autopairs").setup(opts)
  --
  --         -- setup cmp for autopairs
  --         local cmp_autopairs = require "nvim-autopairs.completion.cmp"
  --         require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
  --       end,
  --     },
  --
  --     -- cmp sources plugins
  --     {
  --       "saadparwaiz1/cmp_luasnip",
  --       "hrsh7th/cmp-nvim-lua",
  --       "hrsh7th/cmp-nvim-lsp",
  --       "hrsh7th/cmp-buffer",
  --       "https://codeberg.org/FelipeLema/cmp-async-path.git"
  --     }
  --   },
  --   opts = function()
  --     return require "nvchad.configs.cmp"
  --   end,
  -- },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "ghassan0/telescope-glyph.nvim",
      "debugloop/telescope-undo.nvim",
      "smartpde/telescope-recent-files",
    },
    cmd = "Telescope",
    opts = function()
      return require "configs.telescope"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "nvchad.configs.treesitter"
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
      },
    },
  },

  -- Discord RPC
  {
    "vyfor/cord.nvim",
    event = "VeryLazy",
    build = ":Cord update",
  },
}
