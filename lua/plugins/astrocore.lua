-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing
-- Source: https://www.reddit.com/r/neovim/comments/1fzn1zt/custom_fold_text_function_with_treesitter_syntax/
local function fold_virt_text(result, start_text, lnum)
  local text = ""
  local hl
  for i = 1, #start_text do
    local char = start_text:sub(i, i)
    local captured_highlights = vim.treesitter.get_captures_at_pos(0, lnum, i - 1)
    local outmost_highlight = captured_highlights[#captured_highlights]
    if outmost_highlight then
      local new_hl = "@" .. outmost_highlight.capture
      if new_hl ~= hl then
        -- as soon as new hl appears, push substring with current hl to table
        table.insert(result, { text, hl })
        text = ""
        hl = nil
      end
      text = text .. char
      hl = new_hl
    else
      text = text .. char
    end
  end
  table.insert(result, { text, hl })
end
function _G.custom_foldtext()
  local start_text = vim.fn.getline(vim.v.foldstart):gsub("\t", string.rep(" ", vim.o.tabstop))
  local nline = vim.v.foldend - vim.v.foldstart
  local result = {}
  fold_virt_text(result, start_text, vim.v.foldstart - 1)
  table.insert(result, { "   ", nil })
  table.insert(result, { "", "DiagnosticWarn" })
  -- table.insert(result, { ' ... ↙ ' .. nline .. ' lines', 'DapBreakpointCondition' })
  table.insert(result, { "↙ " .. nline .. " lines ", "@comment.warning" })
  table.insert(result, { "", "DiagnosticWarn" })
  return result
end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = false, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      -- virtual_text = true,
      -- underline = true,
      underline = false,
      virtual_text = false,
      update_in_insert = false,
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = " ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        -- foo = "fooscript",
        cshtml = 'razor',
        razor = 'razor'
      },
      filename = {
        [".foorc"] = "fooscript",
        [".editorconfig"] = "json"
      },
      -- pattern = {
      --   [".*/etc/foo/.*"] = "fooscript",
      -- },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = true, -- sets vim.opt.wrap
        textwidth = 80,
        linebreak = true,
        breakindent = true,
        foldtext = "v:lua.custom_foldtext()",
        scrolloff = 10, -- 上下保留间距
        sidescrolloff = 10  -- 左右保留间距
      },
      g = { -- vim.g.<key>
        -- tokyonight_colors = { fg_gutter = "#707cb2", comment = "#709db2", dark5 = "#709db2" },
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
      o = {
        foldcolumn = "0", -- '0' is not bad
        foldlevel = 99, -- Using ufo provider need a large value, feel free to decrease the value
        foldlevelstart = 99,
        foldenable = true,
        foldmethod = "expr",
        fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]],
        foldexpr = "v:lua.vim.treesitter.foldexpr()",
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },
        ["<Leader>a"] = {
          desc = " Avante",
        },
        ["<leader>w"] = {
          desc = "󰖲 Window Manager",
        },
        ["<leader>wh"] = {
          "<C-w>h",
          desc = "Go to left window",
        },
        ["<leader>wl"] = {
          "<C-w>l",
          desc = "Go to right window",
        },
        ["<leader>wj"] = {
          "<C-w>j",
          desc = "Go to buttom window",
        },
        ["<leader>wk"] = {
          "<C-w>k",
          desc = "Go to up window",
        },
        ["<leader>w="] = {
          "<C-w>=",
          desc = "Equally high and side",
        },
        ["<leader>wc"] = {
          "<C-w>c",
          desc = "Close window",
        },
        ["<leader><tab>"] = {
          desc = "Tabs Manager"
        },
        ["<leader><tab><tab>"] = {
          "<cmd>tabnew<cr>",
          desc = "New tab"
        },
        ["<leader><tab>n"] = {
          "<cmd>tabnext<cr>",
          desc = "Go to next tab"
        },
        ["<leader><tab>p"] = {
          "<cmd>tabprevious<cr>",
          desc = "Go to prev tab"
        },
        ["<leader><tab>c"] = {
          "<cmd>tabclose<cr>",
          desc = "Close tab"
        },
        ["<leader><tab>l"] = {
          "<cmd>tablast<cr>",
          desc = "Go to last tab"
        },
        ["<leader><tab>h"] = {
          "<cmd>tabfirst<cr>",
          desc = "Go to first tab"
        },
        ["<leader><tab>1"] = {
          "<cmd>tabnext 1<cr>",
          desc = "Go to 1"
        },
        ["<leader><tab>2"] = {
          "<cmd>tabnext 2<cr>",
          desc = "Go to 2"
        },
        ["<leader><tab>3"] = {
          "<cmd>tabnext 3<cr>",
          desc = "Go to 3"
        },
        ["<leader><tab>4"] = {
          "<cmd>tabnext 4<cr>",
          desc = "Go to 4"
        },
        ["<leader><tab>5"] = {
          "<cmd>tabnext 5<cr>",
          desc = "Go to 5"
        },
        ["<leader><tab>6"] = {
          "<cmd>tabnext 6<cr>",
          desc = "Go to 6"
        },
        ["<leader><tab>7"] = {
          "<cmd>tabnext 7<cr>",
          desc = "Go to 7"
        },
        ["<leader><tab>8"] = {
          "<cmd>tabnext 8<cr>",
          desc = "Go to 8"
        },
        ["<leader><tab>9"] = {
          "<cmd>tabnext 9<cr>",
          desc = "Go to 9"
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
    },
  },
}
