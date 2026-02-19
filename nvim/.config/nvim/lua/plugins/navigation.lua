return {
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
    "stevearc/oil.nvim",
    lazy = false,
    opts = {},
    config = function()
      require "configs.oil"
    end,
    dependencies = { "nvim-tree/nvim-web-devicons", "JezerM/oil-lsp-diagnostics.nvim", "benomahony/oil-git.nvim" }, -- use if you prefer nvim-web-devicons
  },

  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    opts = function()
      require "configs.navigation.yazi"
    end,
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = function()
      require "configs.navigation.flash"
    end,
  },

  { "folke/edgy.nvim", event = "VeryLazy", opts = {} },
  { "mrjones2014/smart-splits.nvim" },
  {
    -- dir = "~/Projects/Nvim_Plugins/zellij.nvim",
    -- name = "zellij.nvim",
    "y2w8/zellij.nvim",
    event = "VeryLazy",
    opts = function()
      require "configs.navigation.zellij"
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
