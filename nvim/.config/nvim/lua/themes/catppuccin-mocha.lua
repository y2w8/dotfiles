local M = require "custom.catppuccin.header"
local polish_hl = {
  -- lsp = require 'custom.catppuccin.lsp',
  -- dap = {
  --   DapBreakpoint = { fg = M.base_30.red },
  --   DapBreakpointCondition = { fg = M.base_30.yellow },
  --   DapBreakPointRejected = { fg = M.base_30.orange },
  --   DapLogPoint = { fg = M.base_30.cyan },
  --   DapStopped = { fg = M.base_30.baby_pink },
  -- },
  neogit = require "custom.catppuccin.neogit",
  blink = {
    BlinkCmpMenu = { bg = M.base_30.black },
    BlinkCmpMenuBorder = { fg = M.palette.rosewater },
    BlinkCmpDoc = { link = "BlinkCmpMenu" },
    BlinkCmpDocBorder = { link = "BlinkCmpMenuBorder" },
  },
  tbline = {
    TbFill = {
      link = "TabLineFill",
    },

    TbBufOn = {
      fg = M.base_30.white,
      bg = M.transparent_background and M.palette.surface1 or M.base_30.black2,
    },

    TbBufOff = {
      fg = M.transparent_background and M.palette.overlay0 or M.base_30.light_grey,
      bg = M.transparent_background and M.base_30.none or M.base_30.black,
    },

    TbBufOnModified = {
      fg = M.base_30.green,
      bg = M.transparent_background and M.palette.surface1 or M.base_30.black2,
    },

    TbBufOffModified = {
      fg = M.base_30.red,
      bg = M.transparent_background and M.palette.none or M.base_30.black,
    },

    TbBufOnClose = {
      fg = M.transparent_background and M.base_30.none or M.base_30.black,
      bg = M.transparent_background and M.base_30.none or M.base_30.black,
    },

    TbBufOffClose = {
      fg = M.transparent_background and M.base_30.none or M.base_30.black,
      bg = M.transparent_background and M.base_30.none or M.base_30.black,
    },

    TbTabNewBtn = {
      fg = M.base_30.white,
      bg = M.base_30.one_bg2,
    },

    TbTabOn = {
      fg = M.base_30.red,
      bg = M.transparent_background and M.base_30.none or M.base_30.black,
    },

    TbTabOff = {
      fg = M.base_30.white,
      bg = M.base_30.black2,
    },

    TbTabCloseBtn = {
      fg = M.base_30.black,
      bg = M.base_30.nord_blue,
    },

    TBTabTitle = {
      fg = M.base_30.black,
      bg = M.base_30.blue,
    },

    TbThemeToggleBtn = {
      bold = true,
      fg = M.base_30.white,
      bg = M.base_30.one_bg3,
    },

    TbCloseAllBufsBtn = {
      bold = true,
      bg = M.base_30.red,
      fg = M.base_30.black,
    },
  },
  defaults = require "custom.catppuccin.editor",
  custom = {

    SnacksDashboardHeader = { fg = M.base_30.blue, bold = true },
    SnacksDashboardIcon = { fg = M.base_30.light_grey },
    SnacksDashboardDesc = { fg = M.base_30.light_grey },
    SnacksDashboardSpecial = { fg = M.base_30.red },
    SnacksDashboardFile = { fg = M.base_30.yellow },
    SnacksDashboardTitle = { fg = M.base_30.light_grey },
    SnacksDashboardTerminal = { fg = M.base_30.light_grey },
    SnacksDashboardFooter = { fg = M.base_30.red },
    SnacksDashboardKey = { fg = M.base_30.light_grey },

    SnacksNotifierHistory = { bg = M.palette.mantle },
    SnacksNotifierHistoryTitle = { fg = M.base_30.black, bg = M.base_30.green },
    SnacksNotifierHistoryBorder = { fg = M.palette.mantle, bg = M.palette.mantle },

    -- Picker window
    SnacksPicker = { link = "TelescopeNormal" },
    SnacksPickerBorder = { link = "TelescopeBorder" },
    SnacksPickerHeader = { link = "TelescopePromptTitle" },

    -- Input area
    SnacksPickerInput = { link = "TelescopePromptNormal" },
    SnacksPickerInputBorder = { link = "TelescopePromptBorder" },
    SnacksPickerInputTitle = { link = "TelescopePromptTitle" },
    SnacksPickerInputSearch = { link = "TelescopePromptPrefix" },

    -- List area
    SnacksPickerList = { link = "TelescopeResultsNormal" },
    SnacksPickerListBorder = { link = "TelescopeResultsBorder" },
    SnacksPickerListTitle = { link = "TelescopePromptTitle" },

    -- Preview area
    SnacksPickerPreview = { link = "TelescopePreviewNormal" },
    SnacksPickerPreviewBorder = { link = "TelescopePreviewBorder" },
    SnacksPickerPreviewTitle = { link = "TelescopePreviewTitle" },

    -- Box (extra frame used by Snacks)
    SnacksPickerBox = { link = "TelescopeNormal" },
    SnacksPickerBoxTitle = { link = "TelescopePromptTitle" },
    SnacksPickerBoxBorder = { link = "TelescopeBorder" },

    -- Additional useful groups:
    SnacksPickerSelection = { link = "TelescopeSelection" },
    SnacksPickerSelectionCaret = { link = "TelescopeSelectionCaret" },
    SnacksPickerMatching = { link = "TelescopeMatching" },

    -- Scrolling highlights
    SnacksPickerScrollbar = { link = "TelescopeResultsDiffAdd" },
    SnacksPickerScrollbarThumb = { link = "TelescopeResultsDiffChange" },

    -- Icons
    SnacksPickerIcon = { link = "TelescopeResultsIdentifier" },
    SnacksPickerFile = { link = "TelescopeResultsFile" },

    RenderMarkdownCode = { bg = M.base_30.line },
    RenderMarkdownCodeBorder = { bg = M.palette.surface1 },
    RenderMarkdownCodeInline = { bg = M.base_30.line },
    RenderMarkdownTableRow = { fg = M.palette.surface1 },
    RenderMarkdownBullet = { fg = M.palette.peach },

    EndOfBuffer = { link = "Comment" },

    -- Toggle term
    WinBarActive = { bg = M.palette.mantle },
    WinBarInactive = { bg = M.palette.mantle }
  },
  semantic_tokens = {
    ["@lsp.type.enumMember"] = { fg = M.palette.teal },
    -- we assume treesitter can already handle this
    -- - treesitter can detect variables in buffers
    -- - lsp does not need responsibility for this, in fact it can be less
    --   accurate in cases
    ["@lsp.type.variable"] = {},

    -- in cases where the lsp can be more specific than treesitter, we should
    -- allow lsp to override treesitter
    ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.function.builtin"] = { link = "@function.builtin" },
  },
  syntax = require "custom.catppuccin.syntax",
  treesitter = {
    ["@variable"] = { fg = M.palette.red, style = M.styles.variables or {} }, -- Any variable name that does not have another highlight.
    ["@variable.builtin"] = { fg = M.palette.red, style = M.styles.properties or {} }, -- Variable names that are defined by the languages, like this or self.
    ["@variable.parameter"] = { fg = M.palette.maroon, style = M.styles.variables or {} }, -- For parameters of a function.
    ["@variable.member"] = { fg = M.palette.red }, -- For fields.

    ["@constant"] = { link = "Constant" }, -- For constants
    ["@constant.builtin"] = { fg = M.palette.peach, style = M.styles.keywords or {} }, -- For constant that are built in the language: nil in Lua.
    ["@constant.macro"] = { link = "Macro" }, -- For constants that are defined by macros: NULL in C.

    ["@module"] = { fg = M.palette.yellow, style = M.styles.miscs or { "italic" } }, -- For identifiers referring to modules and namespaces.
    ["@label"] = { link = "Label" }, -- For labels: label: in C and :label: in Lua.

    -- Literals
    ["@string"] = { link = "String" }, -- For strings.
    ["@string.documentation"] = { fg = M.palette.teal, style = M.styles.strings or {} }, -- For strings documenting code (e.g. Python docstrings).
    ["@string.regexp"] = { fg = M.palette.pink, style = M.styles.strings or {} }, -- For regexes.
    ["@string.escape"] = { fg = M.palette.pink, style = M.styles.strings or {} }, -- For escape characters within a string.
    ["@string.special"] = { link = "Special" }, -- other special strings (e.g. dates)
    ["@string.special.path"] = { link = "Special" }, -- filenames
    ["@string.special.symbol"] = { fg = M.palette.flamingo }, -- symbols or atoms
    ["@string.special.url"] = { fg = M.palette.blue, style = { "italic", "underline" } }, -- urls, links and emails
    ["@punctuation.delimiter.regex"] = { link = "@string.regexp" },

    ["@character"] = { link = "Character" }, -- character literals
    ["@character.special"] = { link = "SpecialChar" }, -- special characters (e.g. wildcards)

    ["@boolean"] = { link = "Boolean" }, -- For booleans.
    ["@number"] = { link = "Number" }, -- For all numbers
    ["@number.float"] = { link = "Float" }, -- For floats.

    -- Types
    ["@type"] = { link = "Type" }, -- For types.
    ["@type.builtin"] = { fg = M.palette.mauve, style = M.styles.properties or { "italic" } }, -- For builtin types.
    ["@type.definition"] = { link = "Type" }, -- type definitions (e.g. `typedef` in C)

    ["@attribute"] = { link = "Constant" }, -- attribute annotations (e.g. Python decorators)
    ["@property"] = { fg = M.palette.lavender, style = M.styles.properties or {} }, -- For fields, like accessing `bar` property on `foo.bar`. Overriden later for data languages and CSS.

    -- Functions
    ["@function"] = { link = "Function" }, -- For function (calls and definitions).
    ["@function.builtin"] = { fg = M.palette.peach, style = M.styles.functions or {} }, -- For builtin functions: table.insert in Lua.
    ["@function.call"] = { link = "Function" }, -- function calls
    ["@function.macro"] = { fg = M.palette.pink, style = M.styles.functions or {} }, -- For macro defined functions (calls and definitions): each macro_rules in Rust.

    ["@function.method"] = { link = "Function" }, -- For method definitions.
    ["@function.method.call"] = { link = "Function" }, -- For method calls.

    ["@constructor"] = { fg = M.palette.yellow }, -- For constructor calls and definitions: = { } in Lua, and Java constructors.
    ["@operator"] = { link = "Operator" }, -- For any operator: +, but also -> and * in C.

    -- Keywords
    ["@keyword"] = { link = "Keyword" }, -- For keywords that don't fall in previous categories.
    ["@keyword.modifier"] = { link = "Keyword" }, -- For keywords modifying other constructs (e.g. `const`, `static`, `public`)
    ["@keyword.type"] = { link = "Keyword" }, -- For keywords describing composite types (e.g. `struct`, `enum`)
    ["@keyword.coroutine"] = { link = "Keyword" }, -- For keywords related to coroutines (e.g. `go` in Go, `async/await` in Python)
    ["@keyword.function"] = { fg = M.palette.mauve, style = M.styles.keywords or {} }, -- For keywords used to define a function.
    ["@keyword.operator"] = { fg = M.palette.mauve, style = M.styles.keywords or {} }, -- For new keyword operator
    ["@keyword.import"] = { link = "Include" }, -- For includes: #include in C, use or extern crate in Rust, or require in Lua.
    ["@keyword.repeat"] = { link = "Repeat" }, -- For keywords related to loops.
    ["@keyword.return"] = { fg = M.palette.mauve, style = M.styles.keywords or {} },
    ["@keyword.debug"] = { link = "Exception" }, -- For keywords related to debugging
    ["@keyword.exception"] = { link = "Exception" }, -- For exception related keywords.

    ["@keyword.conditional"] = { link = "Conditional" }, -- For keywords related to conditionnals.
    ["@keyword.conditional.ternary"] = { link = "Operator" }, -- For ternary operators (e.g. `?` / `:`)

    ["@keyword.directive"] = { link = "PreProc" }, -- various preprocessor directives & shebangs
    ["@keyword.directive.define"] = { link = "Define" }, -- preprocessor definition directives
    -- JS & derivative
    ["@keyword.export"] = { fg = M.palette.mauve, style = M.styles.keywords },

    -- Punctuation
    ["@punctuation.delimiter"] = { link = "Delimiter" }, -- For delimiters (e.g. `;` / `.` / `,`).
    ["@punctuation.bracket"] = { fg = M.palette.red }, -- For brackets and parenthesis.
    ["@punctuation.special"] = { fg = M.palette.red }, -- For special punctuation that does not fall in the categories before (e.g. `{}` in string interpolation).

    -- Comment
    ["@comment"] = { link = "Comment" },
    ["@comment.documentation"] = { link = "Comment" }, -- For comments documenting code

    ["@comment.error"] = { fg = M.palette.base, bg = M.palette.red },
    ["@comment.warning"] = { fg = M.palette.base, bg = M.palette.yellow },
    ["@comment.hint"] = { fg = M.palette.base, bg = M.palette.blue },
    ["@comment.todo"] = { fg = M.palette.base, bg = M.palette.flamingo },
    ["@comment.note"] = { fg = M.palette.base, bg = M.palette.rosewater },

    -- Markup
    ["@markup"] = { fg = M.palette.text }, -- For strings considerated text in a markup language.
    ["@markup.strong"] = { fg = M.palette.red, style = { "bold" } }, -- bold
    ["@markup.italic"] = { fg = M.palette.red, style = { "italic" } }, -- italic
    ["@markup.strikethrough"] = { fg = M.palette.text, style = { "strikethrough" } }, -- strikethrough text
    ["@markup.underline"] = { link = "Underlined" }, -- underlined text

    ["@markup.heading"] = { fg = M.palette.surface1 }, -- titles like: # Example
    ["@markup.heading.markdown"] = { fg = M.palette.lavender, style = { "bold" } }, -- bold headings in markdown, but not in HTML or other markup

    ["@markup.math"] = { fg = M.palette.blue }, -- math environments (e.g. `$ ... $` in LaTeX)
    ["@markup.quote"] = { fg = M.palette.pink }, -- block quotes
    ["@markup.environment"] = { fg = M.palette.pink }, -- text environments of markup languages
    ["@markup.environment.name"] = { fg = M.palette.blue }, -- text indicating the type of an environment

    ["@markup.link"] = { fg = M.palette.lavender }, -- text references, footnotes, citations, etc.
    ["@markup.link.label"] = { fg = M.palette.lavender }, -- link, reference descriptions
    ["@markup.link.url"] = { fg = M.palette.blue, style = { "italic", "underline" } }, -- urls, links and emails

    ["@markup.raw"] = { fg = M.palette.green }, -- used for inline code in markdown and for doc in python (""")

    ["@markup.list"] = { fg = M.palette.teal },
    ["@markup.list.checked"] = { fg = M.palette.green }, -- todo notes
    ["@markup.list.unchecked"] = { fg = M.palette.red }, -- todo notes
    ["@markup.list.todo"] = { fg = M.palette.blue }, -- todo notes

    -- Diff
    ["@diff.plus"] = { link = "diffAdded" }, -- added text (for diff files)
    ["@diff.minus"] = { link = "diffRemoved" }, -- deleted text (for diff files)
    ["@diff.delta"] = { link = "diffChanged" }, -- deleted text (for diff files)

    -- Tags
    ["@tag"] = { fg = M.palette.blue }, -- Tags like HTML tag names.
    ["@tag.builtin"] = { fg = M.palette.blue }, -- JSX tag names.
    ["@tag.attribute"] = { fg = M.palette.yellow, style = M.styles.miscs or { "italic" } }, -- XML/HTML attributes (foo in foo="bar").
    ["@tag.delimiter"] = { fg = M.palette.teal }, -- Tag delimiter like < > /

    -- Misc
    ["@error"] = { link = "Error" },

    -- Language specific:

    -- Bash
    ["@function.builtin.bash"] = { fg = M.palette.red, style = M.styles.miscs or { "italic" } },
    ["@variable.parameter.bash"] = { fg = M.palette.green },

    -- markdown
    ["@markup.heading.1.markdown"] = { fg = M.palette.base, bg = M.palette.blue, bold = true },
    ["@markup.heading.2.markdown"] = { fg = M.palette.base, bg = M.palette.mauve, bold = true },
    ["@markup.heading.3.markdown"] = { fg = M.palette.base, bg = M.palette.peach, bold = true },
    ["@markup.heading.4.markdown"] = { fg = M.palette.base, bg = M.palette.green, bold = true },
    ["@markup.heading.5.markdown"] = { fg = M.palette.base, bg = M.palette.yellow, bold = true },
    ["@markup.heading.6.markdown"] = { fg = M.palette.base, bg = M.palette.teal, bold = true },

    -- Java
    ["@constant.java"] = { fg = M.palette.teal },

    -- CSS
    ["@property.css"] = { fg = M.palette.blue },
    ["@property.scss"] = { fg = M.palette.blue },
    ["@property.id.css"] = { fg = M.palette.yellow },
    ["@property.class.css"] = { fg = M.palette.yellow },
    ["@type.css"] = { fg = M.palette.lavender },
    ["@type.tag.css"] = { fg = M.palette.blue },
    ["@string.plain.css"] = { fg = M.palette.text },
    ["@number.css"] = { fg = M.palette.peach },
    ["@keyword.directive.css"] = { link = "Keyword" }, -- CSS at-rules: https://developer.mozilla.org/en-US/docs/Web/CSS/At-rule.

    -- HTML
    ["@string.special.url.html"] = { fg = M.palette.green }, -- Links in href, src attributes.
    ["@markup.link.label.html"] = { fg = M.palette.text }, -- Text between <a></a> tags.
    ["@character.special.html"] = { fg = M.palette.red }, -- Symbols such as &nbsp;.

    -- Lua
    ["@constructor.lua"] = { link = "@punctuation.bracket" }, -- For constructor calls and definitions: = { } in Lua.

    -- Python
    ["@constructor.python"] = { fg = M.palette.sky }, -- __init__(), __new__().

    -- YAML
    ["@label.yaml"] = { fg = M.palette.yellow }, -- Anchor and alias names.

    -- Ruby
    ["@string.special.symbol.ruby"] = { fg = M.palette.flamingo },

    -- PHP
    ["@function.method.php"] = { link = "Function" },
    ["@function.method.call.php"] = { link = "Function" },

    -- C/CPP
    ["@keyword.import.c"] = { fg = M.palette.yellow },
    ["@keyword.import.cpp"] = { fg = M.palette.yellow },

    -- C#
    ["@attribute.c_sharp"] = { fg = M.palette.yellow },

    -- gitcommit
    ["@comment.warning.gitcommit"] = { fg = M.palette.yellow },

    -- gitignore
    ["@string.special.path.gitignore"] = { fg = M.palette.text },
    ["FloatBorder"] = { fg = M.palette.base },
    -- Misc
    gitcommitSummary = { fg = M.palette.rosewater, style = M.styles.miscs or { "italic" } },
    zshKSHFunction = { link = "Function" },
  },
}
polish_hl["@parameter"] = polish_hl["@variable.parameter"]
polish_hl["@field"] = polish_hl["@variable.member"]
polish_hl["@namespace"] = polish_hl["@module"]
polish_hl["@float"] = polish_hl["@number.float"]
polish_hl["@symbol"] = polish_hl["@string.special.symbol"]
polish_hl["@string.regex"] = polish_hl["@string.regexp"]

polish_hl["@text"] = polish_hl["@markup"]
polish_hl["@text.strong"] = polish_hl["@markup.strong"]
polish_hl["@text.emphasis"] = polish_hl["@markup.italic"]
polish_hl["@text.underline"] = polish_hl["@markup.underline"]
polish_hl["@text.strike"] = polish_hl["@markup.strikethrough"]
polish_hl["@text.uri"] = polish_hl["@markup.link.url"]
polish_hl["@text.math"] = polish_hl["@markup.math"]
polish_hl["@text.environment"] = polish_hl["@markup.environment"]
polish_hl["@text.environment.name"] = polish_hl["@markup.environment.name"]

polish_hl["@text.title"] = polish_hl["@markup.heading"]
polish_hl["@text.literal"] = polish_hl["@markup.raw"]
polish_hl["@text.reference"] = polish_hl["@markup.link"]

polish_hl["@text.todo.checked"] = polish_hl["@markup.list.checked"]
polish_hl["@text.todo.unchecked"] = polish_hl["@markup.list.unchecked"]

polish_hl["@comment.note"] = polish_hl["@comment.hint"]

-- @text.todo is now for todo comments, not todo notes like in markdown
polish_hl["@text.todo"] = polish_hl["@comment.todo"]
polish_hl["@text.warning"] = polish_hl["@comment.warning"]
polish_hl["@text.note"] = polish_hl["@comment.note"]
polish_hl["@text.danger"] = polish_hl["@comment.error"]

-- @text.uri is now
-- > @markup.link.url in markup links
-- > @string.special.url outside of markup
polish_hl["@text.uri"] = polish_hl["@markup.link.uri"]

polish_hl["@method"] = polish_hl["@function.method"]
polish_hl["@method.call"] = polish_hl["@function.method.call"]

polish_hl["@text.diff.add"] = polish_hl["@diff.plus"]
polish_hl["@text.diff.delete"] = polish_hl["@diff.minus"]

polish_hl["@type.qualifier"] = polish_hl["@keyword.modifier"]
polish_hl["@keyword.storage"] = polish_hl["@keyword.modifier"]
polish_hl["@define"] = polish_hl["@keyword.directive.define"]
polish_hl["@preproc"] = polish_hl["@keyword.directive"]
polish_hl["@storageclass"] = polish_hl["@keyword.storage"]
polish_hl["@conditional"] = polish_hl["@keyword.conditional"]
polish_hl["@exception"] = polish_hl["@keyword.exception"]
polish_hl["@include"] = polish_hl["@keyword.import"]
polish_hl["@repeat"] = polish_hl["@keyword.repeat"]

polish_hl["@symbol.ruby"] = polish_hl["@string.special.symbol.ruby"]

polish_hl["@variable.member.yaml"] = polish_hl["@field.yaml"]

polish_hl["@text.title.1.markdown"] = polish_hl["@markup.heading.1.markdown"]
polish_hl["@text.title.2.markdown"] = polish_hl["@markup.heading.2.markdown"]
polish_hl["@text.title.3.markdown"] = polish_hl["@markup.heading.3.markdown"]
polish_hl["@text.title.4.markdown"] = polish_hl["@markup.heading.4.markdown"]
polish_hl["@text.title.5.markdown"] = polish_hl["@markup.heading.5.markdown"]
polish_hl["@text.title.6.markdown"] = polish_hl["@markup.heading.6.markdown"]

polish_hl["@method.php"] = polish_hl["@function.method.php"]
polish_hl["@method.call.php"] = polish_hl["@function.method.call.php"]

M.polish_hl = M.convert_style(polish_hl)

local function apply_dashboard_hl(tbl)
  for group, opts in pairs(tbl) do
    -- apply the highlight
    vim.api.nvim_set_hl(0, group, opts)
  end
end

apply_dashboard_hl(M.convert_style(polish_hl.custom))

apply_dashboard_hl(M.convert_style(polish_hl.neogit))
M.type = "dark"

M = require("base46").override_theme(M, "catppuccin-mochaa")

return M
