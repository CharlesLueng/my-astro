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
  "windwp/nvim-projectconfig",
  dependencies = {
    {
      "AstroNvim/astrolsp",
      opts = function(_, opts)
        table.insert(opts.handlers, 1, function(server, opts)
          if vim.g.list_of_lsp_server then
            for i, v in ipairs(vim.g.list_of_lsp_server) do
              if v == server then require("lspconfig")[server].setup(opts) end
            end
          else
            require("lspconfig")[server].setup(opts)
          end
        end)
        return opts
      end,
    },
  },
  opts = {},
}
