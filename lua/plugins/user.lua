-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==
  -- "AstroNvim/astrolsp",
  -- ---@type AstroLSPOpts
  -- opts = function(_, opts)
  --   local astrocore = require "astrocore"
  --
  --   local vue_language_server_path =
  --     vim.fn.expand "$MASON/packages/vue-language-server/node_modules/@vue/language-server"
  --   return astrocore.extend_tbl(opts, {
  --     config = {
  --       ts_ls = {
  --         init_options = {
  --           plugins = {
  --             {
  --               name = "@vue/typescript-plugin",
  --               location = vue_language_server_path,
  --               languages = { "vue" },
  --             },
  --           },
  --         },
  --         filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
  --       },
  --     },
  --   })
  -- end,
  -- "tiagovla/tokyodark.nvim",
  -- opts = {
  --   -- custom options here
  -- },
  -- config = function(_, opts)
  --   require("tokyodark").setup(opts) -- calling setup is optional
  --   vim.cmd [[colorscheme tokyodark]]
  -- end,

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            " █████  ███████ ████████ ██████   ██████ ",
            "██   ██ ██         ██    ██   ██ ██    ██",
            "███████ ███████    ██    ██████  ██    ██",
            "██   ██      ██    ██    ██   ██ ██    ██",
            "██   ██ ███████    ██    ██   ██  ██████ ",
            "",
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
    },
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = true },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
  -- {
  --   "AstroNvim/astroui",
  --   ---@type AstroUIOpts
  --   opts = {
  --     icons = {
  --       ActiveLSP = "",
  --       ActiveTS = "",
  --       ArrowLeft = "",
  --       ArrowRight = "",
  --       BufferClose = "󰅖",
  --       DapBreakpoint = "",
  --       DapBreakpointCondition = "",
  --       DapBreakpointRejected = "",
  --       DapLogPoint = ".>",
  --       DapStopped = "󰁕",
  --       DefaultFile = "󰈙",
  --       Diagnostic = "󰒡",
  --       DiagnosticError = "",
  --       DiagnosticHint = "󰌵",
  --       DiagnosticInfo = "󰋼",
  --       DiagnosticWarn = "",
  --       Ellipsis = "…",
  --       FileModified = "",
  --       FileReadOnly = "",
  --       FoldClosed = "",
  --       FoldOpened = "",
  --       FoldSeparator = " ",
  --       FolderClosed = "",
  --       FolderEmpty = "",
  --       FolderOpen = "",
  --       Git = "󰊢",
  --       GitAdd = "",
  --       GitBranch = "",
  --       GitChange = "",
  --       GitConflict = "",
  --       GitDelete = "",
  --       GitIgnored = "◌",
  --       GitRenamed = "➜",
  --       GitStaged = "✓",
  --       GitUnstaged = "✗",
  --       GitUntracked = "★",
  --       LSPLoaded = "",
  --       LSPLoading1 = "",
  --       LSPLoading2 = "󰀚",
  --       LSPLoading3 = "",
  --       MacroRecording = "",
  --       Paste = "󰅌",
  --       Search = "",
  --       Selected = "❯",
  --       Spellcheck = "󰓆",
  --       TabClose = "󰅙",
  --     },
  --   },
  -- },
  -- {
  --   "onsails/lspkind.nvim",
  --   opts = function(_, opts)
  --     opts.preset = "codicons"
  --     opts.mode = "symbol_text"
  --     opts.symbol_map = {
  --       Text = "󰉿",
  --       Method = "󰆧",
  --       Function = "󰊕",
  --       Constructor = "",
  --       Field = "󰜢",
  --       Variable = "󰀫",
  --       Class = "󰠱",
  --       Interface = "",
  --       Module = "",
  --       Property = "󰜢",
  --       Unit = "󰑭",
  --       Value = "󰎠",
  --       Enum = "",
  --       Keyword = "󰌋",
  --       Snippet = "",
  --       Color = "󰏘",
  --       File = "󰈙",
  --       Reference = "󰈇",
  --       Folder = "󰉋",
  --       EnumMember = "",
  --       Constant = "󰏿",
  --       Struct = "󰙅",
  --       Event = "",
  --       Operator = "󰆕",
  --       TypeParameter = "",
  --     }
  --   end,
  -- },
  {
    "onsails/lspkind.nvim",
    optional = true,
    opts = function(_, opts)
      -- use codicons preset
      opts.preset = "codicons"
      opts.mode = "symbol_text"
      -- set some missing symbol types
      opts.symbol_map = {
        Array = "",
        Boolean = "",
        Key = "",
        Namespace = "",
        Null = "",
        Number = "",
        Object = "",
        Package = "",
        String = "",
      }
    end,
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      on_colors = function(color)
        -- , comment = "#709db2", dark5 = "#709db2"
        color.fg_gutter = "#707cb2"
        -- color.comment = "#709db2"
        color.dark5 = "#709db2"
      end,
      on_highlights = function(hl, c)
        -- color.fg_gutter = "#707cb2"
        -- color.comment = "#709db2"
        -- color.dark5 = "#709db2"

        hl.CursorLine = {
          bg = "#292e42",
          -- bg = "#709db2"
        }
        hl.LineNr = {
          bg = c.dark5,
        }
        hl.LineNrAbove = {
          fg = c.dark5,
        }
        hl.LineNrBelow = {
          fg = c.dark5,
        }
        hl.CursorLineNr = {
          bold = true,
          fg = "#ff9e64",
        }
      end,
    },
  },
}
