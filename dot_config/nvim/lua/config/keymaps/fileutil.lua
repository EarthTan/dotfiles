-- ============================================================
--  fileutil.lua  —  文件操作工具函数（无快捷键）
--  被 fileinfo.lua / fileopen.lua 等引用
-- ============================================================

--- 获取"当前关注的文件"路径
--- 支持：nvim-tree / snacks explorer / 普通 buffer
local function get_target_file()
  local ft = vim.bo.filetype

  -- ── nvim-tree ──────────────────────────────────────────────
  if ft == "NvimTree" then
    local ok, api = pcall(require, "nvim-tree.api")
    if ok then
      local node = api.tree.get_node_under_cursor()
      if node and node.absolute_path and node.absolute_path ~= "" then
        return node.absolute_path
      end
    end
    return nil
  end

  -- ── snacks picker（所有 source 类型）───────────────────────
  if ft == "snacks_explorer" or ft == "snacks_picker_list" then
    -- 方法1：Snacks.picker.get() 获取当前 picker（通用方法）
    local ok, pickers = pcall(function()
      return Snacks.picker.get()
    end)
    if ok and pickers and pickers[1] then
      local item = pickers[1]:current()
      if item then
        local file = item.file or item.path or item.filename
        if file and file ~= "" then
          return file
        end
      end
    end

    -- 方法2：遍历 active pickers 兜底
    local ok2, picker_mod = pcall(require, "snacks.picker.core.picker")
    if ok2 then
      for picker in pairs(picker_mod._active or {}) do
        local item = picker:current()
        if item then
          local file = item.file or item.path or item.filename
          if file and file ~= "" then
            return file
          end
        end
      end
    end

    -- 方法3：<cfile> 兜底
    return vim.fn.expand("<cfile>:p")
  end

  -- ── 普通 buffer ────────────────────────────────────────────
  return vim.fn.expand("%:p")
end

--- 格式化字节数
local function human_size(bytes)
  if bytes == nil then
    return "未知"
  end
  local units = { "B", "KB", "MB", "GB", "TB" }
  local val, unit = bytes, "B"
  for i = 2, #units do
    if val < 1024 then
      break
    end
    val = val / 1024
    unit = units[i]
  end
  if unit == "B" then
    return string.format("%d B", bytes)
  end
  return string.format("%.2f %s  (%s 字节)", val, unit, vim.fn.printf("%d", bytes))
end

--- 格式化 Unix 时间戳
local function fmt_time(ts)
  if not ts then
    return "N/A"
  end
  return os.date("%Y-%m-%d  %H:%M:%S", ts.sec or ts)
end

--- 根据扩展名返回文件类型描述
local function file_type_desc(path, stat_type)
  if stat_type == "directory" then
    return "目录"
  end
  if stat_type == "link" then
    return "符号链接"
  end
  if stat_type == "file" then
    local ext = vim.fn.fnamemodify(path, ":e"):lower()
    local map = {
      lua = "Lua 脚本",
      py = "Python 脚本",
      js = "JavaScript",
      ts = "TypeScript",
      jsx = "React JSX",
      tsx = "React TSX",
      rs = "Rust",
      go = "Go",
      c = "C",
      cpp = "C++",
      h = "头文件",
      java = "Java",
      sh = "Shell 脚本",
      zsh = "Zsh 脚本",
      bash = "Bash 脚本",
      md = "Markdown",
      json = "JSON",
      yaml = "YAML",
      yml = "YAML",
      toml = "TOML 配置",
      ini = "INI 配置",
      txt = "纯文本",
      html = "HTML",
      css = "CSS",
      xml = "XML",
      csv = "CSV 数据",
      sql = "SQL 脚本",
      pdf = "PDF 文档",
      png = "PNG 图片",
      jpg = "JPEG 图片",
      jpeg = "JPEG 图片",
      gif = "GIF 图片",
      svg = "SVG 矢量图",
      zip = "ZIP 压缩包",
      tar = "TAR 归档",
      gz = "Gzip 压缩",
      mp4 = "MP4 视频",
      mp3 = "MP3 音频",
    }
    return map[ext] or (ext ~= "" and ("." .. ext .. " 文件") or "普通文件")
  end
  return stat_type or "未知类型"
end

--- 权限位转 rwxrwxrwx 字符串
local function perm_string(mode)
  if not mode then
    return "N/A"
  end
  local bits = mode % 512
  local chars = {}
  local labels = { "r", "w", "x", "r", "w", "x", "r", "w", "x" }
  for i = 8, 0, -1 do
    if bits >= 2 ^ i then
      table.insert(chars, labels[9 - i])
      bits = bits - 2 ^ i
    else
      table.insert(chars, "-")
    end
  end
  return table.concat(chars)
end

--- 通过 shell 获取扩展属性
local function shell_attr(path, stat)
  local result = {}

  if stat and stat.type == "file" and stat.size < 50 * 1024 * 1024 then
    local lout = vim.fn.systemlist("wc -l " .. vim.fn.shellescape(path) .. " 2>/dev/null")
    if lout and lout[1] then
      local n = lout[1]:match("^%s*(%d+)")
      if n then
        result.lines = n .. " 行"
      end
    end
    local cout = vim.fn.systemlist("wc -c " .. vim.fn.shellescape(path) .. " 2>/dev/null")
    if cout and cout[1] then
      local n = cout[1]:match("^%s*(%d+)")
      if n then
        result.chars = n .. " 字节"
      end
    end
  end

  local link = vim.uv.fs_readlink(path)
  if link then
    result.link_target = link
  end

  result.executable = vim.uv.fs_access(path, "X") and "是" or "否"

  return result
end

return {
  get_target_file = get_target_file,
  human_size = human_size,
  fmt_time = fmt_time,
  file_type_desc = file_type_desc,
  perm_string = perm_string,
  shell_attr = shell_attr,
}