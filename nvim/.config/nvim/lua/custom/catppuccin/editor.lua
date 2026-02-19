local M = require "custom.catppuccin.header"

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
    EndOfBuffer = { fg = M.show_end_of_buffer and M.palette.surface1 or M.palette.base },
		ErrorMsg = { fg = M.palette.red, style = { "bold", "italic" } }, -- error messages on the command line
		VertSplit = { fg = M.transparent_background and M.palette.surface1 or M.palette.crust }, -- the column separating vertically split windows
		Folded = { fg = M.palette.blue, bg = M.transparent_background and M.palette.none or M.palette.surface1 }, -- line used for closed folds
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
		Search = { bg = M.darken(M.palette.teal, 0.30, M.palette.base), fg = M.palette.text }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
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
		TabLineFill = { bg = M.transparent_background and M.palette.none or M.base_30.black }, -- tab pages line, where there are no labels
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
