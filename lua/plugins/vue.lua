if true then return {} end

return {
  {
    "AstroNvim/astrolsp",
    optional = true,
    dependencies = {"windwp/nvim-projectconfig"},
    ---@param opts AstroLSPOpts}
    opts = function(_, opts)
      local astrocore = require "astrocore"

      -- local vtsls_ft = astrocore.list_insert_unique(vim.tbl_get(opts, "config", "vtsls", "filetypes") or {
      --   "javascript",
      --   "javascriptreact",
      --   "javascript.jsx",
      --   "typescript",
      --   "typescriptreact",
      --   "typescript.tsx",
      -- }, { "vue" })

      -- print(vim.g.list_of_lsp_server)

      -- if vim.g.list_of_lsp_server or not vim.tbl_contains(vim.g.list_of_lsp_server, "volar") then
      --   vtsls_ft = astrocore.list_insert_unique(vtsls_ft, {'vue'})
      --   if vim.tbl_contains(vtsls_ft, "vue") then
      --     -- 找到并移除
      --     for i = #vtsls_ft, 1, -1 do
      --       if vtsls_ft[i] == "vue" then table.remove(vtsls_ft, i) end
      --     end
      --   end
      -- end

      return astrocore.extend_tbl(opts, {
        config = {
          volar = {
            on_init = function(client)
              client.handlers["tsserver/request"] = function(_, result, context)
                local clients = vim.lsp.get_clients { bufnr = context.bufnr, name = "vtsls" }
                if #clients == 0 then
                  vim.notify(
                    "Could not found `vtsls` lsp client, vue_lsp would not work without it.",
                    vim.log.levels.ERROR
                  )
                  return
                end
                local ts_client = clients[1]

                local param = unpack(result)
                local id, command, payload = unpack(param)
                ts_client:exec_cmd({
                  title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
                  command = "typescript.tsserverRequest",
                  arguments = {
                    command,
                    payload,
                  },
                }, { bufnr = context.bufnr }, function(_, r)
                  if r then
                    local response_data = { { id, r.body } }
                    client:notify("tsserver/response", response_data)
                  end
                end)
              end
            end,
          },
          -- vtsls = {
          --   -- filetypes = vtsls_ft,
          --   settings = {
          --     vtsls = {
          --       tsserver = {
          --         globalPlugins = {},
          --       },
          --     },
          --   },
          --   -- on_new_config = function(new_config)
          --   --   print(#new_config.filetypes)
          --   --   if vim.g.list_of_lsp_server or not vim.tbl_contains(vim.g.list_of_lsp_server, "volar") then
          --   --     if vim.tbl_contains(new_config.filetypes, "vue") then
          --   --       -- 找到并移除
          --   --       for i = #new_config.filetypes, 1, -1 do
          --   --         if new_config.filetypes[i] == "vue" then table.remove(new_config.filetypes, i) end
          --   --       end
          --   --     end
          --   --
          --   --     print(#new_config.filetypes)
          --   --   end
          --   -- end,
          --   before_init = function(_, config)
          --     local registry_ok, registry = pcall(require, "mason-registry")
          --     if not registry_ok then return end
          --
          --     if vim.g.list_of_lsp_server or not vim.tbl_contains(vim.g.list_of_lsp_server, "volar") then
          --       return
          --     end
          --
          --     if registry.is_installed "vue-language-server" then
          --       local vue_plugin_config = {
          --         name = "@vue/typescript-plugin",
          --         location = vim.fn.expand "$MASON/packages/vue-language-server/node_modules/@vue/language-server",
          --         languages = { "vue" },
          --         configNamespace = "typescript",
          --         enableForWorkspaceTypeScriptVersions = true,
          --       }
          --
          --       astrocore.list_insert_unique(config.settings.vtsls.tsserver.globalPlugins, { vue_plugin_config })
          --     end
          --   end,
          -- },
        },
      })
    end,
  },
}
