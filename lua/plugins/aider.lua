-- local prefix = "<Leader>a"

-- return {
--   "joshuavial/aider.nvim",
--   event = "VeryLazy",  -- 推荐延迟加载
--   opts = {
--     -- 窗口配置
--     window = {
--       width = 0.3,  -- 窗口宽度占屏幕比例 (0.0-1.0)
--       min_width = 30,  -- 最小宽度（像素）
--       max_width = 120,  -- 最大宽度（像素）
--     },
--     -- 其他配置示例:
--     -- openai_api_key = "your-api-key", -- 建议通过环境变量设置
--     -- model = "gpt-4",                -- 默认模型
--   },
--   -- 可选: 声明依赖项
--   -- dependencies = {
--   --   "nvim-lua/plenary.nvim"        -- 如果插件需要plenary
--   -- },
--   -- config = function(_, opts)
--   --   require("aider").setup(opts)
--   --
--   --   -- 设置快捷键
--   --   local keymap = vim.keymap.set
--   --   local aider = require "aider"
--   --
--   --   -- 常用操作
--   --   keymap("n", prefix .. "c", aider.chat, { desc = "Aider Chat" })
--   --   keymap("n", prefix .. "e", aider.edit, { desc = "Aider Edit" })
--   --   keymap("n", prefix .. "r", aider.run, { desc = "Aider Run Command" })
--   --   keymap("n", prefix .. "f", aider.fix, { desc = "Aider Fix Errors" })
--   --
--   --   -- 代码生成相关
--   --   keymap("n", prefix .. "g", aider.generate, { desc = "Aider Generate Code" })
--   --   keymap("n", prefix .. "t", aider.test, { desc = "Aider Generate Tests" })
--   --
--   --   -- 文档相关
--   --   keymap("n", prefix .. "d", aider.document, { desc = "Aider Document Code" })
--   -- end
-- }
return {
  "GeorgesAlkhouri/nvim-aider",
  cmd = "Aider",
  -- Example key mappings for common actions:
  keys = {
    { "<leader>a/", "<cmd>Aider toggle<cr>", desc = "Toggle Aider" },
    { "<leader>as", "<cmd>Aider send<cr>", desc = "Send to Aider", mode = { "n", "v" } },
    { "<leader>ac", "<cmd>Aider command<cr>", desc = "Aider Commands" },
    { "<leader>ab", "<cmd>Aider buffer<cr>", desc = "Send Buffer" },
    { "<leader>a+", "<cmd>Aider add<cr>", desc = "Add File" },
    { "<leader>a-", "<cmd>Aider drop<cr>", desc = "Drop File" },
    { "<leader>ar", "<cmd>Aider add readonly<cr>", desc = "Add Read-Only" },
    { "<leader>aR", "<cmd>Aider reset<cr>", desc = "Reset Session" },
    -- Example nvim-tree.lua integration if needed
    { "<leader>a+", "<cmd>AiderTreeAddFile<cr>", desc = "Add File from Tree to Aider", ft = "NvimTree" },
    { "<leader>a-", "<cmd>AiderTreeDropFile<cr>", desc = "Drop File from Tree from Aider", ft = "NvimTree" },
  },
  dependencies = {
    "folke/snacks.nvim",
    --- The below dependencies are optional
    "catppuccin/nvim",
    -- "nvim-tree/nvim-tree.lua",
    --- Neo-tree integration
    {
      "nvim-neo-tree/neo-tree.nvim",
      opts = function(_, opts)
        -- Example mapping configuration (already set by default)
        -- opts.window = {
        --   mappings = {
        --     ["+"] = { "nvim_aider_add", desc = "add to aider" },
        --     ["-"] = { "nvim_aider_drop", desc = "drop from aider" }
        --     ["="] = { "nvim_aider_add_read_only", desc = "add read-only to aider" }
        --   }
        -- }
        require("nvim_aider.neo_tree").setup(opts)
      end,
    },
  },
  config = true,
}
