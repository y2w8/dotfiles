local catppuccin = require "custom.catppuccin.header"

return {
  {
    dir = "~/Projects/Nvim_Plugins/ui",
    lazy = false,
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    version = "*",
    config = function()
      vim.opt.termguicolors = true
      require("bufferline").setup {
        options = {
          themable = true,
          indicator = {
            style = "none",
          },

          tab_size = 6,
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          diagnostics_update_on_event = true, -- use nvim's diagnostic handler
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon
            if level == "error" then
              icon = " "
            elseif level == "warning" then
              icon = " "
            elseif level == "info" then
              icon = " "
            elseif level == "hint" then
              icon = " "
            end
            return icon .. count
          end,
          show_buffer_close_icons = false,
          separator_style = { "", "" },
        },
        highlights = {
            trunc_marker = {
                bg = catppuccin.base_30.darker_black,
            },
            modified = {
                fg = catppuccin.palette.green,
                bg = catppuccin.base_30.darker_black,
            },
            modified_visible = {
                fg = catppuccin.palette.green,
                bg = catppuccin.base_30.black2,
            },
            modified_selected = {
                fg = catppuccin.palette.green,
                bg = catppuccin.base_30.black2,
            },
            fill = {
                bg = catppuccin.base_30.darker_black,
            },
            indicator_selected = {
                bg = catppuccin.base_30.darker_black,
            },
            background = {
                bg = catppuccin.base_30.darker_black,
            },
            tab = {
                bg = catppuccin.base_30.darker_black,
            },
            tab_selected = {
                fg = catppuccin.base_30.darker_black,
                bg = catppuccin.palette.rosewater,
            },
            tab_close = {
                fg = catppuccin.base_30.darker_black,
                bg = catppuccin.palette.red,
            },

          buffer_visible = {
            bg = catppuccin.base_30.black2,
          },
          buffer_selected = {
            bg = catppuccin.base_30.black2,
            bold = true,
            italic = true,
          },
          warning_selected = {
            bg = catppuccin.base_30.black2,
            fg = catppuccin.palette.yellow,
            bold = true,
            italic = true,
          },
          warning_visible = {
            bg = catppuccin.base_30.black2,
            bold = true,
            italic = true,
          },
          warning_diagnostic = {
            bg = catppuccin.base_30.darker_black,
            fg = catppuccin.palette.yellow,
          },
          warning_diagnostic_selected = {
            bg = catppuccin.base_30.black2,
            fg = catppuccin.palette.yellow,
            bold = true,
            italic = true,
          },
          warning_diagnostic_visible = {
            bg = catppuccin.base_30.black2,
            fg = catppuccin.palette.yellow,
            bold = true,
            italic = true,
          },

          error_selected = {
            bg = catppuccin.base_30.black2,
            fg = catppuccin.palette.red,
            bold = true,
            italic = true,
          },
          error_visible = {
            bg = catppuccin.base_30.black2,
            bold = true,
            italic = true,
          },
          error_diagnostic = {
            bg = catppuccin.base_30.darker_black,
            fg = catppuccin.palette.red,
          },
          error_diagnostic_selected = {
            bg = catppuccin.base_30.black2,
            fg = catppuccin.palette.red,
            bold = true,
            italic = true,
          },
          error_diagnostic_visible = {
            bg = catppuccin.base_30.black2,
            fg = catppuccin.palette.red,
            bold = true,
            italic = true,
          },

          info_selected = {
            bg = catppuccin.base_30.black2,
            fg = catppuccin.palette.green,
            bold = true,
            italic = true,
          },
          info_visible = {
            bg = catppuccin.base_30.black2,
            bold = true,
            italic = true,
          },
          info_diagnostic = {
            bg = catppuccin.base_30.darker_black,
            fg = catppuccin.palette.green,
          },
          info_diagnostic_selected = {
            bg = catppuccin.base_30.black2,
            fg = catppuccin.palette.green,
            bold = true,
            italic = true,
          },
          info_diagnostic_visible = {
            bg = catppuccin.base_30.black2,
            fg = catppuccin.palette.green,
            bold = true,
            italic = true,
          },

          hint_selected = {
            bg = catppuccin.base_30.black2,
            fg = catppuccin.palette.mauve,
            bold = true,
            italic = true,
          },
          hint_visible = {
            bg = catppuccin.base_30.black2,
            bold = true,
            italic = true,
          },
          hint_diagnostic = {
            bg = catppuccin.base_30.darker_black,
            fg = catppuccin.palette.mauve,
          },
          hint_diagnostic_selected = {
            bg = catppuccin.base_30.black2,
            fg = catppuccin.palette.mauve,
            bold = true,
            italic = true,
          },
          hint_diagnostic_visible = {
            bg = catppuccin.base_30.black2,
            fg = catppuccin.palette.mauve,
            bold = true,
            italic = true,
          },
        },
      }
    end,
  },

  {
    "tiagovla/scope.nvim",
    event = "VeryLazy",
    config = function()
      require("scope").setup {}
    end,
  },

  -- TODO: remove
  -- { "typicode/bg.nvim", lazy = false },

  {
    "SmiteshP/nvim-navic",
    lazy = false,
    config = function()
      local navic = require "nvim-navic"
      navic.setup {
        highlight = true,
        separator = " > ",
        depth_limit = 0,
        depth_limit_message = "..",
        lsp = {
          auto_attach = true,
        },
      }
    end,
  },

  -- TODO: remove
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

  { "folke/todo-comments.nvim", event = "VeryLazy", opts = require "configs.extra.todo-comments" },

  { "nvzone/volt", lazy = true },

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
