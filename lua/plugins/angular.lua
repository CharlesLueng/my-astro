return {
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.html-css" },
  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@param opts AstroLSPOpts
    opts = function(_, opts)
      local astrocore = require "astrocore"
      local vtsls_ft = astrocore.list_insert_unique(vim.tbl_get(opts, "config", "vtsls", "filetypes") or {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      }, {})
      return astrocore.extend_tbl(opts, {
        ---@diagnostic disable: missing-fields
        config = {
          angularls = {
            filetypes = { "html", "htmlangular" },
            -- cmd = {
            --   "ngserver",
            --   "--stdio",
            --   "--tsProbeLocations",
            --   ag_project_library_path,
            --   "--ngProbeLocations",
            --   ag_project_library_path .. "@angular/language-server/node_modules/",
            --   "--angularCoreVersion",
            --   get_angular_core_version(),
            -- },
            on_new_config = function(new_config, new_root_dir)
              local ag_project_library_path =
                "/home/charles/.local/share/nvim/mason/packages/angular-language-server/node_modules/"

              local root_dir = vim.fn.getcwd()
              local node_modules_dir = vim.fs.find("node_modules", { path = root_dir, upward = true })[1]
              local project_root = node_modules_dir and vim.fs.dirname(node_modules_dir) or "?"

              local function get_angular_core_version()
                if not project_root then return "" end

                local package_json = project_root .. "/package.json"
                if not vim.uv.fs_stat(package_json) then return "" end

                local contents = io.open(package_json):read "*a"
                local json = vim.json.decode(contents)
                if not json.dependencies then return "" end

                local angular_core_version = json.dependencies["@angular/core"]

                angular_core_version = angular_core_version and angular_core_version:match "%d+%.%d+%.%d+"

                return angular_core_version
              end
              -- We need to check our probe directories because they may have changed.
              new_config.cmd = {
                vim.fn.exepath "ngserver",
                "--stdio",
                "--tsProbeLocations",
                ag_project_library_path,
                -- "--tsdk",
                -- "/home/charles/.local/share/nvim/mason/packages/vtsls/node_modules/@vtsls/language-server/node_modules/typescript/lib/",
                "--ngProbeLocations",
                ag_project_library_path .. "@angular/language-server/node_modules/",
                -- log
                -- "--logFile",
                -- "/home/charles/Downloads/ag_log.log",
                -- "--logVerbosity",
                -- "on",
                "--angularCoreVersion",
                get_angular_core_version(),
              }
              -- new_config.options = {
              --   typescript = {
              --     -- replace with your global TypeScript library path
              --     tsdk = "/home/charles/.local/share/nvim/mason/packages/vtsls/node_modules/@vtsls/language-server/node_modules/typescript/lib/",
              --   },
              -- }
              -- new_config.typescript = {
              --   tsdk = "/home/charles/.local/share/nvim/mason/packages/vtsls/node_modules/@vtsls/language-server/node_modules/typescript/lib/",
              -- }
              -- new_config.filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" }
              -- new_config.filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" }
              new_config.root_markers = { "angular.json", "nx.json" }
            end,
          },
          vtsls = {
            -- filetypes = vtsls_ft,
            -- settings = {
            --   -- vtsls = {
            --   --   tsserver = {
            --   --     globalPlugins = {},
            --   --   },
            --   -- },
            --   -- typescript = {
            --   --   tsserver = {
            --   --     useSyntaxServer = "never"
            --   --   }
            --   -- }
            -- },
            before_init = function(_, config)
              if opts.config.vtsls.before_init~=nil then
                opts.config.vtsls.before_init(_, config)
              end
              local registry_ok, registry = pcall(require, "mason-registry")
              if not registry_ok then return end

              if registry.is_installed "angular-language-server" then
                local angular_plugin_config = {
                  name = "@angular/language-server",
                  location = vim.fn.expand "$MASON/packages/angular-language-server/node_modules/@angular/language-server/",
                  -- languages = { "angular" },
                  -- configNamespace = "typescript",
                  enableForWorkspaceTypeScriptVersions = false,
                }


                astrocore.list_insert_unique(config.settings.vtsls.tsserver.globalPlugins, { angular_plugin_config })
              end
            end,
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "angular" })
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "angularls" })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed =
        require("astrocore").list_insert_unique(opts.ensure_installed, { "angular-language-server" })
    end,
  },
}
