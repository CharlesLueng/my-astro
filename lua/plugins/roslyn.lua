-- if true then return {} end

-- local mason_registry = require "mason-registry"
--
-- local rzls_path = vim.fn.expand "$MASON/packages/rzls/libexec"
--
-- local cmd = {
--   "roslyn",
--   "--stdio",
--   "--logLevel=Information",
--   "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
--   "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
--   "--razorDesignTimePath=" .. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
--   "--extension",
--   vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
-- }

vim.lsp.config("roslyn", {
  -- cmd = cmd,
  -- filetypes = { "cs", "razor", "cshtml" },
  -- cmd = {
  --   "C:/Users/Charles/AppData/Local/nvim-data/mason/bin/roslyn.cmd",
  --   "--logLevel=Debug",
  --   "--extensionLogDirectory=C:/Users/Charles/AppData/Local/nvim-data",
  --   "--stdio",
  -- },
  -- handlers = require "rzls.roslyn_handlers",
  -- offset_encoding = "utf-8",
  -- on_attach = function(client, bufnr)
  --   -- print("123123")
  --   require("astrolsp").on_attach(client, bufnr)
  -- end,
  settings = {
    ["csharp|background_analysis"] = {
      dotnet_analyzer_diagnostics_scope = "openFiles",
      dotnet_compiler_diagnostics_scope = "openFiles",
    },
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = false,
      csharp_enable_inlay_hints_for_implicit_variable_types = false,
      csharp_enable_inlay_hints_for_lambda_parameter_types = false,
      csharp_enable_inlay_hints_for_types = false,
      dotnet_enable_inlay_hints_for_indexer_parameters = false,
      dotnet_enable_inlay_hints_for_literal_parameters = false,
      dotnet_enable_inlay_hints_for_object_creation_parameters = false,
      dotnet_enable_inlay_hints_for_other_parameters = false,
      dotnet_enable_inlay_hints_for_parameters = false,
      dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = false,
      dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = false,
      dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = false,
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = false,
    },
    ["csharp|completion"] = {
      dotnet_show_completion_items_from_unimported_namespaces = true,
      dotnet_show_name_completion_suggestions = true,
    },
  },
})
--
vim.lsp.enable "roslyn"

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
    "seblyng/roslyn.nvim",
    dependencies = {
      {
        "AstroNvim/astrolsp",
        -- By loading as a dependencies, we ensure that we are available to set
        -- the handlers for Roslyn.
        -- "tris203/rzls.nvim",
        -- config = true,
      },
    },
    ft = "cs",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      on_attach = function()
        vim.notify "123123"
        print "123123"
      end,
    },
    -- init = function()
    --   -- We add the Razor file types before the plugin loads.
    --   vim.filetype.add {
    --     extension = {
    --       razor = "razor",
    --       cshtml = "razor",
    --     },
    --   }
    -- end,
    config = function(_, opts)
      -- require("configs.rzls").configure()

      -- require("roslyn").setup(opts)

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf

          if client and (client.name == "roslyn" or client.name == "roslyn_ls") then
            vim.notify "123123"
            -- print(client.name)

            require("astrolsp").on_attach(client, bufnr)

            -- vim.api.nvim_create_autocmd({ "InsertLeave" }, {
            --   pattern = "*",
            --   callback = function(args)
            --     local clients = vim.lsp.get_clients { name = "roslyn" }
            --     if not clients or #clients == 0 then return end
            --
            --     local client = assert(vim.lsp.get_client_by_id(clients[1].id))
            --     local buffers = vim.lsp.get_buffers_by_client_id(clients[1].id)
            --     for _, buf in ipairs(buffers) do
            --       local params = { textDocument = vim.lsp.util.make_text_document_params(buf) }
            --       client:request("textDocument/diagnostic", params, nil, buf)
            --     end
            --   end,
            -- })

            -- vim.api.nvim_create_autocmd("InsertCharPre", {
            --   desc = "Roslyn: Trigger an auto insert on '/'.",
            --   buffer = bufnr,
            --   callback = function()
            --     local char = vim.v.char
            --
            --     if char ~= "/" then return end
            --
            --     local row, col = unpack(vim.api.nvim_win_get_cursor(0))
            --     row, col = row - 1, col + 1
            --     local uri = vim.uri_from_bufnr(bufnr)
            --
            --     local params = {
            --       _vs_textDocument = { uri = uri },
            --       _vs_position = { line = row, character = col },
            --       _vs_ch = char,
            --       _vs_options = {
            --         tabSize = vim.bo[bufnr].tabstop,
            --         insertSpaces = vim.bo[bufnr].expandtab,
            --       },
            --     }
            --
            --     -- NOTE: We should send textDocument/_vs_onAutoInsert request only after
            --     -- buffer has changed.
            --     vim.defer_fn(function()
            --       client:request(
            --         ---@diagnostic disable-next-line: param-type-mismatch
            --         "textDocument/_vs_onAutoInsert",
            --         params,
            --         function(err, result, _)
            --           if err or not result then return end
            --
            --           vim.snippet.expand(result._vs_textEdit.newText)
            --         end,
            --         bufnr
            --       )
            --     end, 1)
            --   end,
            -- })
          end
        end,
      })
    end,
  },

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
}
