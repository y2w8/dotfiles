local colors = require("catppuccin.palettes").get_palette("mocha")
local mini_icons = require("mini.icons")

local function get_filetype_bg()
  local filetype = vim.bo.filetype
  local lang = {
    lua = { bg = colors.blue },
    python = { bg = colors.yellow },
    javascript = { bg = colors.peach },
    typescript = { bg = colors.sapphire },
    tsx = { bg = colors.sky },
    jsx = { bg = colors.sky },
    html = { bg = colors.red },
    css = { bg = colors.blue },
    scss = { bg = colors.pink },
    json = { bg = colors.yellow },
    yaml = { bg = colors.teal },
    markdown = { bg = colors.green },
    sh = { bg = colors.mauve },
    bash = { bg = colors.mauve },
    zsh = { bg = colors.mauve },
    rust = { bg = colors.peach },
    go = { bg = colors.teal },
    java = { bg = colors.red },
    c = { bg = colors.sapphire },
    cpp = { bg = colors.sapphire },
    csharp = { bg = colors.lavender },
    php = { bg = colors.mauve },
    ruby = { bg = colors.red },
    swift = { bg = colors.peach },
    kotlin = { bg = colors.pink },
    default = { bg = colors.mantle },
  }
  return lang[filetype] or lang.default
end

local function shorten_filename(name, max_length, with_extension)
  max_length = max_length or 15
  if with_extension then
    if #name > max_length then
      local ext = name:match("^.+(%..+)$") or ""
      local name_res = name:sub(1, max_length - #ext - 3)
      return name_res .. "..." .. ext
    end
    return name
  else
    if #name > max_length then
      local name_res = name:sub(1, max_length - 3)
      return name_res .. "..."
    end
    return name
  end
end

local function get_project_name()
  local cwd = vim.fn.getcwd()
  return shorten_filename(vim.fn.fnamemodify(cwd, ":t"), 10, false) -- آخر مجلد
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    -- PERF: we don't need this lualine require madness 🤷
    local lualine_require = require("lualine_require")
    lualine_require.require = require

    local icons = LazyVim.config.icons
    -- TODO: add cwd and current file with the icon in status line
    -- FIX: tmux and nvim status line
    vim.o.laststatus = vim.g.lualine_laststatus

    local opts = {
      options = {
        theme = "catppuccin",
        globalstatus = vim.o.laststatus == 3,
        -- disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            icons_enabled = true,
            icon = { "" },
            color = function()
              -- هنا تحدد اللون بناءً على الـ mode الحالي
              local mode_color = {
                n = { fg = "#1e1e2e", bg = colors.rosewater }, -- Normal
                i = { fg = "#1e1e2e", bg = colors.green }, -- Insert
                v = { fg = "#1e1e2e", bg = colors.mauve }, -- Visual
                V = { fg = "#1e1e2e", bg = colors.mauve }, -- Visual line
                c = { fg = "#1e1e2e", bg = colors.peach }, -- Command
              }
              return mode_color[vim.fn.mode()] or { fg = "#1e1e2e", bg = "#b4befe" }
            end,
            padding = { left = 1, right = 1 },
            separator = { left = "", right = "" },
          },
        },
        lualine_b = {
          {
            "branch",
            color = { fg = colors.mauve, bg = colors.mantle },
            icon = { align = "right" },
          },
        },

        lualine_c = {
          { "progress", separator = "", color = { fg = colors.subtext0 } },
          { "location", color = { fg = colors.subtext0 } },
          LazyVim.lualine.root_dir(),
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { LazyVim.lualine.pretty_path() },
        },
        lualine_x = {
          Snacks.profiler.status(),
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = function() return { fg = Snacks.util.color("Statement") } end,
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = function() return { fg = Snacks.util.color("Constant") } end,
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = function() return { fg = Snacks.util.color("Debug") } end,
          },
          -- stylua: ignore
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function() return { fg = Snacks.util.color("Special") } end,
          },
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_y = {},
        lualine_z = {
          -- Current file
          {
            function()
              local icon = mini_icons.get("filetype", vim.bo.filetype) or ""
              local filename = vim.fn.expand("%:t")
              return icon .. " " .. shorten_filename(filename, 15, true)
            end,
            color = function()
              local icon_info = get_filetype_bg()
              return { fg = colors.base, bg = icon_info.bg }
            end,
            separator = { left = "", right = "" },
            padding = { left = 1, right = 1 },
          },
          -- Project name
          {
            function()
              local project = get_project_name()
              return " " .. project
            end,
            color = function()
              -- هنا تحدد اللون بناءً على الـ mode الحالي
              local mode_color = {
                n = { fg = "#1e1e2e", bg = colors.rosewater }, -- Normal
                i = { fg = "#1e1e2e", bg = colors.green }, -- Insert
                v = { fg = "#1e1e2e", bg = colors.mauve }, -- Visual
                V = { fg = "#1e1e2e", bg = colors.mauve }, -- Visual line
                c = { fg = "#1e1e2e", bg = colors.peach }, -- Command
              }
              return mode_color[vim.fn.mode()] or { fg = "#1e1e2e", bg = "#b4befe" }
            end,
            separator = { left = "", right = "" },
            padding = { left = 1, right = 1 },
          },
        },
      },
      extensions = { "neo-tree", "lazy", "fzf" },
    }

    -- do not add trouble symbols if aerial is enabled
    -- And allow it to be overriden for some buffer types (see autocmds)
    if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
      local trouble = require("trouble")
      local symbols = trouble.statusline({
        mode = "symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "lualine_c_normal",
      })
      table.insert(opts.sections.lualine_c, {
        symbols and symbols.get,
        cond = function()
          return vim.b.trouble_lualine ~= false and symbols.has()
        end,
      })
    end

    return opts
  end,
}
