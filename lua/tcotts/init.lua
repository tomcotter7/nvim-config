require("tcotts.set")
require("tcotts.remap")
require("config.lazy")

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  command = "AirlineTheme molokai",
})
