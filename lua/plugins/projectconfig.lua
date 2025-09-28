-- function dumpTable(t, indent)
--   indent = indent or 0
--   for k, v in pairs(t) do
--     local formatting = string.rep("  ", indent) .. k .. ": "
--     if type(v) == "table" then
--       print(formatting)
--       dumpTable(v, indent + 1)
--     else
--       print(formatting .. tostring(v))
--     end
--   end
-- end
--
-- local nestedTable = {
--   name = "Lua",
--   versions = { 5.1, 5.2, 5.3, 5.4 },
--   features = {
--     dynamic = true,
--     lightweight = true,
--   },
-- }
return {
  "AstroNvim/astrolsp",
  dependencies = {
    {
      "windwp/nvim-projectconfig",
      opts = {
        -- autocmd = true,
      },
    },
  },
  opts = function(_, opts)
    table.insert(opts.handlers, 1, function(server, opts)
      if vim.g.list_of_lsp_server then
        for i, v in ipairs(vim.g.list_of_lsp_server) do
          -- 注册服务
          if v == server then
            -- 判断需要注册的lsp服务为vtsls
            if server == "vtsls" then
              -- 判断配置的lsp服务是否存在vuels,是的则移除typescript-lsp对vue(filetypes)文件支持
              if vim.tbl_contains(vim.g.list_of_lsp_server, "vuels") then
                if vim.tbl_contains(opts.filetypes, "vue") then
                  -- 找到并移除
                  for i = #opts.filetypes, 1, -1 do
                    if opts.filetypes[i] == "vue" then table.remove(opts.filetypes, i) end
                  end
                end
              end
            end
            require("lspconfig")[server].setup(opts)
          end
        end
      else
        if server ~= "vuels" then require("lspconfig")[server].setup(opts) end
      end
    end)
    return opts
  end,
}
