-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end


-- INFO: settings to set nushell as the shell for the :! command
-- --
-- path to the Nushell executable
vim.opt.sh = "nu"

-- WARN: disable the usage of temp files for shell commands
-- because Nu doesn't support `input redirection` which Neovim uses to send buffer content to a command:
--      `{shell_command} < {temp_file_with_selected_buffer_content}`
-- When set to `false` the stdin pipe will be used instead.
-- NOTE: some info about `shelltemp`: https://github.com/neovim/neovim/issues/1008
vim.opt.shelltemp = false

-- string to be used to put the output of shell commands in a temp file
-- 1. when 'shelltemp' is `true` 
-- 2. in the `diff-mode` (`nvim -d file1 file2`) when `diffopt` is set 
--    to use an external diff command: `set diffopt-=internal`
vim.opt.shellredir = "out+err> %s"

-- flags for nu:
-- * `--stdin`       redirect all input to -c
-- * `--no-newline`  do not append `\n` to stdout
-- * `--commands -c` execute a command
vim.opt.shellcmdflag = "--stdin --no-newline -c"

-- disable all escaping and quoting
vim.opt.shellxescape = ""
vim.opt.shellxquote = ""
vim.opt.shellquote = ""

-- string to be used with `:make` command to:
-- 1. save the stderr of `makeprg` in the temp file which Neovim reads using `errorformat` to populate the `quickfix` buffer
-- 2. show the stdout, stderr and the return_code on the screen
-- NOTE: `ansi strip` removes all ansi coloring from nushell errors
vim.opt.shellpipe = '| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record'

require "lazy_setup"
require "polish"
