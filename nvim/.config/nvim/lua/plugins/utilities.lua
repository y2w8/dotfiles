return {
  -- {
  --   "akinsho/toggleterm.nvim",
  --   lazy = false,
  --   config = function()
  --     require "configs.utilities.toggleterm"
  --   end,
  -- },
  { import = "configs.extra.dial" },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup {
        preset = "classic",
        transparent_bg = false,
        options = {
          add_messages = {
            display_count = true,
          },
          multilines = {
            enabled = true,
          },
        },
      }
      vim.diagnostic.config { virtual_text = false } -- Disable Neovim's default virtual text diagnostics
    end,
  },

  -- TODO: remove
  {
    "nosduco/remote-sshfs.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    opts = {},
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = function()
      require "configs.persistence"
    end,
  },

  -- FIX: this
  {
    "glacambre/firenvim",
    lazy = false,
    build = ":call firenvim#install(0)",
  },

  {
    "Cartoone9/pretty-comment.nvim",
    keys = {
      { "gcb", ":CommentBox<CR>", mode = "v", desc = "Comment box", silent = true },
      { "gcb", "<cmd>CommentBox<CR>", mode = "n", desc = "Comment box (line)", silent = true },
      { "gcB", ":CommentBoxFat<CR>", mode = "v", desc = "Fat comment box", silent = true },
      { "gcB", "<cmd>CommentBoxFat<CR>", mode = "n", desc = "Fat comment box (line)", silent = true },
      { "gcl", ":CommentLine<CR>", mode = "v", desc = "Centered title line", silent = true },
      { "gcl", "<cmd>CommentLine<CR>", mode = "n", desc = "Centered title line (line)", silent = true },
      { "gcL", ":CommentLineFat<CR>", mode = "v", desc = "Fat centered title line", silent = true },
      { "gcL", "<cmd>CommentLineFat<CR>", mode = "n", desc = "Fat centered title line (line)", silent = true },
      { "gcs", "<cmd>CommentSep<CR>", mode = "n", desc = "Comment separator", silent = true },
      { "gcS", "<cmd>CommentSepFat<CR>", mode = "n", desc = "Fat comment separator", silent = true },
      { "gcd", "<cmd>CommentDiv<CR>", mode = "n", desc = "Comment divider", silent = true },
      { "gcD", "<cmd>CommentDivFat<CR>", mode = "n", desc = "Fat comment divider", silent = true },
      { "gcr", ":CommentRemove<CR>", mode = "v", desc = "Strip comment decoration", silent = true },
      { "gcr", "<cmd>CommentRemove<CR>", mode = "n", desc = "Strip comment decoration (line)", silent = true },
      { "gce", ":CommentEqualize<CR>", mode = "v", desc = "Equalize comment decoration (selection)", silent = true },
      { "gce", "<cmd>CommentEqualize<CR>", mode = "n", desc = "Equalize all comment decoration", silent = true },
      { "gcx", "<cmd>CommentReset<CR>", mode = "n", desc = "Reset comment width tracking", silent = true },
    },
    init = function()
      vim.keymap.set("x", "gcc", function()
        return require("vim._comment").operator()
      end, { expr = true, desc = "Comment toggle (instant, avoids gc delay)" })
    end,
    config = function(_, opts)
      require("pretty-comment").setup(opts)
    end,
    opts = {},
  },

  {
    "necrom4/calcium.nvim",
    cmd = { "Calcium" },
    opts = {
      notifications = true,
      default_mode = "replace",
      scratchpad = {
        border = "rounded",
        virtual_text = {
          format = "= %s",
          highlight_group = "Comment",
        },
        result_variable = "ans",
      },
    },
    keys = {
      {
        "<leader>C",
        ":Calcium<CR>",
        desc = "Calculate replace",
        mode = { "n", "v" },
        silent = true,
      },
      {
        "<leader>cc",
        ":Calcium scratchpad<CR>",
        desc = "Calculate scratchpad",
        mode = { "n", "v" },
        silent = true,
      },
    },
  },

  {
    "roobert/search-replace.nvim",
    event = "VeryLazy",
    config = function()
      require "configs.utilities.search-replace"
    end,
  },
}
