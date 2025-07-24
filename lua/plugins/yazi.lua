---@type LazySpec
return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  dependencies = {
    -- check the installation instructions at
    -- https://github.com/folke/snacks.nvim
    "folke/snacks.nvim",
  },
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      "R",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file",
    },
    -- {
    --   -- Open in the current working directory
    --   "<leader>cw",
    --   "<cmd>Yazi cwd<cr>",
    --   desc = "Open the file manager in nvim's working directory",
    -- },
    -- {
    --   "<c-up>",
    --   "<cmd>Yazi toggle<cr>",
    --   desc = "Resume the last yazi session",
    -- },
  },
  ---@type YaziConfig | {}
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
  },
  -- 👇 if you use `open_for_directories=true`, this is recommended
  init = function()
    -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    -- vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("yazi").config.forwarded_dds_events = { "AddFileToAvant" }

    vim.api.nvim_create_autocmd("User", {
      pattern = "YaziDDSCustom",
      -- see `:help event-args`
      ---@param event yazi.AutoCmdEvent
      callback = function(event)
        -- printing the messages will allow seeing them with `:messages` in tests
        -- print(vim.inspect {
        --   string.format("Just received a YaziDDSCustom event '%s'!", event.data.type),
        --   event.data,
        -- })

        -- 添加文件到avant.nvim
        if event.data.type == "AddFileToAvant" then
          local json = vim.json.decode(event.data.raw_data)
          local selected_file = assert(json.selected_file)

          local relative_path = require("avante.utils").relative_path(selected_file)

          local sidebar = require("avante").get()

          local open = sidebar:is_open()
          -- 记录当前窗口ID，以便后续重新定位回yazi窗口
          -- local current_win = vim.api.nvim_get_current_win()

          -- ensure avante sidebar is open
          if not open then
            require("avante.api").ask()
            sidebar = require("avante").get()

            -- -- 等待一小段时间确保avante完全打开
            -- vim.defer_fn(function()
            --   -- 重新定位到yazi窗口
            --   if vim.api.nvim_win_is_valid(current_win) then vim.api.nvim_set_current_win(current_win) end
            -- end, 100)
          end

          -- print(relative_path)
          sidebar.file_selector:add_selected_file(relative_path)

          -- local new_cwd = vim.fn.fnamemodify(selected_file, ":p:h")

          -- change Neovim's current working directory
          -- vim.cmd("cd " .. new_cwd)
        end
      end,
    })
  end,
}
