# arduino.nvim Context for Gemini

## Project Overview
`arduino.nvim` is a comprehensive Neovim plugin for Arduino development, written entirely in Lua. It acts as a robust wrapper around `arduino-cli`, providing a seamless workflow for compiling, uploading, and managing Arduino projects directly from Neovim. It is optimized for Linux but designed for broad Neovim (0.7+) compatibility.

## Key Features
- **Pure Lua Implementation**: Fast, modular, and easy to configure.
- **`arduino-cli` Integration**: Leverages the official CLI for all core operations (compile, upload, board management).
- **`sketch.yaml` Persistence**: Automatically reads and writes `sketch.yaml` for project-specific configurations (FQBN, port, programmer), ensuring compatibility with the standard Arduino CLI workflow.
- **LSP Integration**: Automatically restarts `arduino_language_server` whenever the board or port configuration changes to maintain accurate diagnostics and completions.
- **Enhanced UI**: Built-in support for `telescope.nvim` for all selection menus (boards, ports, libraries, cores) with robust `vim.ui.select` fallbacks.
- **Automatic Statusline**: Injects a status component into `lualine.nvim` automatically, showing the current board, programmer, port, and baud rate.
- **Serial Monitor**: Integrated terminal-based serial monitor with support for multiple backends (`arduino-cli`, `screen`, `minicom`, `picocom`) and auto-baud detection from sketch code.
- **Library & Core Management**: Full-featured managers for installing, updating, and removing Arduino libraries and cores.
- **Log Management**: dedicated log buffer with ANSI color support and memory usage reporting after compilation/upload.

## Architecture & Codebase Structure
The plugin source is located in `lua/arduino/`.
- **`init.lua`**: Main entry point. Handles `setup()`, command implementations, and UI logic for selection menus and managers.
- **`config.lua`**: Manages configuration defaults, global overrides, and option merging.
- **`cli.lua`**: High-level wrappers for constructing `arduino-cli` commands (compile, upload, monitor).
- **`util.lua`**: Critical utility functions for `sketch.yaml` I/O, LSP restarts, baud rate detection, and notifications.
- **`boards.lua`**: Handles fetching and parsing board and programmer lists from the CLI.
- **`core.lua` & `lib.lua`**: Logic for managing Arduino cores and libraries respectively.
- **`term.lua`**: Execution logic for running CLI commands (silent jobs or terminal buffers).
- **`status.lua`**: Logic for generating the statusline string.
- **`log.lua`**: Internal logging system for capturing and displaying command output.

## Development Workflow
- **No Build Step**: The project is interpreted Lua. Changes take effect upon restarting Neovim or reloading the plugin.
- **Testing**: Manual verification is the current standard. Open an Arduino sketch (`.ino`) and execute commands.
- **Styling**: Adheres to standard Lua idioms (snake_case). Uses `vim.notify` for user feedback and `pcall` for robust execution of external tools.

## Installation & Configuration
**Requirements**: Neovim 0.7+, `arduino-cli` (in PATH), `arduino-language-server` (optional for LSP).

**Setup Example**:
```lua
require('arduino').setup({
    board = 'arduino:avr:uno',
    serial_baud = 9600,
    auto_baud = true,
    use_telescope = true,
})
```

## Core Commands
| Command | Description |
| :--- | :--- |
| `:ArduinoSelectBoard` | Choose board FQBN (updates `sketch.yaml` and restarts LSP). |
| `:ArduinoSelectPort` | Choose serial port (updates `sketch.yaml` and restarts LSP). |
| `:ArduinoSelectProgrammer` | Choose hardware programmer. |
| `:ArduinoVerify` | Compile the current sketch. |
| `:ArduinoUpload` | Compile and upload the sketch. |
| `:ArduinoMonitor` | Open the serial monitor in a floating window. |
| `:ArduinoUploadAndMonitor` | Upload then immediately open the serial monitor. |
| `:ArduinoLibraryManager` | Manage Arduino libraries (Telescope-powered). |
| `:ArduinoCoreManager` | Manage Arduino board cores. |
| `:ArduinoCheckLogs` | View the command execution logs (with memory usage info). |
| `:ArduinoSetBaud` | Manually set or auto-detect baud rate for the monitor. |
| `:ArduinoGetInfo` | Print current configuration details. |

## Agent Guidelines
- **Project Config**: Always check for `sketch.yaml` or use `util.update_sketch_config` when modifying board/port settings.
- **UI**: Prefer Telescope-based interactions if available; ensure fallbacks are maintained.
- **LSP**: Ensure `util.restart_lsp()` is called after configuration changes that affect the language server.
- **Error Handling**: Wrap CLI interactions in `pcall` and use `util.notify` for user-facing errors.
