return {
  {
    -- "breiting/zettel.nvim",
    dir = "~/Projects/Nvim_Plugins/zettel.nvim",
    lazy = false,
    config = function()
      require("zettel").setup {
        vault_dir = "~/Documents/zettel",
        note_types = { "note", "journal", "meeting", "meta", "project" },
        assets_dir = "_assets",
        templates_dir = "_templates",
      }
    end,
  },

  -- TODO: remove
  {
    "yousefhadder/markdown-plus.nvim",
    ft = "markdown",
    opts = {
      -- Your custom configuration here
    },
  },

  -- TODO: remove
  -- {
  --   enabled = true,
  --   "iamcco/markdown-preview.nvim",
  --   ft = { "markdown" },
  --   keys = {
  --     {
  --       "<leader>mp",
  --       ft = "markdown",
  --       "<cmd>MarkdownPreviewToggle<cr>",
  --       desc = "Markdown Preview",
  --     },
  --   },
  --   build = "cd app && npm install",
  --   init = function()
  --     -- The default filename is 「${name}」and I just hate those symbols
  --     vim.g.mkdp_page_title = "${name}"
  --     vim.g.mkdp_filetypes = { "markdown" }
  --     vim.g.mkdp_markdown_css = "/home/y2w8/.config/nvim/lua/custom/markdown.css"
  --   end,
  -- },
  {
    dir = "/home/y2w8/Projects/Contribute/markdown-preview.nvim",
    -- "selimacerbas/markdown-preview.nvim",
    ft = { "markdown" },
    dependencies = { "selimacerbas/live-server.nvim" },
    config = function()
      require("markdown_preview").setup {
        -- all optional; sane defaults shown
        instance_mode = "takeover", -- "takeover" (one tab) or "multi" (tab per instance)
        port = 0, -- 0 = auto (8421 for takeover, OS-assigned for multi)
        open_browser = true,
        debounce_ms = 300,
        custom_css = "/home/y2w8/.config/nvim/lua/custom/markdown.css"
      }
    end,
    keys = {
      {
        "<leader>mp",
        ft = "markdown",
        "<cmd>MarkdownPreview<cr>",
        desc = "Markdown Preview",
      },
      {
        "<leader>ms",
        ft = "markdown",
        "<cmd>MarkdownPreviewStop<cr>",
        desc = "Markdown Preview Stop",
      },
      {
        "<leader>mr",
        ft = "markdown",
        "<cmd>MarkdownPreviewRefresh<cr>",
        desc = "Markdown Preview Refresh",
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    -- event = "VeryLazy",
    ft = { "markdown", "octo" },
    enabled = true,
    -- Moved highlight creation out of opts as suggested by plugin maintainer
    -- There was no issue, but it was creating unnecessary noise when ran
    -- :checkhealth render-markdown
    -- https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/138#issuecomment-2295422741
    opts = {
      render_modes = true,
      file_types = { "markdown", "octo" },
      bullet = {
        -- Turn on / off list bullet rendering
        enabled = true,
      },
      checkbox = {
        -- Turn on / off checkbox state rendering
        enabled = true,
        -- Determines how icons fill the available space:
        --  inline:  underlying text is concealed resulting in a left aligned icon
        --  overlay: result is left padded with spaces to hide any additional text
        position = "inline",
        unchecked = {
          -- Replaces '[ ]' of 'task_list_marker_unchecked'
          icon = "󰄱 ",
          -- Highlight for the unchecked icon
          highlight = "RenderMarkdownUnchecked",
          -- Highlight for item associated with unchecked checkbox
          scope_highlight = nil,
        },
        checked = {
          -- Replaces '[x]' of 'task_list_marker_checked'
          icon = "󰱒 ",
          -- Highlight for the checked icon
          highlight = "RenderMarkdownChecked",
          -- Highlight for item associated with checked checkbox
          scope_highlight = "@markup.strikethrough",
        },

        custom = {
          todo = { raw = "[-]", rendered = "󰥔 ", highlight = "@markup.list.todo", scope_highlight = nil },
          blocked = {
            highlight = "RenderMarkdownWarn",
            raw = "[!]",
            rendered = " ",
          },
          cancelled = {
            highlight = "RenderMarkdownError",
            raw = "[~]",
            rendered = "󰜺 ",
          },
        },
      },
      html = {
        -- Turn on / off all HTML rendering
        enabled = true,
        comment = {
          -- Turn on / off HTML comment concealing
          conceal = false,
        },
      },
      -- Add custom icons lamw26wmal
      link = {
        -- image = vim.g.neovim_mode == "skitty" and "" or "󰥶 ",
        custom = {
          youtu = { pattern = "youtu%.be", icon = "󰗃 " },
        },
      },
      heading = {
        sign = false,
        border = true,
        width = "block",
        position = "left",
        left_pad = 0,
        right_pad = 4,
        below = "",
        above = "",
        icons = {
          "█ ",
          "██ ",
          "███ ",
          "████ ",
          "█████ ",
          "██████ ",
        },
        -- icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
        backgrounds = {
          "@markup.heading.1.markdown",
          "@markup.heading.2.markdown",
          "@markup.heading.3.markdown",
          "@markup.heading.4.markdown",
          "@markup.heading.5.markdown",
          "@markup.heading.6.markdown",
        },
        foregrounds = {
          "@markup.heading.1.markdown",
          "@markup.heading.2.markdown",
          "@markup.heading.3.markdown",
          "@markup.heading.4.markdown",
          "@markup.heading.5.markdown",
          "@markup.heading.6.markdown",
        },
      },
      completions = { lsp = { enabled = true } },
      latex = {
        enabled = true,
        converter = { "utftex" },
        -- highlight = "RenderMarkdownMath",
        position = "above",
        -- top_pad = 0,
        -- bottom_pad = 0,
      },
      pipe_table = { preset = "heavy" },
      code = {
        position = "left",
        width = "block",
        border = "thin",
        language_left = "█",
        language_right = "█",
        language_border = "█",
        above = "",
        below = "",
        left_pad = 2,
        right_pad = 14,
        inline_left = "█",
        inline_right = "█",
      },
      callout = {
        note = {
          raw = "[!NOTE]",
          rendered = "󰋽 Note",
          highlight = "RenderMarkdownInfo",
          category = "github",
        },
        tip = {
          raw = "[!TIP]",
          rendered = "󰌶 Tip",
          highlight = "RenderMarkdownSuccess",
          category = "github",
        },
        important = {
          raw = "[!IMPORTANT]",
          rendered = "󰅾 Important",
          highlight = "RenderMarkdownHint",
          category = "github",
        },
        warning = {
          raw = "[!WARNING]",
          rendered = "󰀪 Warning",
          highlight = "RenderMarkdownWarn",
          category = "github",
        },
        caution = {
          raw = "[!CAUTION]",
          rendered = "󰳦 Caution",
          highlight = "RenderMarkdownError",
          category = "github",
        },
        abstract = {
          raw = "[!ABSTRACT]",
          rendered = "󰨸 Abstract",
          highlight = "RenderMarkdownInfo",
          category = "obsidian",
        },
        summary = {
          raw = "[!SUMMARY]",
          rendered = "󰨸 Summary",
          highlight = "RenderMarkdownInfo",
          category = "obsidian",
        },
        tldr = {
          raw = "[!TLDR]",
          rendered = "󰨸 Tldr",
          highlight = "RenderMarkdownInfo",
          category = "obsidian",
        },
        info = {
          raw = "[!INFO]",
          rendered = "󰋽 Info",
          highlight = "RenderMarkdownInfo",
          category = "obsidian",
        },
        todo = {
          raw = "[!TODO]",
          rendered = "󰗡 Todo",
          highlight = "RenderMarkdownInfo",
          category = "obsidian",
        },
        hint = {
          raw = "[!HINT]",
          rendered = "󰌶 Hint",
          highlight = "RenderMarkdownSuccess",
          category = "obsidian",
        },
        success = {
          raw = "[!SUCCESS]",
          rendered = "󰄬 Success",
          highlight = "RenderMarkdownSuccess",
          category = "obsidian",
        },
        check = {
          raw = "[!CHECK]",
          rendered = "󰄬 Check",
          highlight = "RenderMarkdownSuccess",
          category = "obsidian",
        },
        done = {
          raw = "[!DONE]",
          rendered = "󰄬 Done",
          highlight = "RenderMarkdownSuccess",
          category = "obsidian",
        },
        question = {
          raw = "[!QUESTION]",
          rendered = "󰘥 Question",
          highlight = "RenderMarkdownWarn",
          category = "obsidian",
        },
        help = {
          raw = "[!HELP]",
          rendered = "󰘥 Help",
          highlight = "RenderMarkdownWarn",
          category = "obsidian",
        },
        faq = {
          raw = "[!FAQ]",
          rendered = "󰘥 Faq",
          highlight = "RenderMarkdownWarn",
          category = "obsidian",
        },
        attention = {
          raw = "[!ATTENTION]",
          rendered = "󰀪 Attention",
          highlight = "RenderMarkdownWarn",
          category = "obsidian",
        },
        failure = {
          raw = "[!FAILURE]",
          rendered = "󰅖 Failure",
          highlight = "RenderMarkdownError",
          category = "obsidian",
        },
        fail = {
          raw = "[!FAIL]",
          rendered = "󰅖 Fail",
          highlight = "RenderMarkdownError",
          category = "obsidian",
        },
        missing = {
          raw = "[!MISSING]",
          rendered = "󰅖 Missing",
          highlight = "RenderMarkdownError",
          category = "obsidian",
        },
        danger = {
          raw = "[!DANGER]",
          rendered = "󱐌 Danger",
          highlight = "RenderMarkdownError",
          category = "obsidian",
        },
        error = {
          raw = "[!ERROR]",
          rendered = "󱐌 Error",
          highlight = "RenderMarkdownError",
          category = "obsidian",
        },
        bug = {
          raw = "[!BUG]",
          rendered = "󰨰 Bug",
          highlight = "RenderMarkdownError",
          category = "obsidian",
        },
        example = {
          raw = "[!EXAMPLE]",
          rendered = "󰉹 Example",
          highlight = "RenderMarkdownHint",
          category = "obsidian",
        },
        quote = {
          raw = "[!QUOTE]",
          rendered = "󱆨 Quote",
          highlight = "RenderMarkdownQuote",
          category = "obsidian",
        },
        cite = {
          raw = "[!CITE]",
          rendered = "󱆨 Cite",
          highlight = "RenderMarkdownQuote",
          category = "obsidian",
        },
      },
    },
  },
}
