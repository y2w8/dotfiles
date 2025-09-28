return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "TmuxNavigateDown" },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "TmuxNavigateUp" },
    { "<c-l>", ":TmuxNavigateRight<cr>", desc = "TmuxNavigateRight" },
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "TmuxNavigatePrevious" },
  },
}
