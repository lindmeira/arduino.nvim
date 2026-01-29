-- Typical arduino.nvim setup for LazyVim
return {
  'lindmeira/arduino.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim', -- Optional: for better UI/UX
  },
  ft = 'arduino',
  config = function()
    require('arduino').setup {
      auto_baud = true,
      serial_baud = 57600,
      -- serial_cmd = 'screen', -- 'arduino-cli' (default), 'screen', 'minicom' or 'picocom'
      -- manager_emoji = false, -- Defaults to true
      -- use_telescope = false, -- Defaults to true if available
      -- fullscreen_debug = true, -- Defaults to false
      -- build_path = '{project_dir}/build',
      -- floating_window = { -- Configure floating windows style (logs, monitor)
      --   style = 'telescope', -- 'telescope' (default) or 'lualine'
      -- },
    }
  end,
  keys = {
    { '<leader>ab', '<cmd>ArduinoSelectBoard<cr>', desc = 'Select Board' },
    { '<leader>ac', '<cmd>ArduinoVerify<cr>', desc = 'Compile/Verify' },
    { '<leader>af', '<cmd>ArduinoUpload<cr>', desc = 'Flash Firmware' },
    -- { '<leader>ai', '<cmd>ArduinoGetInfo<cr>', desc = 'Current Settings' },
    { '<leader>al', '<cmd>ArduinoCheckLogs<cr>', desc = 'Check Logs' },
    { '<leader>ap', '<cmd>ArduinoSelectPort<cr>', desc = 'Select Port' },
    { '<leader>ar', '<cmd>ArduinoSetBaud<cr>', desc = 'Select Baud' },
    { '<leader>as', '<cmd>ArduinoMonitor<cr>', desc = 'Serial Monitor' },
    { '<leader>at', '<cmd>ArduinoSelectProgrammer<cr>', desc = 'Select Programmer' },
    { '<leader>au', '<cmd>ArduinoUploadAndMonitor<cr>', desc = 'Flash and Monitor' },
    -- Hidden shortcuts
    { '<leader>av', '<cmd>ArduinoVerify<cr>', desc = 'which_key_ignore' },
    -- Grouped shortcuts
    { '<leader>anc', '<cmd>ArduinoCoreManager<cr>', desc = 'Core Manager' },
    { '<leader>anl', '<cmd>ArduinoLibraryManager<cr>', desc = 'Library Manager' },
    { '<leader>anr', '<cmd>ArduinoResetSimulation<cr>', desc = 'Reset Simulation' },
    { '<leader>ans', '<cmd>ArduinoSelectSimulator<cr>', desc = 'Select Simulator' },
    { '<leader>anv', '<cmd>ArduinoSimulateAndDebug<cr>', desc = 'Simulate and Debug' },
    { '<leader>anx', '<cmd>ArduinoSimulateAndMonitor<cr>', desc = 'Simulate and Monitor' },
  },
}
