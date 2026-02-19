local M = require "custom.catppuccin.header"

return {
		Comment = { fg = '#605f6f', italic = true, style = M.styles.comments }, -- just comments
		SpecialComment = { link = "Special" }, -- special things inside a comment
		Constant = { fg = M.palette.peach }, -- (preferred) any constant
		String = { fg = M.palette.green, style = M.styles.strings or {} }, -- a string constant: "this is a string"
		Character = { fg = M.palette.pink }, --  a character constant: 'c', '\n'
		Number = { fg = M.palette.peach, style = M.styles.numbers or {} }, --   a number constant: 234, 0xff
		Float = { link = "Number" }, --    a floating point constant: 2.3e10
		Boolean = { fg = M.palette.peach, style = M.styles.booleans or {} }, --  a boolean constant: TRUE, false
		Identifier = { fg = M.palette.maroon, style = M.styles.variables or {} }, -- (preferred) any variable name
		Function = { fg = M.palette.blue, style = M.styles.functions or {} }, -- function name (also: methods for classes)
		Statement = { fg = M.palette.red }, -- (preferred) any statement
		Conditional = { fg = M.palette.mauve, italic = true, style = M.styles.conditionals or {} }, --  if, then, else, endif, switch, etc.
		Repeat = { fg = M.palette.mauve, style = M.styles.loops or {} }, --   for, do, while, etc.
		Label = { fg = M.palette.yellow }, --    case, default, etc.
		Operator = { fg = M.palette.sky, style = M.styles.operators or {} }, -- "sizeof", "+", "*", etc.
		Keyword = { fg = M.palette.mauve, style = M.styles.keywords or {} }, --  any other keyword
		Exception = { fg = M.palette.mauve, style = M.styles.keywords or {} }, --  try, catch, throw

		PreProc = { fg = M.palette.pink }, -- (preferred) generic Preprocessor
		Include = { fg = M.palette.blue, style = M.styles.keywords or {} }, --  preprocessor #include
		Define = { fg = M.palette.mauve }, -- preprocessor #define
		Macro = { fg = M.palette.mauve }, -- same as Define
		PreCondit = { link = "PreProc" }, -- preprocessor #if, #else, #endif, etc.

		StorageClass = { fg = M.palette.yellow }, -- static, register, volatile, etc.
		Structure = { fg = M.palette.yellow }, --  struct, union, enum, etc.
		Special = { fg = M.palette.pink }, -- (preferred) any special symbol
		Type = { fg = M.palette.yellow, style = M.styles.types or {} }, -- (preferred) int, long, char, etc.
		Typedef = { link = "Type" }, --  A typedef
		SpecialChar = { fg = M.palette.pink }, -- special character in a constant
		Tag = { fg = M.palette.lavender, style = { "bold" } }, -- you can use CTRL-] on this
		Delimiter = { fg = M.palette.red }, -- character that needs attention
		Debug = { link = "Special" }, -- debugging statements

		Underlined = { style = { "underline" } }, -- (preferred) text that stands out, HTML links
		Bold = { style = { "bold" } },
		Italic = { style = { "italic" } },
		-- ("Ignore", below, may be invisible...)
		-- Ignore = { }, -- (preferred) left blank, hidden  |hl-Ignore|

		Error = { fg = M.palette.red }, -- (preferred) any erroneous construct
		Todo = { bg = M.palette.flamingo, fg = M.palette.base, style = { "bold" } }, -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX
		qfLineNr = { fg = M.palette.yellow },
		qfFileName = { fg = M.palette.blue },
		htmlH1 = { fg = M.palette.pink, style = { "bold" } },
		htmlH2 = { fg = M.palette.blue, style = { "bold" } },
		-- mkdHeading = { fg = C.peach, style = { "bold" } },
		-- mkdCode = { bg = C.terminal_black, fg = C.text },
		mkdCodeDelimiter = { bg = M.palette.base, fg = M.palette.text },
		mkdCodeStart = { fg = M.palette.flamingo, style = { "bold" } },
		mkdCodeEnd = { fg = M.palette.flamingo, style = { "bold" } },
		-- mkdLink = { fg = C.blue, style = { "underline" } },

		-- debugging
		debugPC = { bg = M.transparent_background and M.palette.none or M.palette.crust }, -- used for highlighting the current line in terminal-debug
		debugBreakpoint = { bg = M.palette.base, fg = M.palette.overlay0 }, -- used for breakpoint colors in terminal-debug
		-- illuminate
		illuminatedWord = { bg = M.palette.surface1 },
		illuminatedCurWord = { bg = M.palette.surface1 },
		-- diff
		Added = { fg = M.palette.green },
		Changed = { fg = M.palette.blue },
		diffAdded = { fg = M.palette.green },
		diffRemoved = { fg = M.palette.red },
		diffChanged = { fg = M.palette.blue },
		diffOldFile = { fg = M.palette.yellow },
		diffNewFile = { fg = M.palette.peach },
		diffFile = { fg = M.palette.blue },
		diffLine = { fg = M.palette.peach },
		diffIndexLine = { fg = M.palette.teal },
		DiffAdd = { bg = M.darken(M.palette.green, 0.18, M.palette.base) }, -- diff mode: Added line |diff.txt|
		DiffChange = { bg = M.darken(M.palette.blue, 0.07, M.palette.base) }, -- diff mode: Changed line |diff.txt|
		DiffDelete = { bg = M.darken(M.palette.red, 0.18, M.palette.base) }, -- diff mode: Deleted line |diff.txt|
		DiffText = { bg = M.darken(M.palette.blue, 0.30, M.palette.base) }, -- diff mode: Changed text within a changed line |diff.txt|
		-- NeoVim
		healthError = { fg = M.palette.red },
		healthSuccess = { fg = M.palette.teal },
		healthWarning = { fg = M.palette.yellow },
		-- misc

		-- glyphs
		GlyphPalette1 = { fg = M.palette.red },
		GlyphPalette2 = { fg = M.palette.teal },
		GlyphPalette3 = { fg = M.palette.yellow },
		GlyphPalette4 = { fg = M.palette.blue },
		GlyphPalette6 = { fg = M.palette.teal },
		GlyphPalette7 = { fg = M.palette.text },
		GlyphPalette9 = { fg = M.palette.red },

		-- rainbow
		rainbow1 = { fg = M.palette.red },
		rainbow2 = { fg = M.palette.peach },
		rainbow3 = { fg = M.palette.yellow },
		rainbow4 = { fg = M.palette.green },
		rainbow5 = { fg = M.palette.sapphire },
		rainbow6 = { fg = M.palette.lavender },

		-- csv
		csvCol0 = { fg = M.palette.red },
		csvCol1 = { fg = M.palette.peach },
		csvCol2 = { fg = M.palette.yellow },
		csvCol3 = { fg = M.palette.green },
		csvCol4 = { fg = M.palette.sky },
		csvCol5 = { fg = M.palette.blue },
		csvCol6 = { fg = M.palette.lavender },
		csvCol7 = { fg = M.palette.mauve },
		csvCol8 = { fg = M.palette.pink },

		-- markdown
		markdownHeadingDelimiter = { fg = M.palette.peach, style = { "bold" } },
		markdownCode = { fg = M.palette.flamingo },
		markdownCodeBlock = { fg = M.palette.flamingo },
		markdownLinkText = { fg = M.palette.blue, style = { "underline" } },
		markdownH1 = { link = "rainbow1" },
		markdownH2 = { link = "rainbow2" },
		markdownH3 = { link = "rainbow3" },
		markdownH4 = { link = "rainbow4" },
		markdownH5 = { link = "rainbow5" },
		markdownH6 = { link = "rainbow6" },
  }
