return {
  "meira/vim-arduino",
  dependencies = {
    -- Optional: if you want a better UI for board/port selection
    -- "nvim-telescope/telescope.nvim",
  },
  ft = "arduino",
  config = function()
    require("arduino").setup({
      -- Default configuration (can be omitted)
      use_cli = true, -- Use arduino-cli if available
      serial_baud = 9600,
      auto_baud = true,
      -- build_path = "{project_dir}/build",
    })
  end,
  keys = {
    { "<leader>am", "<cmd>ArduinoVerify<cr>", desc = "Verify/Compile" },
    { "<leader>au", "<cmd>ArduinoUpload<cr>", desc = "Upload" },
    { "<leader>as", "<cmd>ArduinoSerial<cr>", desc = "Serial Monitor" },
    { "<leader>ab", "<cmd>ArduinoChooseBoard<cr>", desc = "Select Board" },
    { "<leader>ap", "<cmd>ArduinoChoosePort<cr>", desc = "Select Port" },
  },
}
