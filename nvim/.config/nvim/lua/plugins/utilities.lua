return {
  -- {
  --   "akinsho/toggleterm.nvim",
  --   lazy = false,
  --   config = function()
  --     require "configs.utilities.toggleterm"
  --   end,
  -- },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = function()
      require "configs.persistence"
    end,
  },
  {
    name = "notes.nvim",
    "y2w8/notes.nvim",
    event = "VeryLazy",
    opts = { pkm_dir = "/home/y2w8/Documents/notes" },
    keys = {
      {
        mode = "n",
        "<leader>nw",
        function()
          require("notes").workspace_note()
        end,
        desc = "Open workspace note",
      },
      {
        mode = "n",
        "<leader>nW",
        function()
          require("notes").workspace_note(true)
        end,
        desc = "Open workspace note float",
      },
    },
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>i", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  },
  {
    "glacambre/firenvim",
    lazy = false,
    build = ":call firenvim#install(0)",
  },

  {
    "itchyny/calendar.vim",
    lazy = false,
    -- cmd = "Calendar",
    config = function()
      require "configs.utilities.calender"
    end,
  },

  {
    -- 'quiet-ghost/cht-sh.nvim',
    dir = "~/Projects/Contribute/cht-sh.nvim",
    lazy = false,
    -- cmd = { "ChtSh", "ChtShLang", "ChtShWord" },
    config = function()
      require "configs.utilities.cht-sh"
    end,
  },
  {
    "roobert/search-replace.nvim",
    event = "VeryLazy",
    config = function()
      require "configs.utilities.search-replace"
    end,
  },
}
