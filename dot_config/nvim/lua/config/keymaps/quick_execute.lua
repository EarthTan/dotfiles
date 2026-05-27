-- 快速运行当前文件 --
vim.keymap.set("n", "<C-CR>", function()
  local ft = vim.bo.filetype
  local file = vim.fn.shellescape(vim.fn.expand("%:p"))

  local python_cmd = "python3"

  if vim.env.VIRTUAL_ENV then
    python_cmd = vim.env.VIRTUAL_ENV .. "/bin/python"
  elseif vim.fn.isdirectory(".venv") == 1 then
    python_cmd = ".venv/bin/python"
  end

  local runners = {
    python = python_cmd .. " " .. file,
    javascript = "node " .. file,
    typescript = "ts-node " .. file,
    cpp = "g++ -Wall " .. file .. " -o /tmp/a.out && /tmp/a.out",
    c = "gcc -Wall " .. file .. " -o /tmp/a.out && /tmp/a.out",
    go = "go run " .. file,
    lua = "lua " .. file,
    sh = "bash " .. file,
  }

  local cmd = runners[ft]

  if not cmd then
    vim.notify("No runner for: " .. ft, vim.log.levels.WARN)
    return
  end

  -- runner 已存在
  if vim.g.runner_bufnr and vim.api.nvim_buf_is_valid(vim.g.runner_bufnr) then
    local wins = vim.fn.win_findbuf(vim.g.runner_bufnr)

    -- terminal 已经可见
    if #wins > 0 then
      vim.api.nvim_set_current_win(wins[1])
    else
      -- 在右侧打开 terminal
      vim.cmd("botright vsplit")
      vim.cmd("vertical resize 80")
      vim.cmd("buffer " .. vim.g.runner_bufnr)
    end

    local ok, chan_id = pcall(vim.api.nvim_buf_get_var, vim.g.runner_bufnr, "terminal_job_id")

    if ok then
      vim.fn.chansend(chan_id, "clear\r")
      vim.fn.chansend(chan_id, cmd .. "\r")
    else
      vim.notify("Runner terminal error", vim.log.levels.ERROR)
    end
  else
    -- 第一次创建 terminal
    vim.cmd("botright vsplit")
    vim.cmd("vertical resize 80")
    vim.cmd("terminal")

    vim.g.runner_bufnr = vim.api.nvim_get_current_buf()

    pcall(vim.api.nvim_buf_set_name, vim.g.runner_bufnr, "[Runner]")

    local chan_id = vim.b.terminal_job_id

    vim.fn.chansend(chan_id, cmd .. "\r")
  end
end, { desc = "Run current file" })
