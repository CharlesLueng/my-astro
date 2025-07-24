return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    optional = true,
    opts = {
      -- default_component_configs = {
      --   window = {
      --     width = 80
      --   }
      -- },
      filesystem = {
        commands = {
          avante_add_files = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            -- print(filepath)
            local relative_path = require("avante.utils").relative_path(filepath)

            local sidebar = require("avante").get()

            local open = sidebar:is_open()
            -- ensure avante sidebar is open
            if not open then
              require("avante.api").ask()
              sidebar = require("avante").get()
            end

            -- print(relative_path)
            sidebar.file_selector:add_selected_file(relative_path)

            -- remove neo tree buffer
            if not open then sidebar.file_selector:remove_selected_file "neo-tree filesystem [1]" end
          end,
        },
        window = {
          -- width = 80,
          mappings = {
            ["oa"] = "avante_add_files",
          },
        },
      },
      window = {
        auto_expand_width = true
      }
    },
  },
}
