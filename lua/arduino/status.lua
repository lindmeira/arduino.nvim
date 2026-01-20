local config = require 'arduino.config'
local cli = require 'arduino.cli'

local M = {}

function M.string()
  if vim.bo.filetype ~= 'arduino' then
    return ''
  end

  local board = config.options.board or 'No Board'
  local port = cli.get_port()
  if port then
    port = vim.trim(port)
  end
  if not port or port == '' then
    port = 'None'
  end

  local prog = config.options.programmer
  local prog_str = ''
  if prog and prog ~= '' then
    prog_str = string.format(' [%s]', prog)
  end

  local baud = config.options.serial_baud
  local port_str = port
  if baud then
    port_str = string.format('%s:%s', port, baud)
  end

  return string.format('[%s]%s (%s)', board, prog_str, port_str)
end

return M
