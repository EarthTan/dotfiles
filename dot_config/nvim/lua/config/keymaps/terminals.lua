-- <C-/> 的时候，终端默认打开位置换到右边 --
vim.keymap.del({ "n", "t" }, "<C-/>")
vim.keymap.set({ "n", "t" }, "<C-/>", function()
  Snacks.terminal.toggle(nil, {
    win = {
      id = "right_terminal",
      position = "right",
      width = 0.4,
    },
  })
end, { desc = "Terminal (Right)" })

-- 新建终端 --
vim.keymap.set("n", "<leader>tn", function()
  vim.cmd("enew")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "New Fullscreen Terminal (Tab)" })
