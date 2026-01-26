# AGENTS.md

> **Repository:** arduino.nvim (Neovim plugin for Arduino integration)
> 
> **Purpose:** This guide is for software/code-writing AGENTS (human or machine) working in this repository. It summarizes build/test workflows, coding conventions, error handling, agent best-practices, and expected style, based on thorough analysis and ongoing updates.

---

## Library & Core Manager Fallback UI Status Symbols

Both the Arduino **Library Manager** and **Core Manager** fallback UIs (used when Telescope is disabled or unavailable) visually mark search results with status indicators:

| Status     | Emoji   | Fallback Symbol |
|------------|---------|----------------|
| Installed  | 🟢      | ✓              |
| Outdated   | 🟠      | ↑              |
| Available  | (none)  | (none)         |

- Emoji/tick/up-arrow indicators appear for both cores and libraries at the END of each line (🟢 for installed, 🟠 for outdated, or tick/arrow if `manager_emoji = false`).
- No visual mark for libraries/cores that are available but not installed/outdated.
- Highlight groups (e.g., `ArduinoLibraryInstalled`, `ArduinoLibraryOutdated`) are applied for richer UI integration.
- Multi-selection and richer preview are available only with Telescope (`use_telescope = true`). Fallback UI supports only single selection and minimal preview.
- Symbols and config options are explained here and in the README.

**Config:**
- To disable emoji indicators, set `manager_emoji = false` in the plugin configuration for `require('arduino').setup()`.
- To force fallback UI, set `use_telescope = false`.
- Example:

```lua
require('arduino').setup({
  manager_emoji = false,
  use_telescope = false,
})
```

This will make the fallback lists use tick (✓) and up-arrow (↑) ASCII symbols instead of emoji.

---

## 1. Build, Lint & Test Instructions

