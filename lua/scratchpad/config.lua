local Config = {}

-- Default settings
Config.options = {
  keymap_open = "<leader>sp",
  keymap_toggle = "<leader>xc",

  width = 0.6,
  height = 0.6,
  row = 0.2,
  col = 0.2,

  relative = "editor",
  style = "minimal",
  border = "rounded",

  auto_checkbox = true,
  auto_indent = true,
}

-- Function to apply user settings
function Config.setup(user_config)
  Config.options = vim.tbl_deep_extend("force", Config.options, user_config or {})
end

return Config
