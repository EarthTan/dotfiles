# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.



# 插件路径

LazyVim 用的是 lazy.nvim 作为插件管理器，插件仓库默认克隆到：

```
~/.local/share/nvim/lazy/
```

LazyVim 用的是 **lazy.nvim** 作为插件管理器，插件仓库默认克隆到：

```
~/.local/share/nvim/lazy/
```

每个插件是这个目录下的一个子文件夹，比如：

```
~/.local/share/nvim/lazy/
├── lazy.nvim/
├── telescope.nvim/
├── nvim-treesitter/
├── mason.nvim/
└── ...
```

------

几个相关路径也值得知道：

| 用途                      | 路径                            |
| ------------------------- | ------------------------------- |
| 插件本体（仓库克隆）      | `~/.local/share/nvim/lazy/`     |
| lazy.nvim 的配置/lockfile | `~/.config/nvim/lazy-lock.json` |
| 你自己的 LazyVim 配置     | `~/.config/nvim/`               |
| 运行时数据（state等）     | `~/.local/state/nvim/`          |

------

如果你想改默认路径，可以在 `lazy.nvim` 的 setup 里指定 `root`：

```lua
require("lazy").setup(plugins, {
  root = vim.fn.stdpath("data") .. "/lazy", -- 这是默认值
})
```

`vim.fn.stdpath("data")` 在 Linux/macOS 上就是 `~/.local/share/nvim`，所以拼起来就是上面那个路径。
