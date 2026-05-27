return {
  "hat0uma/csvview.nvim",
  cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  ft = { "csv", "tsv" },
  opts = { ... },
  config = function(_, opts)
    require("csvview").setup(opts)
    -- 打开 csv/tsv 自动启用
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "csv", "tsv" },
      callback = function()
        require("csvview").enable()
      end,
    })
  end,
}
