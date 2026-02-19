require("nvchad.configs.lspconfig").defaults()
-- local mason_lsp = require "mason-lspconfig"
--
require("mason-lspconfig").setup {
    automatic_enable = {
        exclude = {
            "rust_analyzer",
            "ts_ls"
        }
    }
}

vim.lsp.config("*", {
  root_markers = { ".git" },
})
-- mason_lsp.setup_handlers({
--   function(server_name)
--     lspconfig[server_name].setup({})
--   end,
-- })
