local config = require 'arduino.config'
local util = require 'arduino.util'
local term = require 'arduino.term'

local M = {}

local cache_file = vim.fn.stdpath 'cache' .. '/arduino_cores.json'
local cache_expiration = 24 * 60 * 60 -- 1 day

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
  util.notify('Updating core index...', vim.log.levels.INFO)
  term.run_silent('arduino-cli core update-index', 'Core Index Update', callback)
end

function M.search(callback)
  -- Check cache
  local stat = vim.uv.fs_stat(cache_file)
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

  util.notify('Fetching core list (this may take a moment)...', vim.log.levels.INFO)
  exec_json('arduino-cli core search --format json', function(data)
    if data then
      -- Cache result
      local f = io.open(cache_file, 'w')
      if f then
        f:write(vim.json.encode(data))
        f:close()
      end
      util.notify('Core list updated.', vim.log.levels.INFO)
    end
    callback(data)
  end)
end

function M.list_installed(callback)
  exec_json('arduino-cli core list --format json', callback)
end

function M.list_outdated(callback)
  exec_json('arduino-cli outdated --format json', callback)
end

function M.install(id, callback)
  local cmd = 'arduino-cli core install "' .. id .. '"'
  term.run_silent(cmd, {
    success = 'Core ' .. id .. ' installed successfully.',
    fail = 'Failed to install core ' .. id .. '. Check logs with :ArduinoCheckLogs.'
  }, callback)
end

function M.uninstall(id, callback)
  local cmd = 'arduino-cli core uninstall "' .. id .. '"'
  term.run_silent(cmd, {
    success = 'Core ' .. id .. ' removed successfully.',
    fail = 'Failed to remove core ' .. id .. '. Check logs with :ArduinoCheckLogs.'
  }, callback)
end

function M.upgrade(id, callback)
  local cmd = 'arduino-cli core upgrade "' .. id .. '"'
  term.run_silent(cmd, {
    success = 'Core ' .. id .. ' upgraded successfully.',
    fail = 'Failed to upgrade core ' .. id .. '. Check logs with :ArduinoCheckLogs.'
  }, callback)
end

return M
