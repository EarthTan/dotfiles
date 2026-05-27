-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
require("config.keymaps.fileinfo")
require("config.keymaps.quick_execute")
require("config.keymaps.terminals")
require("config.keymaps.fileopen")

-- jk连按键退出插入模式 --
vim.o.timeoutlen = 300
vim.keymap.set("i", "jk", "<Esc>", { silent = true })
vim.keymap.set("t", "jk", [[<C-\><C-n>]], { noremap = true, silent = true }) -- 在终端中也使用jk退出插入模式

-- bufferline --
for i = 1, 9 do
  vim.keymap.set("n", "<leader>b" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", {
    desc = "Go to buffer " .. i,
  })
end

-- keymaps.lua
local wk = require("which-key")
wk.add({
  -- { "<leader>d", group = "Database" },
  -- { "<leader>dH", "<cmd>tabnew | term harlequin<cr>", desc = "Harlequin" },
  -- { "<leader>dD", "<cmd>tabnew | term harlequin -a duckdb<cr>", desc = "DuckDB" },
})