### 1.1 Requirements
- **Neovim 0.7+** (required)
- **arduino-cli** ([Install guide](https://arduino.github.io/arduino-cli/latest/installation/)) — **MANDATORY**
- **arduino-language-server** (optional, recommended for LSP integration)

### 1.2 Building/Installing the Plugin
- This repository is a pure Lua plugin; there is no build process.
- Installation options:
  - **lazy.nvim**:
    ```lua
    {
      "lindmeira/arduino.nvim",
      ft = "arduino",
      config = function()
        require("arduino").setup({ ... })
      end,
    }
    ```
  - **packer.nvim/manual**: Place in `runtimepath` and reload modified modules with `:luafile` or `:PackerCompile`/`lazy.nvim` reloads.

### 1.3 Configuration Options
- All config options can be set in `require('arduino').setup({ ... })`:
  - `board` — Default board (FQBN; e.g. 'arduino:avr:uno')
  - `programmer` — Optional programmer
  - `serial_cmd` — Serial monitor command; options: `'arduino-cli'` (default), `'screen'`, `'minicom'`, `'picocom'` or full custom string
  - `serial_baud` — Baud rate (default 9600)
  - `auto_baud` — If `true`, detect baud rate from `Serial.begin()` in sketch (default: `true`)
  - `manager_emoji` — `true` for emoji, `false` for tick/arrow fallback
  - `use_telescope` — `true` for enhanced picker; `false` for fallback UI
  - `build_path` — Custom build target directory
  - `floating_window` — UI style customization (`style = 'telescope'` or `'lualine'`)

- Most config options persist via `sketch.yaml` and survive plugin restarts. Exception: baud rate (`serial_baud`), which may be session-only if changed interactively.

### 1.4 Testing & Validation
- **No automated test suite or linter by default.** Agents must manually validate code and workflows:
  1. Launch Neovim with the plugin loaded.
  2. Open an Arduino sketch (`.ino`); plugin creates/refreshes `sketch.yaml`.
  3. Use these EX commands for features:
     - `:ArduinoVerify` — Compile
     - `:ArduinoUpload` — Compile & upload
     - `:ArduinoMonitor` — Serial monitor
     - `:ArduinoSelectBoard` — Select board
     - `:ArduinoSelectPort` — Select serial port
     - `:ArduinoUploadAndMonitor` — Upload + monitor
     - `:ArduinoLibraryManager` — Library management (install/update/remove)
     - `:ArduinoCoreManager` — Core management (install/update/remove)
     - `:ArduinoSelectProgrammer` — Select programmer
     - `:ArduinoSetBaud` — Set baud rate (interactive)
     - `:ArduinoGetInfo` — Show config info
     - `:ArduinoCheckLogs` — Show log buffer
  4. Check statusline/messages/logs for results.

#### Statusline
- Automatic Lualine integration: Arduino status will appear in `lualine_x` for Arduino files; manual integration available via `require('arduino.status').string()`.

#### Manual Test Guidance for Agents
- Reload plugin with `:luafile %`, `:PackerCompile`, or equivalent after changes.
- Open `.ino` file, trigger commands, inspect feedback/logs as described above.
- Print/log debug messages using `vim.notify` (and `vim.api.nvim_out_write`) for diagnostics.

#### Headless/Automation
- No CI/headless test harness as of 2026; agents may script Neovim sessions for feature checks. Add documentation and update AGENTS.md if automation/testing tools/scripts are added in future.

---

## 2. Coding Style Guidelines

### 2.1 Imports & Module Definition
- Use `require 'modulename'` for imports.
- Define modules as:
  ```lua
  local M = {}
  -- ...
  return M
  ```
- Attach public functions to `M`; private helpers as plain `local function ...`.
- ALWAYS prefer `local` module state (guard against global variable pollution).

### 2.2 Formatting & Naming
- Indent with 2 spaces, NO tabs.
- Line length <= 100 chars (prefer 80).
- Trailing commas for multiline tables.
- Snake_case for variables, functions, and module tables (constants: ALL_CAPS/CamelCase ok for common idioms).
- Filenames: snake_case or lowercase only.

### 2.3 Error Handling
- Use `pcall` for potentially erroring calls (JSON, require, IO).
- Always surface errors/warnings with `vim.notify(msg, level, {title=...})` or `vim.notify_once` if repeated.
- For return-value errors, return `nil` or `false` and log the error.
- DO NOT swallow errors unless critically necessary; always log/notify for visibility.
- For major issues or workflow events, log via plugin status or `:ArduinoCheckLogs`.

### 2.4 Comments, Documentation, & LSP
- Use single-dash comments for inline docs: `-- explanatory comment`
- For functions or public APIs, prefer block-comments or LSP docstrings:
  ```lua
  --- @param foo string: the foo parameter
  function M.bar(foo)
  ```
- Use `---@param` / `---@return` style for LSP support.

### 2.5 Table Manipulation and Updates
- Use `vim.tbl_deep_extend` for merging config tables.
- Avoid mutating shared tables unless documented.

### 2.6 Anti-patterns to Avoid
- Global variable pollution; always prefer locals and module tables.
- Large functions; prefer to break logic for readability.
- Magic, hardcoded values; use config, constants, or document clearly.
- Silence on error; ensure issues are surfaced via notify/log.
- UI/OS-specific hacks; encapsulate and always document or guard by platform.
- Legacy/deprecated commands or commented dead code (marked as "TO BE REMOVED" in code) — these should be cleaned up to maintain clarity.
- Reload without appropriate guards; always use `if vim.g.loaded_... then return end` at module start to prevent repeat setup side effects.

---

## 3. Agent Operation & Automation Best Practices

- After code changes, **reload the plugin** in Neovim and always check for errors via command line, status output, or requiring the module interactively.
- Validate features by triggering commands in Neovim (see above command list; mapped one-to-one to plugin actions).
- Use `vim.notify` and log buffer for visible agent/human feedback for all potentially error-prone actions.
- When automating, use proper Neovim RPC, CLI, or session API for scripting checks and reloads.
- If adding new features, consider `.lua` smoke tests in module files or helpers — document this in AGENTS.md as soon as added.
- No test directory or automated harness as of 2026; if you introduce CI/linter, update this file and add example scripts.
- For headless/automation, script test cases using Neovim session, load plugin, run commands, and check logs/output for expected errors and feedback.
- Never break Neovim startup or cause global/plugin-wide side effects; always use loaded guards.

---

## 4. Human and Agent Collaboration & Change Practices

- **AGENTS.md must be kept up to date.**
  - If you add new features, workflows, CI/test harness, linter, or alter major conventions, update this file AND the README.
  - Document any new automation scripts, CLI, helpers, or plugin UX patterns as soon as introduced.
  - If you solve problems outside the scope of the doc, add a section and detail for future agents.
- If conventions change, make cross-references between sections for discoverability (e.g., "see Coding Standards for reload safety").
- For major workflow changes, onboard future agents by providing example scripts, workflow demos, config snippets.
- Reference latest Neovim-Lua ecosystem standards and community guidelines where appropriate.

---

**This AGENTS.md was comprehensively updated in Jan 2026 after a full audit and workflow review. All command names, configuration options, UI workflows, coding/operation standards, and anti-patterns represent the latest best-practices and realities of this repository. Review this file after any major UX, plugin, or documentation change.**
