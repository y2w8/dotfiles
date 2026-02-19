require("toggleterm").setup {
  size = 20,
  open_mapping = [[<c-;>]], -- المفتاح الأساسي للفتح والقفل
  hide_numbers = true,
  shade_terminals = true,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = "horizontal", -- يفتح Split تحت مثل ما كنت تبي
  close_on_exit = true,
  shell = vim.o.shell,
}
local term = require("toggleterm")

-- 1. دالة لفتح تيرمينال جديد بالرقم التالي (مثل علامة +)
vim.keymap.set("n", "<leader>tt", function()
    -- نجيب كل التيرمينالات المفتوحة عشان نعرف كم عددها
    local all_terms = require("toggleterm.terminal").get_all()
    -- نفتح التيرمينال اللي عليه الدور (العدد الحالي + 1)
    term.toggle(#all_terms + 1)
end, { desc = "New Terminal (Next ID)" })

-- 2. التنقل الذكي (Tabs Navigation)
-- نستخدم <C-\><C-n> عشان يشتغل الاختصار وأنت داخل التيرمينال بدون مشاكل
vim.keymap.set({ "n", "t" }, "<S-l>", [[<C-\><C-n><Cmd>ToggleTermNext<CR>]], { desc = "Next Terminal" })
vim.keymap.set({ "n", "t" }, "<S-h>", [[<C-\><C-n><Cmd>ToggleTermPrev<CR>]], { desc = "Prev Terminal" })

-- 3. قائمة اختيار التيرمينال (كأنه Tab Switcher)
vim.keymap.set({ "n", "t" }, "<C-/>", [[<C-\><C-n><Cmd>TermSelect<CR>]], { desc = "Select Terminal" })
