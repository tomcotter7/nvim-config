require("tcotts.set")
require("tcotts.remap")
require("config.lazy")

vim.g['airline#extensions#branch#enabled'] = 1

vim.o.background = "dark"
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  -- command = "AirlineTheme violet",
  command = "AirlineTheme light"
})
