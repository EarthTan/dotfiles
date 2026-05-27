-- plugins/harlequin.lua
return {
  "akinsho/toggleterm.nvim",
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      once = true,
      callback = function()
        -- 持久化文件路径
        local store_path = vim.fn.stdpath("data") .. "/harlequin_connections.json"

        -- 从文件读取已保存的连接
        local function load_connections()
          local f = io.open(store_path, "r")
          if not f then
            return {}
          end
          local content = f:read("*a")
          f:close()
          local ok2, data = pcall(vim.fn.json_decode, content)
          return (ok2 and type(data) == "table") and data or {}
        end

        -- 把连接列表写回文件
        local function save_connections(conns)
          local f = io.open(store_path, "w")
          if not f then
            vim.notify("Harlequin: 无法写入连接存储文件", vim.log.levels.ERROR)
            return
          end
          f:write(vim.fn.json_encode(conns))
          f:close()
        end

        -- 用 enew + terminal 在新 buffer 打开
        local function open_terminal(cmd)
          vim.cmd("enew")
          vim.cmd("terminal " .. cmd)
          vim.cmd("startinsert")
        end

        -- 主入口：选择连接
        vim.keymap.set("n", "<leader>dH", function()
          local saved = load_connections()

          -- 动态构建选单：已保存的连接 + 两个操作项
          local items = {}
          for _, c in ipairs(saved) do
            table.insert(items, { name = c.name, cmd = c.cmd, _type = "saved" })
          end
          table.insert(items, { name = "＋ 新建连接", _type = "new" })
          table.insert(items, { name = "－ 删除已有连接", _type = "delete" })

          vim.ui.select(items, {
            prompt = "Harlequin - 选择操作：",
            format_item = function(item)
              return item.name
            end,
          }, function(choice)
            if not choice then
              return
            end

            -- 新建连接
            if choice._type == "new" then
              vim.ui.input({ prompt = "连接名称：" }, function(name)
                if not name or name == "" then
                  return
                end
                vim.ui.input({
                  prompt = "harlequin 命令：",
                  default = "harlequin ",
                }, function(cmd)
                  if not cmd or cmd == "" then
                    return
                  end
                  -- 保存到文件
                  table.insert(saved, { name = name, cmd = cmd })
                  save_connections(saved)
                  vim.notify("已保存连接：" .. name)
                  -- 直接打开
                  open_terminal(cmd)
                end)
              end)
              return
            end

            -- 删除连接
            if choice._type == "delete" then
              if #saved == 0 then
                vim.notify("没有已保存的连接", vim.log.levels.WARN)
                return
              end
              vim.ui.select(saved, {
                prompt = "删除哪个连接？",
                format_item = function(item)
                  return item.name
                end,
              }, function(target)
                if not target then
                  return
                end
                local new_saved = {}
                for _, c in ipairs(saved) do
                  if c.name ~= target.name then
                    table.insert(new_saved, c)
                  end
                end
                save_connections(new_saved)
                vim.notify("已删除连接：" .. target.name)
              end)
              return
            end

            -- 打开已保存的连接
            open_terminal(choice.cmd)
          end)
        end, { desc = "Harlequin - 数据库连接管理" })
      end,
    })
  end,
}
