local mason_registry = require("mason-registry")
local codelldb = mason_registry.get_package("codelldb")
local extension_path = "/home/y2w8/.local/share/nvim/mason/packages/codelldb"
local codelldb_path = extension_path .. "/codelldb"
local liblldb_path = extension_path .. "/extension/lldb/lib/liblldb.so"  -- Linux


local cfg = require('rustaceanvim.config')
vim.g.rustaceanvim = {
  server = {
    on_attach = function(client, bufnr)
      vim.keymap.set('n', 'gT', "<cmd>RustLsp relatedDiagnostics<CR>", { desc = "LSP Related Diagnostics" })
      vim.keymap.set('n', 'gt', "<cmd>RustLsp renderDiagnostics<CR>", { desc = "LSP Render Diagnostics" })
      vim.keymap.set('n', 'gc', "<cmd>RustLsp openCargo<CR>", { desc = "LSP Cargo" })
      vim.keymap.set('n', 'go', "<cmd>RustLsp openDocs<CR>", { desc = "LSP Docs" })
      vim.keymap.set('n', 'go', "<cmd>RustLsp joinLines<CR>", { desc = "LSP join lines" })
    end,
  },
  dap = {
    adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
  },
}


