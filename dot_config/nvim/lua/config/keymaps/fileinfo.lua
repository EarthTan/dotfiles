-- ============================================================
--  file_info.lua  —  <leader>fi  查看文件详细信息
--  支持：普通 buffer、snacks explorer 文件树
-- ============================================================

local fileutil = require("config.keymaps.fileutil")

-- ── 浮动窗口 ─────────────────────────────────────────────────

local function open_win(lines, file_path)
  local max_w = 0
  for _, l in ipairs(lines) do
    max_w = math.max(max_w, vim.fn.strdisplaywidth(l))
  end
  local width = math.min(math.max(max_w + 4, 58), math.floor(vim.o.columns * 0.85))
  local height = math.min(#lines + 2, math.floor(vim.o.lines * 0.80))
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " 文件信息 ",
    title_pos = "center",
    noautocmd = true,
  })

  vim.wo[win].wrap = false
  vim.wo[win].cursorline = true
  vim.wo[win].number = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].winhighlight = "Normal:NormalFloat,CursorLine:Visual"

  local function close()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end
  local opts = { buffer = buf, nowait = true, silent = true }
  vim.keymap.set("n", "<CR>", close, opts)
  vim.keymap.set("n", "q", close, opts)
  vim.keymap.set("n", "<Esc>", close, opts)

  vim.keymap.set("n", "y", function()
    vim.fn.setreg("+", file_path)
    vim.notify("路径已复制: " .. file_path, vim.log.levels.INFO)
  end, opts)

  vim.api.nvim_buf_call(buf, function()
    vim.cmd([[
      syntax match FileInfoBorder /^[━─]/
      syntax match FileInfoKey   /^\s\+\zs[^\s─━]\+\ze\s\{2,}/
      highlight link FileInfoBorder NonText
      highlight link FileInfoKey   Identifier
    ]])
  end)
end

-- ── 主函数 ───────────────────────────────────────────────────

local function show_file_info()
  local file = fileutil.get_target_file()
  if not file or file == "" then
    vim.notify("无法获取文件路径（filetype=" .. vim.bo.filetype .. "）", vim.log.levels.WARN)
    return
  end

  local stat = vim.uv.fs_stat(file)
  if not stat then
    vim.notify("文件不存在或无法访问：" .. file, vim.log.levels.WARN)
    return
  end

  local name = vim.fn.fnamemodify(file, ":t")
  local dir = vim.fn.fnamemodify(file, ":h")
  local ext = vim.fn.fnamemodify(file, ":e")
  local extra = fileutil.shell_attr(file, stat)
  local W = 54

  local sep = function(ch)
    return ch .. string.rep(ch, W) .. ch
  end
  local function row(key, val)
    val = tostring(val or "N/A")
    local gap = W - #key - vim.fn.strdisplaywidth(val) - 1
    if gap < 1 then
      gap = 1
    end
    return "  " .. key .. string.rep(" ", gap) .. val
  end

  local lines = {
    sep("━"),
    "  " .. name,
    row("路径", dir),
    sep("─"),
    row("类型", fileutil.file_type_desc(file, stat.type)),
    row("大小", fileutil.human_size(stat.size)),
  }

  if extra.lines then
    table.insert(lines, row("行数", extra.lines))
  end
  if extra.chars then
    table.insert(lines, row("字符数", extra.chars))
  end
  if extra.link_target then
    table.insert(lines, row("链接目标", extra.link_target))
  end

  vim.list_extend(lines, {
    sep("─"),
    row("修改时间", fileutil.fmt_time(stat.mtime)),
    row("访问时间", fileutil.fmt_time(stat.atime)),
    row("状态变更时间", fileutil.fmt_time(stat.ctime)),
    sep("─"),
    row("权限", fileutil.perm_string(stat.mode) .. "  (" .. string.format("%o", stat.mode % 512) .. ")"),
    row("可执行", extra.executable),
    row("硬链接数", tostring(stat.nlink or "N/A")),
    row("inode", tostring(stat.ino or "N/A")),
    row("设备 ID", tostring(stat.dev or "N/A")),
  })

  if ext and ext ~= "" then
    table.insert(lines, row("扩展名", "." .. ext))
  end

  vim.list_extend(lines, {
    sep("━"),
    "  [Enter] / [q] 关闭   [y] 复制路径",
  })

  open_win(lines, file)
end

-- ── 注册快捷键 ────────────────────────────────────────────────

vim.keymap.set("n", "<leader>fi", show_file_info, {
  desc = "文件信息浮动窗口",
  silent = true,
})