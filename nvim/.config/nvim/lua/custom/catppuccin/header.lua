local M = {}
function M.convert_style(tbl)
  if type(tbl) ~= "table" then
    return tbl
  end
  local new_tbl = {}
  for k, v in pairs(tbl) do
    if k == "style" and type(v) == "table" then
      for _, style_name in ipairs(v) do
        new_tbl[style_name] = true
      end
    elseif type(v) == "table" then
      new_tbl[k] = M.convert_style(v) -- recurse
    else
      new_tbl[k] = v
    end
  end
  return new_tbl
end
M.bg = "#000000"
M.fg = "#ffffff"
M.day_brightness = 0.3

function M.hex_to_rgb(hex_str)
  local hex = "[abcdef0-9][abcdef0-9]"
  local pat = "^#(" .. hex .. ")(" .. hex .. ")(" .. hex .. ")$"
  hex_str = string.lower(hex_str)

  assert(string.find(hex_str, pat) ~= nil, "hex_to_rgb: invalid hex_str: " .. tostring(hex_str))

  local red, green, blue = string.match(hex_str, pat)
  return { tonumber(red, 16), tonumber(green, 16), tonumber(blue, 16) }
end

function M.blend(fg, bg, alpha)
  bg = M.hex_to_rgb(bg)
  fg = M.hex_to_rgb(fg)

  local blendChannel = function(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format("#%02X%02X%02X", blendChannel(1), blendChannel(2), blendChannel(3))
end

function M.darken(hex, amount, bg)
  return M.blend(hex, bg or M.bg, math.abs(amount))
end
function M.lighten(hex, amount, fg)
  return M.blend(hex, fg or M.fg, math.abs(amount))
end
function M.vary_color(palettes, default)
  local flvr = require("catppuccin").flavour

  if palettes[flvr] ~= nil then
    return palettes[flvr]
  end
  return default
end
M.background = {
  light = "latte",
  dark = "mocha",
}
M.transparent_background = require("chadrc").base46.transparency
M.float = {
  transparent = false,
  solid = false,
}
M.show_end_of_buffer = true
-- term_colors = false,
-- kitty = vim.env.KITTY_WINDOW_ID and true or false,
M.dim_inactive = {
  enabled = false,
  shade = "dark",
  percentage = 0.15,
}
-- no_italic = false,
-- no_bold = false,
-- no_underline = false,
--
M.palette = {
  rosewater = "#F5E0DC",
  flamingo = "#F2CDCD",
  pink = "#F5C2E7",
  mauve = "#CBA6F7",
  red = "#F38BA8",
  maroon = "#EBA0AC",
  peach = "#FAB387",
  yellow = "#F9E2AF",
  green = "#A6E3A1",
  teal = "#94E2D5",
  sky = "#89DCEB",
  sapphire = "#74C7EC",
  blue = "#89B4FA",
  lavender = "#B4BEFE",

  text = "#CDD6F4",
  subtext1 = "#BAC2DE",
  subtext0 = "#A6ADC8",
  overlay2 = "#9399B2",
  overlay1 = "#7F849C",
  overlay0 = "#6C7086",
  surface2 = "#585B70",
  surface1 = "#45475A",
  surface0 = "#313244",

  base = "#1E1E2E",
  mantle = "#181825",
  crust = "#11111B",
  none = "NONE",
}

M.base_30 = {
  white = "#D9E0EE",
  darker_black = M.palette.mantle,
  black = "#1E1D2D", --  nvim bg
  black2 = "#252434",
  one_bg = "#2d2c3c", -- real bg of onedark
  one_bg2 = "#363545",
  one_bg3 = "#3e3d4d",
  grey = "#474656",
  grey_fg = "#4e4d5d",
  grey_fg2 = "#555464",
  light_grey = "#605f6f",
  red = M.palette.red,
  baby_pink = M.palette.maroon,
  pink = M.palette.pink,
  line = M.palette.surface0, -- for lines like vertsplit
  green = M.palette.green,
  vibrant_green = "#b6f4be",
  nord_blue = "#8bc2f0",
  blue = M.palette.blue,
  yellow = M.palette.yellow,
  sun = "#ffe9b6",
  purple = M.palette.mauve,
  dark_purple = "#c7a0dc",
  teal = M.palette.teal,
  orange = M.palette.peach,
  cyan = M.palette.sky,
  statusline_bg = "#232232",
  lightbg = "#2f2e3e",
  lightbg2 = M.palette.surface2,
  pmenu_bg = M.palette.rosewater,
  folder_bg = M.palette.rosewater,
  lavender = M.palette.lavender,
  none = "NONE",
}

M.base_16 = {
  base00 = M.palette.base,
  base01 = M.palette.mantle,
  base02 = M.palette.surface0,
  base03 = M.palette.surface1,
  base04 = M.palette.surface2,
  base05 = M.palette.text,
  base06 = M.palette.rosewater,
  base07 = M.palette.lavender,
  base08 = M.palette.red,
  base09 = M.palette.peach,
  base0A = M.palette.yellow,
  base0B = M.palette.green,
  base0C = M.palette.teal,
  base0D = M.palette.blue,
  base0E = M.palette.mauve,
  base0F = M.palette.flamingo,
}

M.styles = {
  comments = { "italic" },
  conditionals = { "italic" },
  keywords = { "italic" },
  functions = { "bold" },
  types = { "bold" },
  loops = { "italic" },
  strings = {},
  variables = {},
  numbers = {},
  booleans = {},
  properties = {},
  operators = {},
}
return M
