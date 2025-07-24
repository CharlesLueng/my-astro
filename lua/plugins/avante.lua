-- return {}
local prefix = "<Leader>a"

return {
  {
    "yetone/avante.nvim",
    -- opts = function ()
    --
    -- end
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
      -- provider = "deepseek",
      provider = "qianwen",
      providers = {
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-coder",
        },
        qianwen = {
          __inherited_from = "openai",
          api_key_name = "DASHSCOPE_API_KEY",
          endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1",
          -- model = "qwen-coder-plus-latest",
          model = "qwen3-coder-plus",
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
