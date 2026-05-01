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

vim.lsp.config("ron_lsp", {
  cmd = { "ron-lsp" },

  filetypes = { "ron" },

  root_markers = { "Cargo.toml", ".git" },

  single_file_support = true,
})

vim.lsp.enable("ron_lsp")
-- mason_lsp.setup_handlers({
--   function(server_name)
--     lspconfig[server_name].setup({})
--   end,
-- })
