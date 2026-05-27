return {
  "tnfru/nvim-venv-detector",
  event = "VimEnter", -- 官方推荐
  config = function()
    require("venv_detector").setup({ -- 注意：下划线
      auto_activate_venv = true, -- 自动设置 VIRTUAL_ENV 和 PATH
      auto_restart_lsp = true, -- 自动重启 Python LSP
      lsp_client_names = { -- 指定要重启的 LSP
        "pyright",
        "pylsp",
        "ruff",
        "basedpyright",
      },
      notify = true,
    })
  end,
}
