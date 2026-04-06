local M = require "custom.catppuccin.header"

return {
    NeogitCommitViewDescription = {
      fg = M.palette.text
    },
    NeogitBranchHead = {
      fg = M.palette.rosewater,
      underline = true
    },
    NeogitSignatureNone = {
      fg = M.palette.peach
    },
    NeogitDiffContextCursor = {
      link = "NeogitHunkHeaderHighlight"
    },
    NeogitActiveItem = {
      link = "NeogitHunkHeaderHighlight"
    },
		NeogitBranch = {
			fg = M.palette.yellow,
			style = { "bold" },
		},
		NeogitRemote = {
			fg = M.palette.yellow,
			style = { "bold" },
		},
		NeogitUnmergedInto = {
			link = "Function",
		},
		NeogitUnpulledFrom = {
			link = "Function",
		},
		NeogitObjectId = {
			fg = M.palette.red
		},
		NeogitStash = {
			link = "Comment",
		},
		NeogitRebaseDone = {
			link = "Comment",
		},
		NeogitHunkHeader = {
			bg = M.darken(M.palette.blue, 0.095, M.palette.base),
			fg = M.darken(M.palette.blue, 0.5, M.palette.base),
		},
		NeogitHunkHeaderHighlight = {
			bg = M.darken(M.palette.blue, 0.215, M.palette.base),
			fg = M.palette.blue,
		},
		NeogitDiffContextHighlight = {
			bg = M.palette.surface0,
		},
		NeogitDiffDeleteHighlight = {
      link = "NeogitDiffDelete"
		},
    NeogitDiffDeleteInline = {
      bg = M.palette.red,
      fg = M.palette.base
    },
    DiffDelete = { link = "NeogitDiffDelete" },
		NeogitDiffAddHighlight = {
      link = "NeogitDiffAdd"
		},
    NeogitDiffAddInline = {
      bg = M.palette.green,
      fg = M.palette.base
    },
    DiffAdd = { link = "NeogitDiffAdd" },
		NeogitDiffDelete = {
			bg = M.darken(M.palette.red, 0.300, M.palette.base),
			fg = M.darken(M.palette.red, 0.800, M.palette.base),
		},
		NeogitDiffAdd = {
			bg = M.darken(M.palette.green, 0.300, M.palette.base),
			fg = M.darken(M.palette.green, 0.800, M.palette.base),
		},
		NeogitCommitViewHeader = {
      link = "DiffModified"
		},
		NeogitChangeModified = {
			fg = M.palette.peach,
			style = { "bold" },
		},
		NeogitChangeDeleted = {
			fg = M.palette.red,
			style = { "bold" },
		},
		NeogitChangeAdded = {
			fg = M.palette.green,
			style = { "bold" },
		},
		NeogitChangeRenamed = {
			fg = M.palette.mauve,
			style = { "bold" },
		},
		NeogitChangeUpdated = {
			fg = M.palette.peach,
			style = { "bold" },
		},
		NeogitChangeCopied = {
			fg = M.palette.pink,
			style = { "bold" },
		},
		NeogitChangeBothModified = {
			fg = M.palette.yellow,
			style = { "bold" },
		},
		NeogitChangeNewFile = {
			fg = M.palette.green,
			style = { "bold" },
		},
		NeogitUntrackedfiles = {
			fg = M.palette.blue,
			style = { "bold" },
		},
		NeogitUnstagedchanges = {
			fg = M.palette.blue,
			style = { "bold" },
		},
		NeogitUnmergedchanges = {
			fg = M.palette.blue,
			style = { "bold" },
		},
		NeogitUnpulledchanges = {
			fg = M.palette.blue,
			style = { "bold" },
		},
		NeogitRecentcommits = {
			fg = M.palette.blue,
			style = { "bold" },
		},
		NeogitStagedchanges = {
			fg = M.palette.blue,
			style = { "bold" },
		},
		NeogitStashes = {
			fg = M.palette.blue,
			style = { "bold" },
		},
		NeogitRebasing = {
			fg = M.palette.blue,
			style = { "bold" },
		},
		NeogitNotificationInfo = {
			fg = M.palette.blue,
		},
		NeogitNotificationWarning = {
			fg = M.palette.yellow,
		},
		NeogitNotificationError = {
			fg = M.palette.red,
		},
		NeogitGraphRed = {
			fg = M.palette.red,
		},
		NeogitGraphWhite = {
			fg = M.palette.base,
		},
		NeogitGraphYellow = {
			fg = M.palette.yellow,
		},
		NeogitGraphGreen = {
			fg = M.palette.green,
		},
		NeogitGraphCyan = {
			fg = M.palette.blue,
		},
		NeogitGraphBlue = {
			fg = M.palette.blue,
		},
		NeogitGraphPurple = {
			fg = M.palette.lavender,
		},
		NeogitGraphGray = {
			fg = M.palette.subtext1,
		},
		NeogitGraphOrange = {
			fg = M.palette.peach,
		},
		NeogitGraphBoldRed = {
			fg = M.palette.red,
			style = { "bold" },
		},
		NeogitGraphBoldWhite = {
			fg = M.palette.white,
			style = { "bold" },
		},
		NeogitGraphBoldYellow = {
			fg = M.palette.yellow,
			style = { "bold" },
		},
		NeogitGraphBoldGreen = {
			fg = M.palette.green,
			style = { "bold" },
		},
		NeogitGraphBoldCyan = {
			fg = M.palette.blue,
			style = { "bold" },
		},
		NeogitGraphBoldBlue = {
			fg = M.palette.blue,
			style = { "bold" },
		},
		NeogitGraphBoldPurple = {
			fg = M.palette.lavender,
			style = { "bold" },
		},
		NeogitGraphBoldGray = {
			fg = M.palette.subtext1,
			style = { "bold" },
		},
		NeogitDiffContext = {
			bg = M.palette.base,
		},
		NeogitPopupBold = {
			style = { "bold" },
		},
		NeogitPopupSwitchKey = {
			fg = M.palette.lavender,
		},
		NeogitPopupOptionKey = {
			fg = M.palette.lavender,
		},
		NeogitPopupConfigKey = {
			fg = M.palette.lavender,
		},
		NeogitPopupActionKey = {
			fg = M.palette.lavender,
		},
		NeogitFilePath = {
			fg = M.palette.blue,
			style = { "italic" },
		},
		NeogitDiffHeader = {
			bg = M.palette.base,
			fg = M.palette.blue,
			style = { "bold" },
		},
		NeogitDiffHeaderHighlight = {
			bg = M.palette.base,
			fg = M.palette.peach,
			style = { "bold" },
		},
		NeogitUnpushedTo = {
			fg = M.palette.lavender,
			style = { "bold" },
		},
		NeogitFold = {
			fg = M.palette.none,
			bg = M.palette.none,
		},
		NeogitSectionHeader = {
			fg = M.palette.mauve,
			style = { "bold" },
		},
		NeogitTagName = {
			fg = M.palette.yellow,
		},
		NeogitTagDistance = {
			fg = M.palette.blue,
		},
		NeogitWinSeparator = {
			link = "WinSeparator",
		},
  }
