return {
  -- CSharp support
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "c_sharp" })
      end
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "csharpier" })
    end,
  },
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = function(_, opts)
      opts.registries = require("astrocore").list_insert_unique(
        opts.registries,
        { "github:mason-org/mason-registry", "github:Crashdummyy/mason-registry" }
      )
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "roslyn_ls" })
    end,
  },
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      -- your configuration comes here; leave empty for default settings
    },
    config = function(_, opts)
      
      require("roslyn").setup(opts)

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf

          if client and (client.name == "roslyn" or client.name == "roslyn_ls") then
            vim.api.nvim_create_autocmd("InsertCharPre", {
              desc = "Roslyn: Trigger an auto insert on '/'.",
              buffer = bufnr,
              callback = function()
                local char = vim.v.char

                if char ~= "/" then return end

                local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                row, col = row - 1, col + 1
                local uri = vim.uri_from_bufnr(bufnr)

                local params = {
                  _vs_textDocument = { uri = uri },
                  _vs_position = { line = row, character = col },
                  _vs_ch = char,
                  _vs_options = {
                    tabSize = vim.bo[bufnr].tabstop,
                    insertSpaces = vim.bo[bufnr].expandtab,
                  },
                }

                -- NOTE: We should send textDocument/_vs_onAutoInsert request only after
                -- buffer has changed.
                vim.defer_fn(function()
                  client:request(
                    ---@diagnostic disable-next-line: param-type-mismatch
                    "textDocument/_vs_onAutoInsert",
                    params,
                    function(err, result, _)
                      if err or not result then return end

                      vim.snippet.expand(result._vs_textEdit.newText)
                    end,
                    bufnr
                  )
                end, 1)
              end,
            })
          end
        end,
      })
    end,
  },
  -- {
  --   "Decodetalkers/csharpls-extended-lsp.nvim",
  --   dependencies = {
  --     {
  --       "AstroNvim/astrolsp",
  --       opts = vim.fn.has "nvim-0.11" == 1
  --           and {
  --             handlers = {
  --               csharp_ls = function(server, opts)
  --                 require("lspconfig")[server].setup(opts)
  --                 require("csharpls_extended").buf_read_cmd_bind()
  --               end,
  --             },
  --           }
  --         or { -- TODO: drop when dropping support for Neovim v0.10
  --           config = {
  --             csharp_ls = {
  --               handlers = {
  --                 ["textDocument/definition"] = function(...) require("csharpls_extended").handler(...) end,
  --                 ["textDocument/typeDefinition"] = function(...) require("csharpls_extended").handler(...) end,
  --               },
  --             },
  --           },
  --         },
  --     },
  --   },
  -- },
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "coreclr" })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed =
        require("astrocore").list_insert_unique(opts.ensure_installed, { "csharpier", "netcoredbg" })
    end,
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = { "Issafalcon/neotest-dotnet", config = function() end },
    opts = function(_, opts)
      if not opts.adapters then opts.adapters = {} end
      table.insert(opts.adapters, require "neotest-dotnet"(require("astrocore").plugin_opts "neotest-dotnet"))
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        cs = { "csharpier" },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    optional = true,
    opts = function(_, opts)
      vim.lsp.config("roslyn", {
        on_attach = function(client, bufnr) 
          -- print "This will run when the server attaches!" 
          require("astrolsp").on_attach(client, bufnr)
        end,
        settings = {
          -- ["csharp|inlay_hints"] = {
          --   csharp_enable_inlay_hints_for_implicit_object_creation = true,
          --   csharp_enable_inlay_hints_for_implicit_variable_types = true,
          -- },
          -- ["csharp|code_lens"] = {
          --   dotnet_enable_references_code_lens = true,
          -- },
        },
      })
      return opts
    end,
    -- opts = {
    --   -- config = {
    --   --   roslyn_ls = {
    --   --     on_attach = function(client, bufnr)
    --   --       -- local wk_avail, wk = pcall(require, "which-key")
    --   --       vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr } --[[@as vim.keymap.set.Opts]])
    --   --       print "This will run when the server attaches!"
    --   --       require("astrolsp").on_attach(client, bufnr)
    --   --     end,
    --   --     settings = {
    --   --       ["csharp|inlay_hints"] = {
    --   --         csharp_enable_inlay_hints_for_implicit_object_creation = true,
    --   --         csharp_enable_inlay_hints_for_implicit_variable_types = true,
    --   --       },
    --   --       ["csharp|code_lens"] = {
    --   --         dotnet_enable_references_code_lens = true,
    --   --       },
    --   --     },
    --   --   },
    --   -- },
    -- },
  },
}
