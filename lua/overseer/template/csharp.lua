local overseer = require "overseer"

function findPatterns(str)
  if string.find(str, "%.api") or string.find(str, "%.web") or string.find(str, "%.app") then return true end
  return false
end

return {
  condition = {
    filetype = "cs", -- 仅在 C# 文件中激活
    callback = function(search)
      -- 你也可以在这里添加额外逻辑，比如检查是否存在 .sln 文件
      local sln = vim.fs.find(
        function(name, path) return name:match ".*%.sln$" end,
        { upward = false, type = "file", path = vim.fn.getcwd() }
      )[1]
      return sln ~= nil
    end,
  },
  generator = function(search, cb)
    local sln_path = vim.fs.find(
      function(name, path) return name:match ".*%.sln$" end,
      { upward = false, type = "file", path = vim.fn.getcwd() }
    )[1]

    -- print(sln_path)
    if not sln_path then return cb {} end

    local lines = vim.fn.readfile(sln_path)
    -- print(lines)
    local templates = {}

    for _, line in ipairs(lines) do
      local name = line:match 'Project%(".*%"%) = "([^"]+)", "([^"]+%.csproj)"'
      if name then
        -- print(name)
        -- local name, rel_path = line:match 'Project%(".*%"%) = "([^"]+)", "([^"]+%.csproj)"'
        if name and findPatterns(name:lower()) then
          -- print(true)
          -- print(vim.fn.fnamemodify(sln_path, ":h"))

          local csproj = vim.fs.find(name, { upward = false, type = "directory", path = vim.fn.getcwd() })[1]

          table.insert(templates, {
            name = "Run " .. name,
            desc = "dotnet run for " .. name,
            builder = function()
              return {
                cmd = { "dotnet" },
                args = { "run", "--project", csproj, "--no-self-contained", "--no-restore", "-v q" },
                cwd = vim.fn.fnamemodify(sln_path, ":h"),
                components = { "default" },
              }
            end,
            tags = { overseer.TAG.RUN },
            priority = 50,
          })

          table.insert(templates, {
            name = "Watch run " .. name,
            desc = "dotnet watch run for " .. name,
            builder = function()
              return {
                cmd = { "dotnet" },
                args = { "watch", "run", "--project", csproj, "--no-self-contained", "--no-restore", "-v q" },
                cwd = vim.fn.fnamemodify(sln_path, ":h"),
                components = { "default" },
              }
            end,
            tags = { overseer.TAG.RUN },
            priority = 50,
          })
        end
      end
    end

    cb(templates)
  end,

  cache_key = function(opts) return vim.fs.find("*.sln", { upward = true, type = "file", path = opts.dir })[1] end,
}
