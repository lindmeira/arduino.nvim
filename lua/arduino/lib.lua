local config = require 'arduino.config'
local util = require 'arduino.util'
local term = require 'arduino.term'

local M = {}

local cache_file = vim.fn.stdpath 'cache' .. '/arduino_libs.json'
local cache_expiration = 24 * 60 * 60 -- 1 day (example was 7 days, 1 day seems safer for active devs)

-- Asynchronously run a command and collect JSON output
local function exec_json(cmd, callback)
  local stdout = {}
  local stderr = {}

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          table.insert(stdout, line)
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          table.insert(stderr, line)
        end
      end
    end,
    on_exit = function(_, code)
      if code ~= 0 then
        -- util.notify('Command failed: ' .. cmd, vim.log.levels.ERROR)
        callback(nil)
        return
      end
      local result = table.concat(stdout, '')
      local ok, decoded = pcall(vim.json.decode, result)
      if ok then
        callback(decoded)
      else
        util.notify('Failed to parse JSON output', vim.log.levels.ERROR)
        callback(nil)
      end
    end,
  })
end

function M.update_index(callback)
  util.notify('Updating library index...', vim.log.levels.INFO)
  term.run_silent('arduino-cli lib update-index', 'Library Index Update', callback)
end

function M.search(callback)
  -- Check cache
  local stat = vim.loop.fs_stat(cache_file)
  if stat and (os.time() - stat.mtime.sec) < cache_expiration then
    local f = io.open(cache_file, 'r')
    if f then
      local content = f:read '*a'
      f:close()
      local ok, data = pcall(vim.json.decode, content)
      if ok then
        callback(data)
        return
      end
    end
  end

  util.notify('Fetching library list (this may take a moment)...', vim.log.levels.INFO)
  exec_json('arduino-cli lib search --format json', function(data)
    if data then
      -- Cache result
      local f = io.open(cache_file, 'w')
      if f then
        f:write(vim.json.encode(data))
        f:close()
      end
      util.notify('Library list updated.', vim.log.levels.INFO)
    end
    callback(data)
  end)
end

function M.list_installed(callback)
  exec_json('arduino-cli lib list --format json', callback)
end

function M.list_outdated(callback)
  exec_json('arduino-cli outdated --format json', callback)
end

function M.install(name, callback)
  local cmd = 'arduino-cli lib install "' .. name .. '"'
  term.run_silent(cmd, 'Library Installation', callback)
end

function M.uninstall(name, callback)
  local cmd = 'arduino-cli lib uninstall "' .. name .. '"'
  term.run_silent(cmd, 'Library Removal', callback)
end

function M.upgrade(name, callback)
  local cmd = 'arduino-cli lib upgrade "' .. name .. '"'
  term.run_silent(cmd, 'Library Upgrade', callback)
end

return M
