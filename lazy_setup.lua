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
      -- manager_emoji = false, -- Defaults to true, works when use_telescope = false
      -- use_telescope = false, -- Defaults to true if available
      -- fullscreen_debug = true, -- Defaults to false
      -- debug_split_ratio = 0.5, -- Defaults to .66
      -- debug_serial_split = false, -- Defaults to true
      -- debug_horizontal_split = true, -- Defaults to false
      -- build_path = '{project_dir}/build',
      -- floating_window = { -- Configure floating windows style (logs, monitor)
      --   style = 'lualine', -- 'telescope' (default) or 'lualine'
      -- },
    }
  end,
  keys = {
    { '<leader>ab', '<cmd>ArduinoSelectBoard<cr>', desc = 'Select Board' },
    { '<leader>ac', '<cmd>ArduinoVerify<cr>', desc = 'Compile/Verify' },
    -- { '<leader>ai', '<cmd>ArduinoGetInfo<cr>', desc = 'Current Settings' },
    { '<leader>al', '<cmd>ArduinoCheckLogs<cr>', desc = 'Check Logs' },
    { '<leader>ad', '<cmd>ArduinoMonitor<cr>', desc = 'Serial Monitor' },
    { '<leader>ap', '<cmd>ArduinoSelectPort<cr>', desc = 'Select Port' },
    { '<leader>ar', '<cmd>ArduinoSetBaud<cr>', desc = 'Select Baud' },
    { '<leader>at', '<cmd>ArduinoSelectProgrammer<cr>', desc = 'Select Programmer' },
    -- Hidden shortcuts
    { '<leader>av', '<cmd>ArduinoVerify<cr>', desc = 'which_key_ignore' },
    -- Grouped shortcuts: f (flash)
    { '<leader>aff', '<cmd>ArduinoUpload<cr>', desc = 'Flash Firmware' },
    { '<leader>afm', '<cmd>ArduinoUploadAndMonitor<cr>', desc = 'Flash and Monitor' },
    -- Grouped shortcuts: m (manager)
    { '<leader>amc', '<cmd>ArduinoCoreManager<cr>', desc = 'Core Manager' },
    { '<leader>ama', '<cmd>ArduinoThirdPartyCore<cr>', desc = 'Add Core URL' },
    { '<leader>aml', '<cmd>ArduinoLibraryManager<cr>', desc = 'Library Manager' },
    -- Grouped shortcuts: s (simulation)
    { '<leader>asr', '<cmd>ArduinoResetSimulation<cr>', desc = 'Reset Simulation' },
    { '<leader>ass', '<cmd>ArduinoSelectSimulator<cr>', desc = 'Select Simulator' },
    { '<leader>asd', '<cmd>ArduinoSimulateAndDebug<cr>', desc = 'Simulate and Debug' },
    { '<leader>asm', '<cmd>ArduinoSimulateAndMonitor<cr>', desc = 'Simulate and Monitor' },
  },
}
