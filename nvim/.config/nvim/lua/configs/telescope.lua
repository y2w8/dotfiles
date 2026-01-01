dofile(vim.g.base46_cache .. "telescope")
require('telescope').load_extension('glyph')
require("telescope").load_extension("fidget")
require("telescope").load_extension("undo")
require("telescope").load_extension("recent_files")

local fidget = require("fidget")

local function show_fidget_history_buf()
    local history_items = fidget.notification.get_history()

    if not history_items or #history_items == 0 then
        vim.notify("No fidget history available", vim.log.levels.WARN)
        return
    end

    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
    vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })

    local lines = {
        "== Fidget Notification History ==",
        "",
    }

    local highlights = {}

    for _, item in ipairs(history_items) do
        local lnum = #lines
        local timestamp = vim.fn.strftime("%c", item.last_updated)
        local group = item.group_name or "Notifications"
        local icon = item.annote or "ℹ"

        local header =
            "(" .. timestamp .. ") "
            .. group
            .. " | ["
            .. icon
            .. "]"

        table.insert(lines, header)

        -- timestamp (grey)
        table.insert(highlights, {
            line = lnum,
            start = 0,
            finish = #timestamp + 2,
            group = "Comment",
        })

        -- group name (pink)
        local group_start = header:find(group, 1, true) - 1
        table.insert(highlights, {
            line = lnum,
            start = group_start,
            finish = group_start + #group,
            group = "@character.special",
        })

        -- icon highlight
        local icon_start = header:find("%[", 1) - 1
        local icon_hl = "DiagnosticInfo"

        if icon:find("") then
            icon_hl = "DiagnosticWarn"
        elseif icon:find("") then
            icon_hl = "DiagnosticError"
        end

        table.insert(highlights, {
            line = lnum,
            start = icon_start,
            finish = #header,
            group = icon_hl,
        })

        -- message body
        for msg_line in vim.gsplit(item.message, "\n", { plain = true }) do
            table.insert(lines, "  " .. msg_line)
        end

        table.insert(lines, "")
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Apply highlights
    for _, hl in ipairs(highlights) do
        vim.api.nvim_buf_add_highlight(
            buf,
            -1,
            hl.group,
            hl.line,
            hl.start,
            hl.finish
        )
    end

    vim.cmd("split")
    vim.api.nvim_win_set_buf(0, buf)
    vim.api.nvim_buf_set_name(buf, "fidget://history.md")

    local opts = { buffer = buf, noremap = true, silent = true }
    vim.keymap.set("n", "q", "<cmd>close<cr>", opts)
end

-- local previewers = require "telescope.previewers"
vim.keymap.set("n", "<leader>th", function()
  require("nvchad.themes").open()
end, { desc = "telescope nvchad themes" })

vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
vim.keymap.set(
  "n",
  "<leader>fa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope find all files" }
)
vim.keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
vim.keymap.set("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
vim.keymap.set("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
vim.keymap.set("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "LSP Symbols" })
vim.keymap.set("n", "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<CR>", { desc = "LSP Workspace Symbols" })
vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", { desc = "LSP References" })
vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "LSP Implementations" })
vim.keymap.set("n", "<leader>fR", "<cmd>lua require('telescope').extensions.recent_files.pick()<CR>", { desc = "Recent Files" })
vim.keymap.set("n", "<leader>fH", "<cmd>Telescope help_tags<CR>", { desc = "󰁍Help Pages" })
vim.keymap.set("n", "<leader>fM", "<cmd>Telescope man_pages<CR>", { desc = "Man Pages" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope highlights<CR>", { desc = "Highlight" })
vim.keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })
vim.keymap.set("n", "<leader>f;", "<cmd>Telescope command_history<CR>", { desc = "Command History" })
vim.keymap.set("n", "<leader>fn", show_fidget_history_buf, { desc = "Notification History" })
vim.keymap.set("n", "<leader>fS", "<cmd>Telescope search_history<CR>", { desc = "Search History" })
vim.keymap.set("n", "<leader>fS", "<cmd>Telescope undo<CR>", { desc = "Undo History" })
vim.keymap.set("n", "<leader>fC", "<cmd>Telescope commands<CR>", { desc = "Commands" })
vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>fc", function()
  require('telescope.builtin').find_files({
    prompt_title = "Config Files",
    cwd = vim.fn.stdpath("config"), -- This points to ~/.config/nvim
  })
end, { desc = "Find config files" })

vim.keymap.set("n", "<leader>fi", "<cmd>Telescope glyph<CR>", { desc = "Icons" })

vim.keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "Branches" })
vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Status" })
vim.keymap.set("n", "<leader>gS", "<cmd>Telescope git_stash<CR>", { desc = "Stash" })
vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Commits" })

vim.keymap.set("n", "<leader>ft", "<cmd>Telescope<CR>", { desc = "Builtin" })

return {
  defaults = {
    prompt_prefix = "   ",
    selection_caret = " ",
    entry_prefix = " ",
    sorting_strategy = "ascending",

    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
      },
      width = 0.87,
      height = 0.80,
    },
    mappings = {
      n = { ["q"] = require("telescope.actions").close },
    },
  },
  -- pickers = {
  --   live_grep = {
  --     previewer = previewers.vim_buffer_cat.new, -- for grep specifically
  --   },
  --   grep_string = {
  --     previewer = previewers.vim_buffer_cat.new,
  --   },
  -- },
  extensions_list = { "themes", "terms" },
  extensions = {},
}


