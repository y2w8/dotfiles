return {
    winbar = {
        show = true,
        -- You can add a "console" section to merge the terminal with the other views
        sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
        -- Must be one of the sections declared above
        default_section = "console",
        -- Configure each section individually
        base_sections = {
            breakpoints = {
                keymap = "B",
                label = "Breakpoints [B]",
                short_label = " [B]",
            },
            scopes = {
                keymap = "S",
                label = "Scopes [S]",
                short_label = "󰂥 [S]",
            },
            exceptions = {
                keymap = "E",
                label = "Exceptions [E]",
                short_label = "󰢃 [E]",
            },
            watches = {
                keymap = "W",
                label = "Watches [W]",
                short_label = "󰛐 [W]",
            },
            threads = {
                keymap = "T",
                label = "Threads [T]",
                short_label = "󱉯 [T]",
            },
            repl = {
                keymap = "R",
                label = "REPL [R]",
                short_label = "󰯃 [R]",
            },
            sessions = {
                keymap = "K", -- I ran out of mnemonics
                label = "Sessions [K]",
                short_label = " [K]",
            },
            console = {
                keymap = "C",
                label = "Console [C]",
                short_label = "󰆍 [C]",
            },
        },
        -- Add your own sections
        custom_sections = {},
        controls = {
            enabled = false,
            position = "right",
            buttons = {
                "play",
                "step_into",
                "step_over",
                "step_out",
                "step_back",
                "run_last",
                "terminate",
                "disconnect",
            },
            custom_buttons = {},
        },
    },
    windows = {
        height = 0.25,
        position = "below",
        terminal = {
            width = 0.5,
            position = "left",
            -- List of debug adapters for which the terminal should be ALWAYS hidden
            hide = {},
            -- Hide the terminal when starting a new session
            start_hidden = true,
        },
    },
    icons = {
        disabled = "",
        disconnect = "",
        enabled = "",
        filter = "󰈲",
        negate = " ",
        pause = "",
        play = "",
        run_last = "",
        step_back = "",
        step_into = "",
        step_out = "",
        step_over = "",
        terminate = "",
    },
    help = {
        border = nil,
    },
    render = {
        -- Optionally a function that takes two `dap.Variable`'s as arguments
        -- and is forwarded to a `table.sort` when rendering variables in the scopes view
        sort_variables = nil,
    },
    -- Controls how to jump when selecting a breakpoint or navigating the stack
    -- Comma separated list, like the built-in 'switchbuf'. See :help 'switchbuf'
    -- Only a subset of the options is available: newtab, useopen, usetab and uselast
    -- Can also be a function that takes the current winnr and the bufnr that will jumped to
    -- If a function, should return the winnr of the destination window
    switchbuf = "usetab,uselast",
    -- Auto open when a session is started and auto close when all sessions finish
    auto_toggle = false,
    -- Reopen dapview when switching to a different tab
    -- Can also be a function to dynamically choose when to follow, by returning a boolean
    -- If a function, receives the name of the adapter for the current session as an argument
    follow_tab = false,
}
