return {
  -- {
  --   "kristijanhusak/vim-dadbod-ui",
  --   enabled = false,
  --   dependencies = {
  --     { "tpope/vim-dadbod", lazy = true },
  --     -- { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
  --   },
  --   cmd = {
  --     "DBUI",
  --     "DBUIToggle",
  --     "DBUIAddConnection",
  --     "DBUIFindBuffer",
  --   },
  --   init = function()
  --     -- Your DBUI configuration
  --     vim.g.db_ui_use_nerd_fonts = 1
  --   end,
  -- },

  {
    "kndndrj/nvim-dbee",
    enabled = true,
    dependencies = {
      "MunifTanjim/nui.nvim",
      { "MattiasMTS/cmp-dbee", ft = "sql", opts = {} },
    },
    build = function()
      -- Install tries to automatically detect the install method.
      -- if it fails, try calling it with one of these parameters:
      --    "curl", "wget", "bitsadmin", "go"
      require("dbee").install()
    end,
    config = function()
      require("dbee").setup(--[[optional config]])
    end,
  },
}
