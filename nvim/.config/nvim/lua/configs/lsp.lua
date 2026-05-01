require("nvchad.configs.lspconfig").defaults()
vim.diagnostic.config { virtual_text = false }

require("mason-lspconfig").setup {
  automatic_enable = {
    exclude = {
      "rust_analyzer",
      "ron_lsp",
    },
  },
}

vim.lsp.config("*", {
  root_markers = { ".git" },
})

-- mason_lsp.setup_handlers({
--   function(server_name)
--     lspconfig[server_name].setup({})
--   end,
-- })
