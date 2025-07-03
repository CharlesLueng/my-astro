return {
  "paul-gauthier/aider.nvim",
  event = "VeryLazy",  -- 推荐延迟加载
  opts = {
    -- 这里可以添加插件的默认配置
    -- 例如:
    -- openai_api_key = "your-api-key", -- 建议通过环境变量设置
    -- model = "gpt-4",                -- 默认模型
  },
  -- 可选: 声明依赖项
  -- dependencies = {
  --   "nvim-lua/plenary.nvim"        -- 如果插件需要plenary
  -- },
  config = function(_, opts)
    require("aider").setup(opts)
    -- 这里可以添加额外的初始化代码
  end
}
