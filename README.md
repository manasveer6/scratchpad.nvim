# Scratchpad.nvim

A simple floating scratchpad for tracking project tasks inside Neovim. Supports checkboxes, subtasks (with indentation), and customizable settings.

---

## Installation

### Lazy.nvim

```lua
{
  "yourusername/scratchpad.nvim",
  config = function()
    require("scratchpad").setup()
  end
}
```

### Packer.nvim

```lua
use({
  "yourusername/scratchpad.nvim",
  config = function()
    require("scratchpad").setup()
  end
})
```

---

## Configuration

Customize options by passing them into `setup()` in your `init.lua`:

```lua
require("scratchpad").setup({
  width = 0.6,        -- Window width (as fraction of Neovim screen)
  height = 0.6,       -- Window height
  row = 0.2,          -- Vertical position
  col = 0.2,          -- Horizontal position
  auto_checkbox = true, -- Auto-add checkboxes for new lines
  auto_indent = true,  -- Maintain indentation for subtasks
  relative = "editor", -- Window positioning ("editor", "win", "cursor")
  style = "minimal",   -- Always "minimal" for floating windows
  border = "rounded",  -- Border style ("none", "single", "double", "rounded", "solid", "shadow")
  keymap_open = "<leader>sp",  -- Keybinding to open scratchpad
  keymap_toggle = "<leader>xc", -- Keybinding to toggle checkboxes
  keymap_cmd = "ScratchPad",  -- Command name
})
```

---

## Usage

### Opening the Scratchpad

- Run `:ScratchPad` to toggle the floating window.
- Press `<leader>sp` (default) to open it via keybinding.

### Managing Tasks

- New tasks automatically start with `- [ ]`
- Press `Enter` to add a new checkbox task.
- Alternatively use `o` or `O` in normal mode to create a new checkbox task on a new line.
- Indent (`>>`) to create subtasks.
- Press `<leader>xc` to toggle checkboxes `[ ]` → `[✓]`
- Press `q` in normal mode to close the scratchpad.

---

## Features

- Floating scratchpad for project task tracking
- Auto-checkbox for new tasks
- Indent for subtasks
- Toggle checkboxes with a keybinding
- Customizable size, position, and appearance
- Works across all filetypes

---

## License

MIT License.

---

## Future Features

- [ ] Persistent tasks (save tasks across Neovim sessions)
- [ ] Custom checkbox symbols (e.g., `☐` → `✔`)
- [ ] Markdown export (`scratchpad.md`)
