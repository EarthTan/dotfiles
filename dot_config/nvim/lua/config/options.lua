-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 开启系统剪贴板互通
vim.opt.clipboard:append("unnamedplus")

-- 剪贴板ssh连接
vim.opt.clipboard = "unnamedplus"

local in_ssh = vim.env.SSH_CONNECTION ~= nil or vim.env.SSH_TTY ~= nil
if in_ssh then
  local ok, osc52 = pcall(require, "vim.ui.clipboard.osc52")
  if ok then
    -- SSH 下替换 provider 为 OSC52，clipboard 选项保持不动
    vim.g.clipboard = {
      name = "OSC 52",
      copy = {
        ["+"] = osc52.copy("+"),
        ["*"] = osc52.copy("*"),
      },
      paste = {
        ["+"] = osc52.paste("+"),
        ["*"] = osc52.paste("*"),
      },
    }
  end
end

-- 将系统PATH加载给 LazyVim
local function sync_shell_path()
  local shell = os.getenv("SHELL") or "/bin/sh"
  -- 用 printf 避免换行符问题，-l 确保加载 .zshrc/.bashrc 等
  local handle = io.popen(shell .. ' -l -c \'printf "%s" "$PATH"\'')
  if not handle then
    return
  end
  local path = handle:read("*a")
  handle:close()
  if path and path ~= "" then
    vim.env.PATH = path
  end
end

sync_shell_path()
