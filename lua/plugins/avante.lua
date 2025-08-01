-- return {}
local prefix = "<Leader>a"

return {
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      "Kaiser-Yang/blink-cmp-avante",
      -- ... Other dependencies
    },
    opts = function(_, opts)
      local astrocore = require "astrocore"
      local sources_default = astrocore.list_insert_unique(
        { "avante" },
        vim.tbl_get(opts, "sources", "default") or { "lsp", "path", "luasnip", "buffer" }
      )
      return astrocore.extend_tbl(opts, {
        sources = {
          default = sources_default,
          providers = {

            avante = {
              module = "blink-cmp-avante",
              name = "Avante",
              opts = {
                -- options for blink-cmp-avante
              },
            },
          },
        },
      })
    end,
    -- opts = {
    --   sources = {
    --     -- Add 'avante' to the list
    --     default = { "avante", "lsp", "path", "luasnip", "buffer" },
    --     providers = {
    --       avante = {
    --         module = "blink-cmp-avante",
    --         name = "Avante",
    --         opts = {
    --           -- options for blink-cmp-avante
    --         },
    --       },
    --     },
    --   },
    -- },
  },
  {
    "yetone/avante.nvim",
    -- opts = function ()
    --
    -- end
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      mappings = {
        ask = prefix .. "<CR>",
        edit = prefix .. "e",
        refresh = prefix .. "r",
        new_ask = prefix .. "n",
        focus = prefix .. "f",
        select_model = prefix .. "?",
        stop = prefix .. "S",
        select_history = prefix .. "h",
        toggle = {
          default = prefix .. "t",
          debug = prefix .. "d",
          hint = prefix .. "H",
          suggestion = prefix .. "s",
          repomap = prefix .. "R",
        },
        diff = {
          next = "]c",
          prev = "[c",
        },
        files = {
          add_current = prefix .. ".",
          add_all_buffers = prefix .. "B",
        },
      },
      provider = "deepseek",
      -- provider = "qianwen",
      providers = {
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-coder",
          -- extra_request_body = {
            -- temperature = 0.75,
            -- max_tokens = 128 * 1000,
          -- },
        },
        qianwen = {
          __inherited_from = "openai",
          api_key_name = "DASHSCOPE_API_KEY",
          endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1",
          -- model = "qwen-coder-plus-latest",
          -- model = "qwen3-coder-plus",
          model = "qwen-turbo",
        },
        qianwen_coder = {
          __inherited_from = "openai",
          api_key_name = "DASHSCOPE_API_KEY",
          endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1",
          -- model = "qwen-coder-plus-latest",
          model = "qwen3-coder-plus",
          -- model = "qwen-turbo",
        },
      },
      windows = {
        input = {
          height = 20,
        },
        edit = {
          start_insert = false,
        },
        ask = {
          start_insert = false,
        },
      },
    },
  },
}
