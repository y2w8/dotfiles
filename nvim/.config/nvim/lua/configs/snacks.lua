vim.keymap.set("n", "<leader>Z", function() Snacks.zen.zoom() end, { desc = "Toggle Zoom" })
vim.keymap.set({ "n", "t" }, "<C-/>", function() Snacks.terminal() end, { desc = "Toggle Terminal" })
vim.keymap.set("n", "<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
vim.keymap.set({"n", "v"}, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse" })
vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>N", function()
  Snacks.win {
    file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
    width = 0.6, height = 0.6,
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
  scroll = { enabled = true, animate = {} },
  statuscolumn = { enabled = false },
  words = { enabled = false },
  image = {
    enabled = not vim.g.is_firenvim,
    doc = {
      inline = false,
      float = true,
    },
  },
}
