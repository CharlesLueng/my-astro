local prefix = "<Leader>a"

return {
  "joshuavial/aider.nvim",
  event = "VeryLazy",  -- 推荐延迟加载
  opts = {
    -- 窗口配置
    window = {
      width = 0.6,  -- 窗口宽度占屏幕比例 (0.0-1.0)
      min_width = 60,  -- 最小宽度（像素）
      max_width = 120,  -- 最大宽度（像素）
    },
    -- 其他配置示例:
    -- openai_api_key = "your-api-key", -- 建议通过环境变量设置
    -- model = "gpt-4",                -- 默认模型
  },
  -- 可选: 声明依赖项
  -- dependencies = {
  --   "nvim-lua/plenary.nvim"        -- 如果插件需要plenary
  -- },
  config = function(_, opts)
    require("aider").setup(opts)

    -- 设置快捷键
    local keymap = vim.keymap.set
    local aider = require "aider"

    -- 常用操作
    keymap("n", prefix .. "c", aider.chat, { desc = "Aider Chat" })
    keymap("n", prefix .. "e", aider.edit, { desc = "Aider Edit" })
    keymap("n", prefix .. "r", aider.run, { desc = "Aider Run Command" })
    keymap("n", prefix .. "f", aider.fix, { desc = "Aider Fix Errors" })

    -- 代码生成相关
    keymap("n", prefix .. "g", aider.generate, { desc = "Aider Generate Code" })
    keymap("n", prefix .. "t", aider.test, { desc = "Aider Generate Tests" })

    -- 文档相关
    keymap("n", prefix .. "d", aider.document, { desc = "Aider Document Code" })
  end
}
