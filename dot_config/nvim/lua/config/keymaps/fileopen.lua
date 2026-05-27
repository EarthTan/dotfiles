local map = LazyVim.safe_keymap_set
local fileutil = require("config.keymaps.fileutil")

local function notify_error(msg)
  vim.notify(msg, vim.log.levels.ERROR)
end

local function open_with_system(cmd, label)
  vim.fn.jobstart(cmd, { detach = true })
  vim.notify(label)
end

-- 用系统默认程序打开当前文件
map("n", "<leader>o", function()
  local file = fileutil.get_target_file()
  if not file then
    return
  end

  local cmd
  if vim.fn.has("mac") == 1 then
    cmd = { "open", file }
  elseif vim.fn.has("win32") == 1 then
    cmd = { "rundll32", "url.dll,FileProtocolHandler", file }
  else
    cmd = { "xdg-open", file }
  end
  open_with_system(cmd, "已用默认程序打开：" .. file)
end, { desc = "系统默认程序打开当前文件" })

-- 打开当前文件所在文件夹
map("n", "<leader>O", function()
  local file = fileutil.get_target_file()
  if not file then
    return
  end

  local dir = vim.fn.fnamemodify(file, ":h")
  local cmd
  if vim.fn.has("mac") == 1 then
    cmd = { "open", dir }
  elseif vim.fn.has("win32") == 1 then
    cmd = { "explorer", dir }
  else
    cmd = { "xdg-open", dir }
  end
  open_with_system(cmd, "已打开文件夹：" .. dir)
end, { desc = "打开当前文件所在文件夹" })

-- 用 VSCode 打开项目根目录
map("n", "<leader>v", function()
  local dir
  if vim.fn.has("mac") == 1 or vim.fn.has("unix") == 1 then
    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")
    dir = git_root and git_root[1] and git_root[1] ~= "" and vim.fn.trim(git_root[1]) or vim.fn.getcwd()
  else
    dir = vim.fn.getcwd()
  end

  local cmd
  if vim.fn.has("mac") == 1 or vim.fn.has("unix") == 1 then
    cmd = { "code", dir }
  else
    cmd = { "cmd", "/c", "code", dir }
  end
  open_with_system(cmd, "已用 VSCode 打开项目：" .. dir)
end, { desc = "用 VSCode 打开项目根目录" })

