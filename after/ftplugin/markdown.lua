vim.keymap.set("i", ";1", "#<Space>")
vim.keymap.set("i", ";2", "##<Space>")
vim.keymap.set("i", ";3", "###<Space>")

vim.keymap.set("n", "<leader>hd1", "<cmd>vimgrep /^# / %<cr>")
vim.keymap.set("n", "<leader>hd2", "<cmd>vimgrep /^## / %<cr>")
