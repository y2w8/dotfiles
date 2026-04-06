vim.keymap.set("n", "<leader>Z", function()
  Snacks.zen.zoom()
end, { desc = "Toggle Zoom" })
vim.keymap.set({ "n", "t" }, "<C-/>", function()
  Snacks.terminal()
end, { desc = "Toggle Terminal" })
vim.keymap.set("n", "<leader>cR", function()
  Snacks.rename.rename_file()
end, { desc = "Rename File" })
vim.keymap.set({ "n", "v" }, "<leader>gB", function()
  Snacks.gitbrowse()
end, { desc = "Git Browse" })
vim.keymap.set("n", "<leader>gG", function()
  Snacks.lazygit()
end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>N", function()
  Snacks.win {
    file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
    width = 0.6,
    height = 0.6,
    wo = { spell = false, wrap = false, signcolumn = "yes", statuscolumn = " ", conceallevel = 3 },
  }
end, { desc = "Neovim News" })

---@type snacks.Config
require("snacks").setup {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
  bigfile = { enabled = false },
  ---@class snacks.dashboard.Config
  ---@field enabled? boolean
  ---@field sections snacks.dashboard.Section
  ---@field formats table<string, snacks.dashboard.Text|fun(item:snacks.dashboard.Item, ctx:snacks.dashboard.Format.ctx):snacks.dashboard.Text>
  dashboard = {
    enabled = not vim.g.is_firenvim,
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
      keys = {
        -- { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        -- { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
        -- { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
        { icon = " ", key = "s", desc = "Restore Session", section = "session" },
        { icon = " ", key = "L", desc = "Plugins", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      -- { section = "header" },
      function()
        return {
          header = require("custom.sysinfo").header,
          padding = 1,
          pane = 1,
        }
      end,
      { section = "keys", gap = 0, padding = 1 },
      { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
      { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
      {
        pane = 2,
        section = "terminal",
        cmd = "colorscript -e square",
        height = 5,
        padding = 1,
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
            title = "",
            cmd = "cowsay 'Not a git repo'",
            icon = "",
            height = 10,
            cache = false,
            ttl = 0,
            enabled = not in_git,
          },
          {
            icon = " ",
            title = "Git Status",
            -- cmd = "git --no-pager diff --stat -B -M -C",
            cmd = "git status --short --branch --renames",
            height = 10,
          },
          -- {
          --   title = "Commits History",
          --   cmd = [[git log --graph --all --color=always -n 10 --format='@%at@%s' | jq -R -r 'if contains("@") then split("@") as $parts | $parts[0] as $graph | ($parts[1]|tonumber) as $t | $parts[2] as $s | (now - $t) as $diff | (if $diff < 3600 then "\(($diff/60|floor))m" elif $diff < 86400 then "\(($diff/3600|floor))h" elif $diff < 604800 then "\(($diff/86400|floor))d" elif $diff < 2592000 then "\(($diff/604800|floor))w" else "\(($diff/2592000|floor))mo" end) as $time | $graph + "\u001b[35m" + ($time + (" " * (5 - ($time|length)))) + "\u001b[0m " + $s else . end' | cut -c 1-78]],
          --   -- cmd = "git --no-pager log --graph -n 9 --format='%C(auto)%h %C(green)%ar %C(white)%s' --oneline",
          --   icon = "s ",
          --   height = 10,
          -- },
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
    enabled = false,
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
  quickfile = { enabled = false },
  scope = { enabled = false },
  scroll = {
    enabled = true,
    animate = {
      delay = 1000, -- delay in ms before using the repeat animation
      duration = { step = 30, total = 300 },
      easing = "linear",
    },
  },
  statuscolumn = { enabled = false },
  words = { enabled = false },
  image = {
    enabled = true,
    doc = {
      inline = false,
      float = true,
    },
  },
}
