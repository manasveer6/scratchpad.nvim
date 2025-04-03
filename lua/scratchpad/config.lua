local Config = {}

Config.options = {
  keymap_open = "<leader>sp",
  keymap_toggle = "<leader>tc",
}

function Config.set(user_config)
  if user_config then
    Config.options = vim.tbl_extend("force", Config.options, user_config)
  end
end

return Config
