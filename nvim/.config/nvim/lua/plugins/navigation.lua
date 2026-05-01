return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "ghassan0/telescope-glyph.nvim",
      "debugloop/telescope-undo.nvim",
      "smartpde/telescope-recent-files",
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension "fzf"
        end,
      },
    },
    cmd = "Telescope",
    opts = function()
      return require "configs.telescope"
    end,
  },

  -- TODO: winbar path better
  {
    "barrettruth/canola.nvim",
    lazy = false,
    opts = {},
    config = function()
      require "configs.oil"
    end,
    dependencies = { "nvim-tree/nvim-web-devicons", "JezerM/oil-lsp-diagnostics.nvim", "malewicz1337/oil-git.nvim" }, -- use if you prefer nvim-web-devicons
  },

  -- TODO: keymaping
  {
    "ankushbhagats/match.nvim",
    config = true,
    cmd = {"Match", "MatchWord", "MatchLine"};
  },

  {
    dir = "~/Projects/Nvim_Plugins/neolij.nvim",
    -- "y2w8/neolij.nvim",
    event = "VeryLazy",
    opts = function()
      require "configs.navigation.neolij"
    end,
  },

  {
    "chrisgrieser/nvim-origami",
    event = "VeryLazy",
    opts = {},
    config = function()
      require "configs.navigation.origami"
    end,
    -- recommended: disable vim's auto-folding
    init = function()
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end,
  },
}
