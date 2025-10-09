return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  opts = {
    flavour = "mocha",
    integrations = {
      aerial = true,
      alpha = true,
      cmp = true,
      dashboard = false,
      flash = true,
      fzf = true,
      grug_far = true,
      gitsigns = true,
      headlines = true,
      illuminate = true,
      indent_blankline = { enabled = true },
      leap = true,
      lsp_trouble = true,
      mason = true,
      markdown = true,
      mini = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      navic = { enabled = true, custom_bg = "lualine" },
      neotest = true,
      neotree = true,
      noice = true,
      notify = true,
      semantic_tokens = true,
      snacks = true,
      syntax = true,
      telescope = true,
      treesitter = true,
      treesitter_context = true,
      which_key = true,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    local palette = require("catppuccin.palettes").get_palette("mocha")
    vim.g.catppuccin_colors = palette
    vim.cmd.colorscheme("catppuccin-mocha") -- أو "catppuccin-mocha"
    vim.cmd([[highlight FloatBorder guifg=#f5e0dc ]]) -- Set your desired border color
  end,
  specs = {
    {
      "akinsho/bufferline.nvim",
      optional = true,
      opts = function(_, opts)
        if (vim.g.colors_name or ""):find("catppuccin") then
          opts.highlights = require("catppuccin.special.bufferline").get_theme()
        end
      end,
    },
  },
}
