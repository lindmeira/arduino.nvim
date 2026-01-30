local log = require 'arduino.log'
local util = require 'arduino.util'

local M = {}

function M.run_silent(cmd, opts, callback)
  local success_msg, fail_msg
  if type(opts) == 'table' then
    success_msg = opts.success
    fail_msg = opts.fail
  else
    success_msg = opts .. ' successful.'
    fail_msg = opts .. ' failed. Check logs with :ArduinoCheckLogs.'
  end

  log.clear()
  log.add('Running: ' .. cmd)

  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      log.add(data)
    end,
    on_stderr = function(_, data)
      log.add(data)
    end,
    on_exit = function(_, code)
      if code == 0 then
        local msg = success_msg
        local stats = util.get_memory_usage_info()
        if stats then
          msg = msg .. ' ' .. stats
        end
        util.notify(msg, vim.log.levels.INFO)
        if callback then
          vim.schedule(callback)
        end
      else
        util.notify(fail_msg, vim.log.levels.ERROR)
      end
    end,
  })
end

return M
