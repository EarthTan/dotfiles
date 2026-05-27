-- ~/.config/nvim/lua/plugins/colorizer.lua
return {
  "NvChad/nvim-colorizer.lua",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    filetypes = { "*" },
    user_default_options = {
      RGB = true, -- #RGB
      RRGGBB = true, -- #RRGGBB
      names = true, -- "red", "blue" 这种英文名
      RRGGBBAA = true, -- #RRGGBBAA
      rgb_fn = true, -- rgb() / rgba()
      hsl_fn = true, -- hsl() / hsla()
      css = true, -- 开启所有 css 特性
      mode = "background", -- 颜色块显示模式
    },
  },
}
