local M = {}

M.bg = "#000000"
M.fg = "#ffffff"
M.day_brightness = 0.3

local hex_to_rgb = function(hex_str)
	local hex = "[abcdef0-9][abcdef0-9]"
	local pat = "^#(" .. hex .. ")(" .. hex .. ")(" .. hex .. ")$"
	hex_str = string.lower(hex_str)

	assert(string.find(hex_str, pat) ~= nil, "hex_to_rgb: invalid hex_str: " .. tostring(hex_str))

	local red, green, blue = string.match(hex_str, pat)
	return { tonumber(red, 16), tonumber(green, 16), tonumber(blue, 16) }
end

function M.blend(fg, bg, alpha)
	bg = hex_to_rgb(bg)
	fg = hex_to_rgb(fg)

	local blendChannel = function(i)
		local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
		return math.floor(math.min(math.max(0, ret), 255) + 0.5)
	end

	return string.format("#%02X%02X%02X", blendChannel(1), blendChannel(2), blendChannel(3))
end

function M.darken(hex, amount, bg) return M.blend(hex, bg or M.bg, math.abs(amount)) end
function M.lighten(hex, amount, fg) return M.blend(hex, fg or M.fg, math.abs(amount)) end
function M.vary_color(palettes, default)
	local flvr = require("catppuccin").flavour

	if palettes[flvr] ~= nil then return palettes[flvr] end
	return default
end
		M.background = {
			light = "latte",
			dark = "mocha",
		}
		M.transparent_background = false
		M.float = {
			transparent = false,
			solid = false,
		}
		M.show_end_of_buffer = false
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
M.palette = {
	rosewater = "#F5E0DC",
	flamingo  = "#F2CDCD",
	pink      = "#F5C2E7",
	mauve     = "#CBA6F7",
	red       = "#F38BA8",
	maroon    = "#EBA0AC",
	peach     = "#FAB387",
	yellow    = "#F9E2AF",
	green     = "#A6E3A1",
	teal      = "#94E2D5",
	sky       = "#89DCEB",
	sapphire  = "#74C7EC",
	blue      = "#89B4FA",
	lavender  = "#B4BEFE",

	text      = "#CDD6F4",
	subtext1  = "#BAC2DE",
	subtext0  = "#A6ADC8",
	overlay2  = "#9399B2",
	overlay1  = "#7F849C",
	overlay0  = "#6C7086",
	surface2  = "#585B70",
	surface1  = "#45475A",
	surface0  = "#313244",

	base      = "#1E1E2E",
	mantle    = "#181825",
	crust     = "#11111B",
}



		M.styles = {
			comments = { "italic" },
			conditionals = { "italic" },
			loops = {},
			functions = {},
			keywords = {},
			strings = {},
			variables = {},
			numbers = {},
			booleans = {},
			properties = {},
			types = {},
			operators = {},
		}
return M
