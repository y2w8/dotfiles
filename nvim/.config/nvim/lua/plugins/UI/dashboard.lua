local colors = require("catppuccin.palettes").get_palette("mocha")
return {
  "nvimdev/dashboard-nvim",
  lazy = true, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
  event = "VimEnter",
  opts = function()
    local nvim = [[
                                                                        
                                                                        
                                                                        
                                                                        
                                                                     
       ████ ██████           █████      ██                     
      ███████████             █████                             
      █████████ ███████████████████ ███   ███████████   
     █████████  ███    █████████████ █████ ██████████████   
    █████████ ██████████ █████████ █████ █████ ████ █████   
  ███████████ ███    ███ █████████ █████ █████ ████ █████  
 ██████  █████████████████████ ████ █████ █████ ████ ██████ 
                                                                        
                                                                        
                                                                        
]]
    local logo = {
      [[                                    ██████                                    ]],
      [[                                ████▒▒▒▒▒▒████                                ]],
      [[                              ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                              ]],
      [[                            ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                            ]],
      [[                          ██▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒                              ]],
      [[                          ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▓▓▓▓                          ]],
      [[                          ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▒▒▓▓                          ]],
      [[                        ██▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒    ██                        ]],
      [[                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ]],
      [[                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ]],
      [[                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ]],
      [[                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ]],
      [[                        ██▒▒██▒▒▒▒▒▒██▒▒▒▒▒▒▒▒██▒▒▒▒██                        ]],
      [[                        ████  ██▒▒██  ██▒▒▒▒██  ██▒▒██                        ]],
      [[                        ██      ██      ████      ████                        ]],
    }

    local telescope_ok, telescope = pcall(require, "telescope")
    if not telescope_ok then
      print("Telescope is not installed!")
      return {}
    end

    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local previewers = require("telescope.previewers")
    local conf = require("telescope.config").values
    local scan = require("plenary.scandir")
    local icons = require("mini.icons") -- يجلب الأيقونات
    local projects_path = "~/projects/"

    -- تجيب المجلدات على الطبقة الأولى
    local function list_projects()
      local dirs = scan.scan_dir(vim.fn.expand(projects_path), { only_dirs = true, depth = 1 })
      local names = {}
      for _, d in ipairs(dirs) do
        table.insert(names, vim.fn.fnamemodify(d, ":t"))
      end
      return names, dirs
    end

    -- previewer يعرض الملفات والمجلدات على الطبقة الأولى مع أيقونات mini.icons
    local function preview_first_layer(path, bufnr)
      icons.mock_nvim_web_devicons()
      local devicons = require("nvim-web-devicons")

      local scan_result = scan.scan_dir(path, { add_dirs = true, depth = 1 })
      local lines = {}

      for _, f in ipairs(scan_result) do
        local name = vim.fn.fnamemodify(f, ":t")
        local is_dir = vim.fn.isdirectory(f) == 1
        local icon, hl

        if is_dir then
          icon, hl = "", "Directory"
        else
          local ext = vim.fn.fnamemodify(f, ":e")
          icon, hl = devicons.get_icon(name, ext, { default = true })
          if not icon then
            icon, hl = "", "Normal"
          end
        end

        -- احفظ السطر كامل
        table.insert(lines, icon .. " " .. name)
      end

      -- حط كل النصوص أول
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

      -- بعدها أضف ال highlights للأيقونات
      for i, f in ipairs(scan_result) do
        local name = vim.fn.fnamemodify(f, ":t")
        local is_dir = vim.fn.isdirectory(f) == 1
        local icon, hl

        if is_dir then
          icon, hl = "", "Directory"
        else
          local ext = vim.fn.fnamemodify(f, ":e")
          icon, hl = devicons.get_icon(name, ext, { default = true })
          if not icon then
            icon, hl = "", "Normal"
          end
        end

        -- Highlight أول حرفين (الأيقونة غالباً)
        vim.api.nvim_buf_add_highlight(bufnr, -1, hl, i - 1, 0, #icon)
      end
    end

    local function pick_project()
      local names, dirs = list_projects()
      pickers
        .new({}, {
          prompt_title = "Projects",
          finder = finders.new_table({ results = names }),
          previewer = previewers.new_buffer_previewer({
            define_preview = function(self, entry, _)
              for i, n in ipairs(names) do
                if n == entry.value then
                  preview_first_layer(dirs[i], self.state.bufnr)
                  break
                end
              end
            end,
          }),
          sorter = conf.generic_sorter({}),
        })
        :find()
    end
    icons.mock_nvim_web_devicons()

    -- keymap
    vim.keymap.set("n", "<leader>p", pick_project, { desc = "Pick Project" })

    -- Config files picker (with preview)
    local pick_config_file = function()
      require("telescope.builtin").find_files({
        prompt_title = "Neovim Config",
        cwd = vim.fn.stdpath("config"), -- يخليه بس يجيب ملفات config
        hidden = true, -- لو عندك ملفات مخفية
        previewer = true, -- preview Catppuccin يضبط لونه هنا
      })
    end

    local opts = {
      theme = "doom",
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },

      config = {
        header = logo,
        -- stylua: ignore
        center = {
          { action = 'lua LazyVim.pick()()',                           desc = " Find File",       icon = " ", key = "f" },
          { action = "ene | startinsert",                              desc = " New File",        icon = " ", key = "n" },
          { action = 'lua LazyVim.pick("oldfiles")()',                 desc = " Recent Files",    icon = " ", key = "r" },
          { action = pick_project,                     desc = " Projects",        icon = " ", key = "p" },
          { action = 'lua LazyVim.pick("live_grep")()',                desc = " Find Text",       icon = " ", key = "g" },
          { action = pick_config_file,              desc = " Config",          icon = " ", key = "c" },
          { action = 'lua require("persistence").load()',              desc = " Restore Session", icon = " ", key = "s" },
          { action = "LazyExtras",                                     desc = " Lazy Extras",     icon = " ", key = "x" },
          { action = "Lazy",                                           desc = " Lazy",            icon = "󰒲 ", key = "l" },
          { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit",            icon = " ", key = "q" },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      button.key_format = "  %s"
    end

    -- open dashboard after closing lazy
    if vim.o.filetype == "lazy" then
      vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(vim.api.nvim_get_current_win()),
        once = true,
        callback = function()
          vim.schedule(function()
            vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
          end)
        end,
      })
    end
    local function set_hl(group, opt)
      vim.api.nvim_set_hl(0, group, opt)
    end

    set_hl("DashboardHeader", { fg = colors.rosewater, bg = "none" })
    set_hl("DashboardDesc", { fg = colors.text, bg = "none" })
    set_hl("DashboardKey", { fg = colors.peach, bg = "none" })
    set_hl("DashboardIcon", { fg = colors.rosewater, bg = "none" })
    set_hl("DashboardFooter", { fg = colors.sapphire, bg = "none" })
    return opts
  end,
}
