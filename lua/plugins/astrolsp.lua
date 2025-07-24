-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = false, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      -- angularls = {
      --   -- cmd = {
      --   --   "ngserver",
      --   --   "--stdio",
      --   --   "--tsProbeLocations",
      --   --   ag_project_library_path,
      --   --   "--ngProbeLocations",
      --   --   ag_project_library_path .. "@angular/language-server/node_modules/",
      --   --   "--angularCoreVersion",
      --   --   get_angular_core_version(),
      --   -- },
      --   on_new_config = function(new_config, new_root_dir)
      --     local ag_project_library_path =
      --       "/home/charles/.local/share/nvim/mason/packages/angular-language-server/node_modules/"
      --
      --     local root_dir = vim.fn.getcwd()
      --     local node_modules_dir = vim.fs.find("node_modules", { path = root_dir, upward = true })[1]
      --     local project_root = node_modules_dir and vim.fs.dirname(node_modules_dir) or "?"
      --
      --     local function get_angular_core_version()
      --       if not project_root then return "" end
      --
      --       local package_json = project_root .. "/package.json"
      --       if not vim.uv.fs_stat(package_json) then return "" end
      --
      --       local contents = io.open(package_json):read "*a"
      --       local json = vim.json.decode(contents)
      --       if not json.dependencies then return "" end
      --
      --       local angular_core_version = json.dependencies["@angular/core"]
      --
      --       angular_core_version = angular_core_version and angular_core_version:match "%d+%.%d+%.%d+"
      --
      --       return angular_core_version
      --     end
      --     -- We need to check our probe directories because they may have changed.
      --     new_config.cmd = {
      --       vim.fn.exepath "ngserver",
      --       "--stdio",
      --       "--tsProbeLocations",
      --       ag_project_library_path,
      --       -- "--tsdk",
      --       -- "/home/charles/.local/share/nvim/mason/packages/vtsls/node_modules/@vtsls/language-server/node_modules/typescript/lib/",
      --       "--ngProbeLocations",
      --       ag_project_library_path .. "@angular/language-server/node_modules/",
      --       -- log
      --       "--logFile",
      --       "/home/charles/Downloads/ag_log.log",
      --       "--logVerbosity",
      --       "on",
      --       "--angularCoreVersion",
      --       get_angular_core_version(),
      --     }
      --     -- new_config.options = {
      --     --   typescript = {
      --     --     -- replace with your global TypeScript library path
      --     --     tsdk = "/home/charles/.local/share/nvim/mason/packages/vtsls/node_modules/@vtsls/language-server/node_modules/typescript/lib/",
      --     --   },
      --     -- }
      --     -- new_config.typescript = {
      --     --   tsdk = "/home/charles/.local/share/nvim/mason/packages/vtsls/node_modules/@vtsls/language-server/node_modules/typescript/lib/",
      --     -- }
      --     new_config.filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" }
      --     new_config.root_markers = { "angular.json", "nx.json" }
      --   end,
      -- },
      ---@vtsls lspconfig.options.vtsls
      vtsls = {
        -- init_options = {
        --   typescript = {
        --     tsdk = "/home/charles/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib",
        --     globalTsdk = "/home/charles/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib"
        --   }
        -- },
        -- before_init = function(params, config)
        --   if config.init_options.typescript == nil then config.init_options.typescript = {} end
        --
        --   -- config.init_options.typescript.globalTsdk =
        --   --   "/home/charles/.local/share/nvim/mason/packages/vtsls/node_modules/@vtsls/language-server/node_modules/typescript/lib"
        --   -- config.init_options.typescript.tsdk =
        --   --   "/home/charles/.local/share/nvim/mason/packages/vtsls/node_modules/@vtsls/language-server/node_modules/typescript/lib"
        --   -- config.init_options.typescript.tsdk =
        --   --   "/home/charles/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib"
        -- end,
        -- on_new_config = function (new_config, new_root_dir)
        --   if new_config.typescript. then
        --
        --   end
        --   -- new_config.typescript.globalTsdk = "/home/charles/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib"
        --   -- new_config.typescript.tsdk = "/home/charles/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib"
        -- end
        -- before_init = function(_, config)
        --   local astrocore = require "astrocore"
        --   local registry_ok, registry = pcall(require, "mason-registry")
        --   if not registry_ok then return end
        --
        --   if registry.is_installed "vue-language-server" then
        --     local vue_plugin_config = {
        --       name = "@vue/typescript-plugin",
        --       location = vim.fn.expand "$MASON/packages/vue-language-server/node_modules/@vue/language-server",
        --       languages = { "vue" },
        --       configNamespace = "typescript",
        --       enableForWorkspaceTypeScriptVersions = false,
        --     }
        --
        --     astrocore.list_insert_unique(config.settings.vtsls.tsserver.globalPlugins, { vue_plugin_config })
        --   end
        -- end,
      },

      -- clangd = { capabilities = { offsetEncoding = "utf-8" } },
    },
    -- customize how language servers are attached
    -- handlers = {
    --   -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
    --   -- function(server, opts) require("lspconfig")[server].setup(opts) end
    --
    --   -- the key is the server that is being setup with `lspconfig`
    --   -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
    --   -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
    -- },
    handlers = {
      -- function(server, opts)
      --   if vim.g.list_of_lsp_server then
      --     for i, v in ipairs(vim.g.list_of_lsp_server) do
      --       if v == server then require("lspconfig")[server].setup(opts) end
      --     end
      --   else
      --     require("lspconfig")[server].setup(opts)
      --   end
      -- end,
      -- csharp_ls = function(server, opts)
      --   require("lspconfig")[server].setup(opts)
      --   require("csharpls_extended").buf_read_cmd_bind()
      -- end,
    },
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_codelens_refresh = {
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/codeLens",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "InsertLeave", "BufEnter" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
          end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    -- on_attach = function(client, bufnr)
    --   -- this would disable semanticTokensProvider for all clients
    --   -- client.server_capabilities.semanticTokensProvider = nil
    -- end,
  },
}
