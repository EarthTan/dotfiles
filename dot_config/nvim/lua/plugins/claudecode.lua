-- claudecode.nvim 配置
-- GitHub: https://github.com/coder/claudecode.nvim
-- 要求: Neovim >= 0.8.0 + Claude Code CLI
--
-- 快捷键说明:
--   <leader>a         +ai (ai 组前缀)
--   <leader>ac        打开/切换 Claude Code 终端 (:ClaudeCode)
--   <leader>af        聚焦 Claude 终端 (:ClaudeCodeFocus)
--   <leader>ar        从上次继续对话 (:ClaudeCode --resume)
--   <leader>aC        继续当前任务 (:ClaudeCode --continue)
--   <leader>ab        将当前 buffer 添加到上下文 (:ClaudeCodeAdd %)
--   <leader>as        发送选中内容到 Claude (visual 模式, :ClaudeCodeSend)
--   <leader>as        从文件树添加文件 (NvimTree/neo-tree/oil, :ClaudeCodeTreeAdd)
--   <leader>aa        接受 Claude 的 diff 修改 (:ClaudeCodeDiffAccept)
--   <leader>ad        拒绝 Claude 的 diff 修改 (:ClaudeCodeDiffDeny)
--
-- 配置说明:
--   terminal.split_width_percentage  侧边栏宽度比例 (0.0-1.0)，默认 0.30
--   terminal.snacks_win_opts          Snacks 浮动窗口配置，可覆盖 width
--   当前设置为 60%，通过 snacks_win_opts.width 明确指定

return {
  "coder/claudecode.nvim",
  opts = {
    terminal = {
      split_side = "right", -- "left" or "right"
      split_width_percentage = 0.30,
      provider = "snacks", -- "auto", "snacks", "native", "external", "none", or custom provider table
      auto_close = true,
      snacks_win_opts = {}, -- Opts to pass to `Snacks.terminal.open()` - see Floating Window section below

      -- Provider-specific options
    },
  },
}
