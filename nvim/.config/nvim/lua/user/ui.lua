local M = {}

local telescope_ok, telescope = pcall(require, "telescope")
if not telescope_ok then
  print("Telescope is not installed!")
  return {}
end

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")

---@class DisplayItem?
---@field width? number optional
---@field remaining? boolean optional

---@class PickerOpts?
---@field layout_strategy? string|nil
---@field layout_config? table|nil
---@field sorting_strategy? string|nil
---@field any? table|nil  -- أي خيارات إضافية لـ Telescope

---@class SelectOpts
---@field prompt? string
---@field icons? string[]
---@field separator? string
---@field displayer? fun
---@field display_items? DisplayItem[]
---@field custom_display? fun(entry:table, icon:string, text:string):any
---@field picker_opts? PickerOpts

---@param options string[] قائمة الخيارات
---@param opts SelectOpts|nil الخيارات المتقدمة
---@param callback fun(choice:string, index:number)|nil الدالة اللي تتنفذ بعد الاختيار
function M.select(options, opts, callback)
  opts = opts or {}
  local prompt = opts.prompt or "اختر خيار"
  local icons = opts.icons or {}

  local displayer = opts.displayer
    or entry_display.create({
      separator = opts.separator or " ",
      items = opts.display_items or {
        { width = 2 },
        { remaining = true },
      },
    })

  local make_display = function(entry)
    local icon = icons[entry.index] or " "
    local text = entry.value
    if opts.custom_display then
      return opts.custom_display(entry, icon, text)
    end
    return displayer({
      { icon },
      text,
    })
  end

  local finder = finders.new_table({
    results = options,
    entry_maker = function(entry, index)
      return {
        value = entry,
        display = make_display,
        ordinal = entry,
        index = index,
      }
    end,
  })

  local picker_opts = vim.tbl_deep_extend("force", {
    prompt_title = prompt,
    finder = finder,
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if callback then
          callback(selection.value, selection.index)
        end
      end)
      return true
    end,
  }, opts.picker_opts or {})

  pickers.new({}, picker_opts):find()
end

return M
