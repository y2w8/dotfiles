vim.keymap.set("n", "<leader>qs", function()
  require("persistence").load()
end, { desc = "Load session for current dir" })

vim.keymap.set("n", "<leader>qS", function()
  require("persistence").select()
end, { desc = "Select session" })

vim.keymap.set("n", "<leader>ql", function()
  require("persistence").load { last = true }
end, { desc = "Load last session" })

vim.keymap.set("n", "<leader>qd", function()
  require("persistence").stop()
end, { desc = "dont save this session" })

return {
  dir = vim.fn.stdpath "state" .. "/sessions/", -- directory where session files are saved
  -- minimum number of file buffers that need to be open to save
  -- Set to 0 to always save
  need = 1,
  branch = true, -- use git branch to save session
}
