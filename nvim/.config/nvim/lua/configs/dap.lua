local dap = require("dap")
local dapview = require("dap-view")
local map = vim.keymap.set

map('n', '<leader>db', dap.toggle_breakpoint, { desc = "Toggle breakpoint"})
map('n', '<leader>dc', dap.continue, { desc = "Dap continue"})
map('n', '<leader>dr', dap.restart, { desc = "Dap restart"})
map('n', '<leader>dx', dap.terminate, { desc = "Dap terminate"})

dap.listeners.after['event_initialized']['me'] = function()
  dapview.open()
end
dap.listeners.after['event_terminated']['me'] = function()
  dapview.close()
end
dap.listeners.after['event_exited']['me'] = function()
  dapview.close()
end


vim.fn.sign_define("DapBreakpoint", {
  text = "", -- icon in the column
  texthl = "DiagnosticError",
  linehl = "",
  numhl = ""
})

vim.fn.sign_define("DapBreakpointRejected", {
  text = "",
  texthl = "DiagnosticWarn",
  linehl = "",
  numhl = ""
})

vim.fn.sign_define("DapStopped", {
  text = "", -- arrow where debugger is stopped
  texthl = "DiagnosticInfo",
  linehl = "Visual", -- highlight whole line
  numhl = ""
})

require("nvim-dap-virtual-text").setup {
    enabled = true,                        -- enable this plugin (the default)
    enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason = true,               -- show stop reason when stopped for exceptions
    commented = false,                     -- prefix virtual text with comment string
    only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
    all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
    clear_on_continue = false,             -- clear virtual text on "continue" (might cause flickering when stepping)
    --- A callback that determines how a variable is displayed or whether it should be omitted
    --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
    --- @param buf number
    --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
    --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
    --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
    --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
    display_callback = function(variable, buf, stackframe, node, options)
    -- by default, strip out new line characters
      if options.virt_text_pos == 'inline' then
        return ' = ' .. variable.value:gsub("%s+", " ")
      else
        return variable.name .. ' = ' .. variable.value:gsub("%s+", " ")
      end
    end,
    -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
    virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

    -- experimental features:
    all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
                                           -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
}
