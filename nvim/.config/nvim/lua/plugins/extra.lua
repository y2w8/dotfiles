---@diagnostic disable: undefined-field
return {
  -- FIX: TET
  -- TODO: TST
  -- HACK: EST
  -- WARN: TST
  -- PERF: TST
  -- NOTE: TST
  -- TEST: TST
  {
    "chrisgrieser/nvim-origami",
    event = "VeryLazy",
    opts = {}, -- needed even when using default config
    config = function()
      require "configs.extra.origami"
    end,
    -- recommended: disable vim's auto-folding
    init = function()
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end,
  },
  -- {
  --   "mistricky/codesnap.nvim",
  --   event = "VeryLazy",
  --   build = "make",
  --   config = function()
  --     require("codesnap").setup({
  --       watermark = "",
  --     })
  --   end,
  -- },
  {
    "j-hui/fidget.nvim",
    lazy = false,
    -- version = "*", -- alternatively, pin this to a specific version, e.g., "1.6.1"
    config = function()
      require "configs.fidget"
    end,
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      -- add options here
      -- or leave it empty to use the default settings
    },
    keys = {
      -- suggested keymap
      { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  },
  {
    "stevearc/quicker.nvim",
    ft = "qf",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },
  { import = "configs.extra.dial" },
  { "nvzone/volt", lazy = true },
  { "nvzone/menu", lazy = true },
  {
    "nvzone/minty",
    cmd = { "Shades", "Huefy" },
  },
  { "glacambre/firenvim", lazy = false, build = ":call firenvim#install(0)" },
  {
    "brianhuster/live-preview.nvim",
    cmd = "LivePreview",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = require "configs.snacks",
    keys = {
      {
        "<leader>z",
        function()
          Snacks.zen()
        end,
        desc = "Toggle Zen Mode",
      },
      {
        "<leader>Z",
        function()
          Snacks.zen.zoom()
        end,
        desc = "Toggle Zoom",
      },
      {
        "<leader>cR",
        function()
          Snacks.rename.rename_file()
        end,
        desc = "Rename File",
      },
      {
        "<leader>gB",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Git Browse",
        mode = { "n", "v" },
      },
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
      {
        "<c-/>",
        function()
          Snacks.terminal()
        end,
        desc = "Toggle Terminal",
      },
      {
        "<c-_>",
        function()
          Snacks.terminal()
        end,
        desc = "which_key_ignore",
      },
      {
        "<leader>N",
        desc = "Neovim News",
        function()
          Snacks.win {
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          }
        end,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end

          -- Override print to use snacks for `:=` command
          if vim.fn.has "nvim-0.11" == 1 then
            print = function(_, ...)
              dd(...)
            end
          else
            vim.print = _G.dd
          end

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map "<leader>us"
          Snacks.toggle.option("wrap", { name = "Wrap" }):map "<leader>uw"
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map "<leader>uL"
          Snacks.toggle.diagnostics():map "<leader>ud"
          Snacks.toggle.line_number():map "<leader>ul"
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map "<leader>uc"
          Snacks.toggle.treesitter():map "<leader>uT"
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map "<leader>ub"
          Snacks.toggle.inlay_hints():map "<leader>uh"
          Snacks.toggle.indent():map "<leader>ug"
          Snacks.toggle.dim():map "<leader>uD"
        end,
      })
    end,
  },
  {
    "roobert/search-replace.nvim",
    event = "VeryLazy",
    config = function()
      require("search-replace").setup {
        -- optionally override defaults
        default_replace_single_buffer_options = "gcI",
        default_replace_multi_buffer_options = "egcI",
      }

      vim.keymap.set("v", "<C-r>", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>")
      vim.keymap.set("v", "<C-s>", "<CMD>SearchReplaceWithinVisualSelection<CR>")
      vim.keymap.set("v", "<C-b>", "<CMD>SearchReplaceWithinVisualSelectionCWord<CR>")

      vim.keymap.set("n", "<leader>rs", "<CMD>SearchReplaceSingleBufferSelections<CR>")
      vim.keymap.set("n", "<leader>ro", "<CMD>SearchReplaceSingleBufferOpen<CR>")
      vim.keymap.set("n", "<leader>rw", "<CMD>SearchReplaceSingleBufferCWord<CR>")
      vim.keymap.set("n", "<leader>rW", "<CMD>SearchReplaceSingleBufferCWORD<CR>")
      vim.keymap.set("n", "<leader>re", "<CMD>SearchReplaceSingleBufferCExpr<CR>")
      vim.keymap.set("n", "<leader>rf", "<CMD>SearchReplaceSingleBufferCFile<CR>")

      vim.keymap.set("n", "<leader>rbs", "<CMD>SearchReplaceMultiBufferSelections<CR>")
      vim.keymap.set("n", "<leader>rbo", "<CMD>SearchReplaceMultiBufferOpen<CR>")
      vim.keymap.set("n", "<leader>rbw", "<CMD>SearchReplaceMultiBufferCWord<CR>")
      vim.keymap.set("n", "<leader>rbW", "<CMD>SearchReplaceMultiBufferCWORD<CR>")
      vim.keymap.set("n", "<leader>rbe", "<CMD>SearchReplaceMultiBufferCExpr<CR>")
      vim.keymap.set("n", "<leader>rbf", "<CMD>SearchReplaceMultiBufferCFile<CR>")
    end,
  },
  {
    dir = "/home/y2w8/Projects/Neovim/notes.nvim",
    name = "notes.nvim",
    -- "y2w8/zellij.nvim",
    event = "VeryLazy",
    keys = {
      {
        mode = "n",
        "<leader>nw",
        function() require('notes').workspace_note() end,
        desc = "Open workspace note"
      },
      {
        mode = "n",
        "<leader>nW",
        function() require('notes').workspace_note(true) end,
        desc = "Open workspace note float"
      },
    },
    opts = {
      pkm_dir = "/home/y2w8/Documents/notes",
      frontmatter = {
        use_frontmatter = true,
        auto_update_modified = true,
        scan_lines = 20,
        fields = {
          id = true,
          created = true,
          modified = true,
          tags = true,
        },
      },
    }, -- Important even if empty
  },
  {
    dir = "~/Projects/Neovim/zellij.nvim",
    name = "zellij.nvim",
    -- "y2w8/zellij.nvim",
    event = "VeryLazy",
    opts = {}, -- Important even if empty
    keys = {
      -- Window navigation
      { "<C-k>", ":ZellijUp<CR>", desc = "Move up", silent = true },
      { "<C-j>", ":ZellijDown<CR>", desc = "Move down", silent = true },
      { "<C-h>", ":ZellijLeftTab<CR>", desc = "Move left", silent = true },
      { "<C-l>", ":ZellijRightTab<CR>", desc = "Move right", silent = true },
      -- Tab actions
      { "<leader>zt", ":ZellijNewTab<CR>", desc = "New Zellij Tab", silent = true },
      { "<leader>zr", ":ZellijRenameTab<CR>", desc = "Rename Zellij Tab", silent = true },
      { "<leader>zl", ":ZellijMoveTabLeft<CR>", desc = "Move Tab Left", silent = true },
      { "<leader>zL", ":ZellijMoveTabRight<CR>", desc = "Move Tab Right", silent = true },

      -- Pane actions
      { "<leader>zp", ":ZellijNewPane<CR>", desc = "New Zellij Pane", silent = true },
      { "<leader>zn", ":ZellijRenamePane<CR>", desc = "Rename Zellij Pane", silent = true },
      { "<leader>zu", ":ZellijMovePaneUp<CR>", desc = "Move Pane Up", silent = true },
      { "<leader>zd", ":ZellijMovePaneDown<CR>", desc = "Move Pane Down", silent = true },
      { "<leader>zh", ":ZellijMovePaneLeft<CR>", desc = "Move Pane Left", silent = true },
      { "<leader>zR", ":ZellijMovePaneRight<CR>", desc = "Move Pane Right", silent = true },
    },
  },
  { "mrjones2014/smart-splits.nvim" },
  {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvimtools/hydra.nvim",
    },
    opts = {},
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
    keys = {
      {
        mode = { "v", "n" },
        "<Leader>M",
        "<cmd>MCstart<cr>",
        desc = "Create a selection for selected text or word under the cursor",
      },
    },
  },
  {
    "gisketch/triforce.nvim",
    dependencies = { "nvzone/volt" },
    event = "VeryLazy",
    config = function()
      require("triforce").setup {
        -- Optional: Add your configuration here
        keymap = {
          show_profile = "<leader>tp", -- Open profile with <leader>tp
        },
      }
    end,
  },
  {
    "nomad/nomad",
    version = "*",
    event = "VeryLazy",
    build = function()
      ---@type nomad.neovim.build
      local build = require "nomad.neovim.build"

      build.builders.download_prebuilt():build(build.contexts.lazy())
    end,
    opts = {},
  },
  -- {
  --   "kdheepak/lazygit.nvim",
  --   lazy = true,
  --   cmd = {
  --     "LazyGit",
  --     "LazyGitConfig",
  --     "LazyGitCurrentFile",
  --     "LazyGitFilter",
  --     "LazyGitFilterCurrentFile",
  --   },
  --   -- optional for floating window border decoration
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  --   -- setting the keybinding for LazyGit with 'keys' is recommended in
  --   -- order to load the plugin when the command is run for the first time
  --   keys = {
  --     { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
  --   },
  -- },
  {
    "RRethy/vim-illuminate",
  },
  {
    "lucaSartore/fastspell.nvim",
    -- automatically run the installation script on windows and linux)
    -- if this doesn't work for some reason, you can
    build = function()
      local base_path = vim.fn.stdpath "data" .. "/lazy/fastspell.nvim"
      local cmd = base_path .. "/lua/scripts/install." .. (vim.fn.has "win32" and "cmd" or "sh")
      vim.system { cmd }
    end,

    config = function()
      local fastspell = require "fastspell"

      -- call setup to initialize fastspell
      fastspell.setup {
        -- Optionally put your custom configurations here
      }

      -- decide when to run the spell checking (see :help events for full list)
      vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufEnter", "WinScrolled" }, {
        callback = function(_)
          -- decide the area in your buffer that will be checked. This is the default configuration,
          -- and look for spelling mistakes ONLY in the lines of the bugger that are currently displayed
          -- for more advanced configurations see the section bellow
          local first_line = vim.fn.line "w0" - 1
          local last_line = vim.fn.line "w$"
          fastspell.sendSpellCheckRequest(first_line, last_line)
        end,
      })
    end,
  },
  -- {
  --     "kylechui/nvim-surround",
  --     version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
  --     event = "VeryLazy",
  --     config = function()
  --         require("nvim-surround").setup({
  --             -- Configuration here, or leave empty to use defaults
  --         })
  --     end
  -- },
  {
    "aznhe21/actions-preview.nvim",
    config = require "configs.extra.actions-preview",
  },
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    event = "LspAttach",
    opts = require "configs.tiny-code-actions",
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = require "configs.extra.todo-comments",
  },

  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        "<leader>-",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        -- Open in the current working directory
        "<leader>y",
        "<cmd>Yazi cwd<cr>",
        desc = "Open yazi cwd",
      },
      {
        "<c-up>",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    ---@type YaziConfig | {}
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    },
    -- 👇 if you use `open_for_directories=true`, this is recommended
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
  },
}
