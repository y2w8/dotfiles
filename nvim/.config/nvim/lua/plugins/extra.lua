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
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = false },
      ---@class snacks.dashboard.Config
      ---@field enabled? boolean
      ---@field sections snacks.dashboard.Section
      ---@field formats table<string, snacks.dashboard.Text|fun(item:snacks.dashboard.Item, ctx:snacks.dashboard.Format.ctx):snacks.dashboard.Text>
      dashboard = {
        enabled = true,
        width = 95,
        formats = {},
        preset = {
          header = [[
  ▄▄         ▄ ▄▄▄▄▄▄▄
▄▀███▄     ▄██ █████▀ 
██▄▀███▄   ███        
███  ▀███▄ ███        
███    ▀██ ███        
███      ▀ ███        
▀██ █████▄▀█▀▄██████▄ 
  ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀
                                
  Powered By  eovim ]],
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          {
            pane = 2,
            section = "terminal",
            cmd = "colorscript -e square",
            height = 5,
            padding = 1,
          },
          {
            pane = 2,
            icon = " ",
            desc = "Browse Repo",
            padding = 1,
            key = "b",
            action = function()
              Snacks.gitbrowse()
            end,
          },
          function()
            local in_git = Snacks.git.get_root() ~= nil
            local cmds = {
              {
                title = "Notifications",
                cmd = "gh notify -s -an 5",
                action = function()
                  vim.ui.open "https://github.com/notifications"
                end,
                key = "n",
                icon = " ",
                height = 5,
                enabled = true,
              },
              {
                title = "Open Issues",
                cmd = "gh issue list -L 3",
                key = "i",
                action = function()
                  vim.fn.jobstart("gh issue list --web", { detach = true })
                end,
                icon = " ",
                height = 7,
              },
              {
                icon = " ",
                title = "Open PRs",
                cmd = "gh pr list -L 3",
                key = "P",
                action = function()
                  vim.fn.jobstart("gh pr list --web", { detach = true })
                end,
                height = 3,
              },
              {
                icon = " ",
                title = "Git Status",
                cmd = "git --no-pager diff --stat -B -M -C",
                height = 10,
              },
            }
            return vim.tbl_map(function(cmd)
              return vim.tbl_extend("force", {
                pane = 2,
                section = "terminal",
                enabled = in_git,
                padding = 1,
                ttl = 5 * 60,
                indent = 2,
              }, cmd)
            end, cmds)
          end,
          { section = "startup" },
        },
      },
      ---@type table<string, snacks.win.Config>
      styles = {
        picker = {

          wo = {
            winhighlight = table.concat({
              "Normal:SnacksNotifierHistory",
              "FloatBorder:SnacksNotifierHistoryBorder",
              "FloatTitle:SnacksNotifierHistoryTitle",
            }, ","),
          },
        },
        notifier = {},
        notification_history = {
          border = true,
          zindex = 100,
          width = 0.6,
          height = 0.6,
          minimal = false,
          title = " Notification History ",
          title_pos = "center",
          ft = "markdown",
          bo = { filetype = "snacks_notif_history", modifiable = false },
          wo = {
            winhighlight = table.concat({
              "Normal:SnacksNotifierHistory",
              "FloatBorder:SnacksNotifierHistoryBorder",
              "FloatTitle:SnacksNotifierHistoryTitle",
            }, ","),
          },
          keys = { q = "close" },
        },
      },
      explorer = { enabled = false },
      indent = { enabled = false },
      input = { enabled = false },
      picker = {
        enabled = true,
        prompt = "   ",
      },

      ---@class snacks.notifier.Config
      ---@field enabled? boolean
      ---@field keep? fun(notif: snacks.notifier.Notif): boolean # global keep function
      ---@field filter? fun(notif: snacks.notifier.Notif): boolean # filter our unwanted notifications (return false to hide)
      notifier = {
        enabled = false,
        timeout = 3000, -- default timeout in ms
        width = { min = 40, max = 0.4 },
        height = { min = 1, max = 0.6 },
        -- editor margin to keep free. tabline and statusline are taken into account automatically
        margin = { top = 0, right = 1, bottom = 0 },
        padding = true, -- add 1 cell of left/right padding to the notification window
        gap = 0, -- gap between notifications
        sort = { "level", "added" }, -- sort by level and time
        -- minimum log level to display. TRACE is the lowest
        -- all notifications are stored in history
        level = vim.log.levels.TRACE,
        icons = {
          error = " ",
          warn = " ",
          info = " ",
          debug = " ",
          trace = " ",
        },
        keep = function(notif)
          return vim.fn.getcmdpos() > 0
        end,
        ---@type snacks.notifier.style
        style = "minimal",
        top_down = true, -- place notifications from top to bottom
        date_format = "%R", -- time format for notifications
        -- format for footer when more lines are available
        -- `%d` is replaced with the number of lines.
        -- only works for styles with a border
        ---@type string|boolean
        more_format = " ↓ %d lines ",
        refresh = 50, -- refresh at most every 50ms
      },
      quickfile = { enabled = true },
      scope = { enabled = false },
      scroll = { enabled = true, animate = {} },
      statuscolumn = { enabled = false },
      words = { enabled = false },
      image = {
        enabled = true,
        doc = {
          inline = false,
          float = true,
        },
      },
    },
    keys = {
      -- Top Pickers & Explorer
      {
        "<leader><space>",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart Find Files",
      },
      {
        "<leader>,",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>/",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>:",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>n",
        function()
          Snacks.picker.notifications()
        end,
        desc = "Notification History",
      },
      {
        "<leader>e",
        function()
          Snacks.explorer()
        end,
        desc = "File Explorer",
      },
      -- find
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fc",
        function()
          Snacks.picker.files { cwd = vim.fn.stdpath "config" }
        end,
        desc = "Find Config File",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.git_files()
        end,
        desc = "Find Git Files",
      },
      {
        "<leader>fp",
        function()
          Snacks.picker.projects()
        end,
        desc = "Projects",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent",
      },
      -- git
      {
        "<leader>gb",
        function()
          Snacks.picker.git_branches()
        end,
        desc = "Git Branches",
      },
      {
        "<leader>gl",
        function()
          Snacks.picker.git_log()
        end,
        desc = "Git Log",
      },
      {
        "<leader>gL",
        function()
          Snacks.picker.git_log_line()
        end,
        desc = "Git Log Line",
      },
      {
        "<leader>gs",
        function()
          Snacks.picker.git_status()
        end,
        desc = "Git Status",
      },
      {
        "<leader>gS",
        function()
          Snacks.picker.git_stash()
        end,
        desc = "Git Stash",
      },
      {
        "<leader>gd",
        function()
          Snacks.picker.git_diff()
        end,
        desc = "Git Diff (Hunks)",
      },
      {
        "<leader>gf",
        function()
          Snacks.picker.git_log_file()
        end,
        desc = "Git Log File",
      },
      -- gh
      {
        "<leader>gi",
        function()
          Snacks.picker.gh_issue()
        end,
        desc = "GitHub Issues (open)",
      },
      {
        "<leader>gI",
        function()
          Snacks.picker.gh_issue { state = "all" }
        end,
        desc = "GitHub Issues (all)",
      },
      {
        "<leader>gp",
        function()
          Snacks.picker.gh_pr()
        end,
        desc = "GitHub Pull Requests (open)",
      },
      {
        "<leader>gP",
        function()
          Snacks.picker.gh_pr { state = "all" }
        end,
        desc = "GitHub Pull Requests (all)",
      },
      -- Grep
      {
        "<leader>sb",
        function()
          Snacks.picker.lines()
        end,
        desc = "Buffer Lines",
      },
      {
        "<leader>sB",
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = "Grep Open Buffers",
      },
      {
        "<leader>sg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>sw",
        function()
          Snacks.picker.grep_word()
        end,
        desc = "Visual selection or word",
        mode = { "n", "x" },
      },
      -- search
      {
        '<leader>s"',
        function()
          Snacks.picker.registers()
        end,
        desc = "Registers",
      },
      {
        "<leader>s/",
        function()
          Snacks.picker.search_history()
        end,
        desc = "Search History",
      },
      {
        "<leader>sa",
        function()
          Snacks.picker.autocmds()
        end,
        desc = "Autocmds",
      },
      {
        "<leader>sb",
        function()
          Snacks.picker.lines()
        end,
        desc = "Buffer Lines",
      },
      {
        "<leader>sc",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>sC",
        function()
          Snacks.picker.commands()
        end,
        desc = "Commands",
      },
      {
        "<leader>sd",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>sD",
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = "Buffer Diagnostics",
      },
      {
        "<leader>sh",
        function()
          Snacks.picker.help()
        end,
        desc = "Help Pages",
      },
      {
        "<leader>sH",
        function()
          Snacks.picker.highlights()
        end,
        desc = "Highlights",
      },
      {
        "<leader>si",
        function()
          Snacks.picker.icons()
        end,
        desc = "Icons",
      },
      {
        "<leader>sj",
        function()
          Snacks.picker.jumps()
        end,
        desc = "Jumps",
      },
      {
        "<leader>sk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>sl",
        function()
          Snacks.picker.loclist()
        end,
        desc = "Location List",
      },
      {
        "<leader>sm",
        function()
          Snacks.picker.marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>sM",
        function()
          Snacks.picker.man()
        end,
        desc = "Man Pages",
      },
      {
        "<leader>sp",
        function()
          Snacks.picker.lazy()
        end,
        desc = "Search for Plugin Spec",
      },
      {
        "<leader>sq",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix List",
      },
      {
        "<leader>sR",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume",
      },
      {
        "<leader>su",
        function()
          Snacks.picker.undo()
        end,
        desc = "Undo History",
      },
      {
        "<leader>uC",
        function()
          Snacks.picker.colorschemes()
        end,
        desc = "Colorschemes",
      },
      -- LSP
      {
        "gd",
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = "Goto Definition",
      },
      {
        "gD",
        function()
          Snacks.picker.lsp_declarations()
        end,
        desc = "Goto Declaration",
      },
      {
        "gr",
        function()
          Snacks.picker.lsp_references()
        end,
        nowait = true,
        desc = "References",
      },
      {
        "gI",
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = "Goto Implementation",
      },
      {
        "gy",
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = "Goto T[y]pe Definition",
      },
      {
        "gai",
        function()
          Snacks.picker.lsp_incoming_calls()
        end,
        desc = "C[a]lls Incoming",
      },
      {
        "gao",
        function()
          Snacks.picker.lsp_outgoing_calls()
        end,
        desc = "C[a]lls Outgoing",
      },
      {
        "<leader>ss",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "LSP Symbols",
      },
      {
        "<leader>sS",
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "LSP Workspace Symbols",
      },
      -- Other
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
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
      },
      {
        "<leader>S",
        function()
          Snacks.scratch.select()
        end,
        desc = "Select Scratch Buffer",
      },
      {
        "<leader>n",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification History",
      },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
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
        "<leader>un",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss All Notifications",
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
        "]]",
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = "Next Reference",
        mode = { "n", "t" },
      },
      {
        "[[",
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = "Prev Reference",
        mode = { "n", "t" },
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
            vim._print = function(_, ...)
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
    "y2w8/zellij.nvim",
    event = "VeryLazy",
    opts = {}, -- Important even if empty
    keys = {
      -- Window navigation
      { "<C-k>", ":ZellijUp<CR>", desc = "Move up", silent = true },
      { "<C-j>", ":ZellijDown<CR>", desc = "Move down" },
      { "<C-h>", ":ZellijLeftTab<CR>", desc = "Move left" },
      { "<C-l>", ":ZellijRightTab<CR>", desc = "Move right" },

      -- Tab actions
      { "<leader>zt", ":ZellijNewTab<CR>", desc = "New Zellij Tab" },
      { "<leader>zr", ":ZellijRenameTab<CR>", desc = "Rename Zellij Tab" },
      { "<leader>zl", ":ZellijMoveTabLeft<CR>", desc = "Move Tab Left" },
      { "<leader>zL", ":ZellijMoveTabRight<CR>", desc = "Move Tab Right" },

      -- Pane actions
      { "<leader>zp", ":ZellijNewPane<CR>", desc = "New Zellij Pane" },
      { "<leader>zn", ":ZellijRenamePane<CR>", desc = "Rename Zellij Pane" },
      { "<leader>zu", ":ZellijMovePaneUp<CR>", desc = "Move Pane Up" },
      { "<leader>zd", ":ZellijMovePaneDown<CR>", desc = "Move Pane Down" },
      { "<leader>zh", ":ZellijMovePaneLeft<CR>", desc = "Move Pane Left" },
      { "<leader>zR", ":ZellijMovePaneRight<CR>", desc = "Move Pane Right" },
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
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
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
