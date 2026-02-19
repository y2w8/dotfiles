local M = require "custom.catppuccin.header"

local lsp_styles = {
  virtual_text = {
    errors = { "italic" },
    hints = { "italic" },
    warnings = { "italic" },
    information = { "italic" },
    ok = { "italic" },
  },
  underlines = {
    errors = { "underline" },
    hints = { "underline" },
    warnings = { "underline" },
    information = { "underline" },
    ok = { "underline" },
  },
  inlay_hints = {
    background = true,
  },
}

local virtual_text = lsp_styles.virtual_text
local underlines = lsp_styles.underlines
local inlay_hints = lsp_styles.inlay_hints

local error = M.palette.red
local warning = M.palette.yellow
local info = M.palette.teal
local hint = M.palette.sapphire
local ok = M.palette.green
local darkening_percentage = 0.095

return {
		LspReferenceText = { bg = M.palette.surface1 }, -- used for highlighting "text" references
		LspReferenceRead = { bg = M.palette.surface1 }, -- used for highlighting "read" references
		LspReferenceWrite = { bg = M.palette.surface1 }, -- used for highlighting "write" references
		-- highlight diagnostics in numberline

		DiagnosticVirtualTextError = {
			bg = M.transparent_background and M.palette.none or M.darken(error, darkening_percentage, M.palette.base),
			fg = error,
			style = virtual_text.errors,
		}, -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
		DiagnosticVirtualTextWarn = {
			bg = M.transparent_background and M.palette.none or M.darken(warning, darkening_percentage, M.palette.base),
			fg = warning,
			style = virtual_text.warnings,
		}, -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
		DiagnosticVirtualTextInfo = {
			bg = M.transparent_background and M.palette.none or M.darken(info, darkening_percentage, M.palette.base),
			fg = info,
			style = virtual_text.information,
		}, -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
		DiagnosticVirtualTextHint = {
			bg = M.transparent_background and M.palette.none or M.darken(hint, darkening_percentage, M.palette.base),
			fg = hint,
			style = virtual_text.hints,
		}, -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
		DiagnosticVirtualTextOk = {
			bg = M.transparent_background and M.palette.none or M.darken(hint, darkening_percentage, M.palette.base),
			fg = ok,
			style = virtual_text.ok,
		}, -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default

		DiagnosticError = { bg = M.palette.none, fg = error, style = virtual_text.errors }, -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
		DiagnosticWarn = { bg = M.palette.none, fg = warning, style = virtual_text.warnings }, -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
		DiagnosticInfo = { bg = M.palette.none, fg = info, style = virtual_text.information }, -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
		DiagnosticHint = { bg = M.palette.none, fg = hint, style = virtual_text.hints }, -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
		DiagnosticOk = { bg = M.palette.none, fg = ok, style = virtual_text.ok }, -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default

		DiagnosticUnderlineError = { style = underlines.errors, sp = error }, -- Used to underline "Error" diagnostics
		DiagnosticUnderlineWarn = { style = underlines.warnings, sp = warning }, -- Used to underline "Warn" diagnostics
		DiagnosticUnderlineInfo = { style = underlines.information, sp = info }, -- Used to underline "Info" diagnostics
		DiagnosticUnderlineHint = { style = underlines.hints, sp = hint }, -- Used to underline "Hint" diagnostics
		DiagnosticUnderlineOk = { style = underlines.ok, sp = ok }, -- Used to underline "Ok" diagnostics

		DiagnosticFloatingError = { fg = error }, -- Used to color "Error" diagnostic messages in diagnostics float
		DiagnosticFloatingWarn = { fg = warning }, -- Used to color "Warn" diagnostic messages in diagnostics float
		DiagnosticFloatingInfo = { fg = info }, -- Used to color "Info" diagnostic messages in diagnostics float
		DiagnosticFloatingHint = { fg = hint }, -- Used to color "Hint" diagnostic messages in diagnostics float
		DiagnosticFloatingOk = { fg = ok }, -- Used to color "Ok" diagnostic messages in diagnostics float

		DiagnosticSignError = { fg = error }, -- Used for "Error" signs in sign column
		DiagnosticSignWarn = { fg = warning }, -- Used for "Warn" signs in sign column
		DiagnosticSignInfo = { fg = info }, -- Used for "Info" signs in sign column
		DiagnosticSignHint = { fg = hint }, -- Used for "Hint" signs in sign column
		DiagnosticSignOk = { fg = ok }, -- Used for "Ok" signs in sign column

		LspDiagnosticsDefaultError = { fg = error }, -- Used as the mantle highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
		LspDiagnosticsDefaultWarning = { fg = warning }, -- Used as the mantle highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
		LspDiagnosticsDefaultInformation = { fg = info }, -- Used as the mantle highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
		LspDiagnosticsDefaultHint = { fg = hint }, -- Used as the mantle highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
		LspSignatureActiveParameter = { bg = M.palette.surface0, style = { "bold" } },
		-- LspDiagnosticsFloatingError         = { }, -- Used to color "Error" diagnostic messages in diagnostics float
		-- LspDiagnosticsFloatingWarning       = { }, -- Used to color "Warning" diagnostic messages in diagnostics float
		-- LspDiagnosticsFloatingInformation   = { }, -- Used to color "Information" diagnostic messages in diagnostics float
		-- LspDiagnosticsFloatingHint          = { }, -- Used to color "Hint" diagnostic messages in diagnostics float

		LspDiagnosticsError = { fg = error },
		LspDiagnosticsWarning = { fg = warning },
		LspDiagnosticsInformation = { fg = info },
		LspDiagnosticsHint = { fg = hint },
		LspDiagnosticsVirtualTextError = { fg = error, style = virtual_text.errors }, -- Used for "Error" diagnostic virtual text
		LspDiagnosticsVirtualTextWarning = { fg = warning, style = virtual_text.warnings }, -- Used for "Warning" diagnostic virtual text
		LspDiagnosticsVirtualTextInformation = { fg = info, style = virtual_text.warnings }, -- Used for "Information" diagnostic virtual text
		LspDiagnosticsVirtualTextHint = { fg = hint, style = virtual_text.hints }, -- Used for "Hint" diagnostic virtual text
		LspDiagnosticsUnderlineError = { style = underlines.errors, sp = error }, -- Used to underline "Error" diagnostics
		LspDiagnosticsUnderlineWarning = { style = underlines.warnings, sp = warning }, -- Used to underline "Warning" diagnostics
		LspDiagnosticsUnderlineInformation = { style = underlines.information, sp = info }, -- Used to underline "Information" diagnostics
		LspDiagnosticsUnderlineHint = { style = underlines.hints, sp = hint }, -- Used to underline "Hint" diagnostics
		LspCodeLens = { fg = M.palette.overlay0 }, -- virtual text of the codelens
		LspCodeLensSeparator = { link = "LspCodeLens" }, -- virtual text of the codelens separators
		LspInlayHint = {
			-- fg of `Comment`
			fg = M.palette.overlay0,
			-- bg of `CursorLine`
			bg = (M.transparent_background or not inlay_hints.background) and M.palette.none
				or M.darken(M.palette.surface0, 0.64, M.palette.base),
		}, -- virtual text of the inlay hints
		LspInfoBorder = { link = "FloatBorder" }, -- LspInfo border
}

