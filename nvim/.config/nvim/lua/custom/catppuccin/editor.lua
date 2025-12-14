local M = {}

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

return {
		ColorColumn = { bg = M.palette.surface0 }, -- used for the columns set with 'colorcolumn'
		Conceal = { fg = M.palette.overlay1 }, -- placeholder characters substituted for concealed text (see 'conceallevel')
		Cursor = { fg = M.palette.base, bg = M.palette.rosewater }, -- character under the cursor
		lCursor = { fg = M.palette.base, bg = M.palette.rosewater }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
		CursorIM = { fg = M.palette.base, bg = M.palette.rosewater }, -- like Cursor, but used when in IME mode |CursorIM|
		CursorColumn = { bg = M.palette.mantle }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
		CursorLine = {
			bg = M.darken(M.palette.surface0, 0.64, M.palette.base),
		}, -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if forecrust (ctermfg OR guifg) is not set.
		Directory = { fg = M.palette.blue }, -- directory names (and other special names in listings)
		EndOfBuffer = { fg = M.show_end_of_buffer and M.palette.surface1 or M.palette.base }, -- filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
		ErrorMsg = { fg = M.palette.red, style = { "bold", "italic" } }, -- error messages on the command line
		VertSplit = { fg = M.transparent_background and M.palette.surface1 or M.palette.crust }, -- the column separating vertically split windows
		Folded = { fg = M.palette.blue, bg = M.palette.none }, -- line used for closed folds
		FoldColumn = { fg = M.palette.overlay0 }, -- 'foldcolumn'
		SignColumn = { fg = M.palette.surface1 }, -- column where |signs| are displayed
		SignColumnSB = { bg = M.palette.crust, fg = M.palette.surface1 }, -- column where |signs| are displayed
		Substitute = { bg = M.palette.surface1, fg = M.palette.pink }, -- |:substitute| replacement text highlighting
		LineNr = { fg = M.palette.surface1 }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
		CursorLineNr = { fg = M.palette.lavender }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line. highlights the number in numberline.
		MatchParen = { fg = M.palette.peach, bg = M.darken(M.palette.surface1, 0.70, M.palette.base), style = { "bold" } }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
		ModeMsg = { fg = M.palette.text, style = { "bold" } }, -- 'showmode' message (e.g., "-- INSERT -- ")
		-- MsgArea = { fg = C.text }, -- Area for messages and cmdline, don't set this highlight because of https://github.com/neovim/neovim/issues/17832
		MsgSeparator = { link = "WinSeparator" }, -- Separator for scrolled messages, `msgsep` flag of 'display'
		MoreMsg = { fg = M.palette.blue }, -- |more-prompt|
		NonText = { fg = M.palette.overlay0 }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
		Normal = { fg = M.palette.text, bg = M.transparent_background and M.palette.none or M.palette.base }, -- normal text
		NormalNC = {
			fg = M.palette.text,
			bg = (M.transparent_background and M.dim_inactive.enabled and M.palette.dim)
				or (M.dim_inactive.enabled and M.palette.dim)
				or (M.transparent_background and M.palette.none)
				or M.palette.base,
		}, -- normal text in non-current windows
		NormalSB = { fg = M.palette.text, bg = M.palette.crust }, -- normal text in non-current windows
		NormalFloat = { fg = M.palette.text, bg = (M.float.transparent and vim.o.winblend == 0) and M.palette.none or M.palette.mantle }, -- Normal text in floating windows.
		FloatBorder = { fg = M.palette.rosewater }
    -- M.float.solid
			-- 	and ((M.float.transparent and vim.o.winblend == 0) and { fg = M.palette.surface2, bg = M.palette.none } or {
			-- 		fg = M.palette.mantle,
			-- 		bg = M.palette.mantle,
			-- 	})
			-- or { fg = M.palette.blue, bg = (M.float.transparent and vim.o.winblend == 0) and M.palette.none or M.palette.mantle }
  ,
		FloatTitle = M.float.solid and {
			fg = M.palette.crust,
			bg = M.palette.lavender,
		} or { fg = M.palette.subtext0, bg = (M.float.transparent and vim.o.winblend == 0) and M.palette.none or M.palette.mantle }, -- Title of floating windows
		FloatShadow = { fg = (M.float.transparent and vim.o.winblend == 0) and M.palette.none or M.palette.overlay0 },
		Pmenu = {
			bg = (M.transparent_background and vim.o.pumblend == 0) and M.palette.none or M.palette.mantle,
			fg = M.palette.overlay2,
		}, -- Popup menu: normal item.
		PmenuSel = { bg = M.palette.rosewater, style = { "bold" } }, -- Popup menu: selected item.
		PmenuMatch = { fg = M.palette.text, style = { "bold" } }, -- Popup menu: matching text.
		PmenuMatchSel = { style = { "bold" } }, -- Popup menu: matching text in selected item; is combined with |hl-PmenuMatch| and |hl-PmenuSel|.
		PmenuSbar = { bg = M.palette.surface0 }, -- Popup menu: scrollbar.
		PmenuThumb = { bg = M.palette.overlay0 }, -- Popup menu: Thumb of the scrollbar.
		PmenuExtra = { fg = M.palette.overlay0 }, -- Popup menu: normal item extra text.
		PmenuExtraSel = {
			bg = M.palette.surface0,
			fg = M.palette.overlay0,
			style = { "bold" },
		}, -- Popup menu: selected item extra text.
		ComplMatchIns = { link = "PreInsert" }, -- Matched text of the currently inserted completion.
		PreInsert = { fg = M.palette.overlay2 }, -- Text inserted when "preinsert" is in 'completeopt'.
		ComplHint = { fg = M.palette.subtext0 }, -- Virtual text of the currently selected completion.
		ComplHintMore = { link = "Question" }, -- The additional information of the virtual text.
		Question = { fg = M.palette.blue }, -- |hit-enter| prompt and yes/no questions
		QuickFixLine = { bg = M.darken(M.palette.surface1, 0.70, M.palette.base), style = { "bold" } }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
		Search = { bg = M.darken(M.palette.yellow, 0.30, M.palette.base), fg = M.palette.text }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
		IncSearch = { bg = M.darken(M.palette.yellow, 0.90, M.palette.base), fg = M.palette.mantle }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
		CurSearch = { bg = M.palette.peach, fg = M.palette.mantle }, -- 'cursearch' highlighting: highlights the current search you're on differently
		SpecialKey = { link = "NonText" }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' textspace. |hl-Whitespace|
		SpellBad = { sp = M.palette.red, style = { "undercurl" } }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
		SpellCap = { sp = M.palette.yellow, style = { "undercurl" } }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
		SpellLocal = { sp = M.palette.blue, style = { "undercurl" } }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
		SpellRare = { sp = M.palette.green, style = { "undercurl" } }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
		StatusLine = { fg = M.palette.text, bg = M.transparent_background and M.palette.none or M.palette.mantle }, -- status line of current window
		StatusLineNC = { fg = M.palette.surface1, bg = M.transparent_background and M.palette.none or M.palette.mantle }, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
		TabLine = { bg = M.palette.crust, fg = M.palette.overlay0 }, -- tab pages line, not active tab page label
		TabLineFill = { bg = M.transparent_background and M.palette.none or M.palette.mantle }, -- tab pages line, where there are no labels
		TabLineSel = { link = "Normal" }, -- tab pages line, active tab page label
		TermCursor = { fg = M.palette.base, bg = M.palette.rosewater }, -- cursor in a focused terminal
		TermCursorNC = { fg = M.palette.base, bg = M.palette.overlay2 }, -- cursor in unfocused terminals
		Title = { fg = M.palette.blue, style = { "bold" } }, -- titles for output from ":set all", ":autocmd" etc.
		Visual = { bg = M.palette.surface1, style = { "bold" } }, -- Visual mode selection
		VisualNOS = { bg = M.palette.surface1, style = { "bold" } }, -- Visual mode selection when vim is "Not Owning the Selection".
		WarningMsg = { fg = M.palette.yellow }, -- warning messages
		Whitespace = { fg = M.palette.surface1 }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
		WildMenu = { bg = M.palette.overlay0 }, -- current match in 'wildmenu' completion
		WinBar = { fg = M.palette.rosewater },
		WinBarNC = { link = "WinBar" },
		WinSeparator = { fg = M.transparent_background and M.palette.surface1 or M.palette.crust },
  }
