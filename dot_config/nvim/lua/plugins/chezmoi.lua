-- plugins/chezmoi.lua
return {
  "xvzc/chezmoi.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    edit = {
      watch = true, -- 是否监听文件变化自动 apply ----
      force = false,
    },
    events = {
      notification = {
        on_open = true, -- 打开时提示
        on_apply = true, -- apply 时提示
        on_watch = true,
      },
    },
  },
}
