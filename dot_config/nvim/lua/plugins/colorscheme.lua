local uv = vim.uv

-- 检测操作系统
local function get_os()
  local sysname = uv.os_uname().sysname

  if sysname == "Darwin" then
    return "mac"
  elseif sysname == "Linux" then
    return "linux"
  elseif sysname == "Windows_NT" then
    return "windows"
  end

  return "unknown"
end

-- 按系统分配主题
local themes = {
  mac = "tokyonight",
  linux = "catppuccin",
  windows = "gruvbox",
  unknown = "tokyonight",
}

local current_theme = themes[get_os()] or themes.unknown

return {
  { "folke/tokyonight.nvim", lazy = true },
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "ellisonleao/gruvbox.nvim", lazy = true },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = current_theme,
    },
  },
}
