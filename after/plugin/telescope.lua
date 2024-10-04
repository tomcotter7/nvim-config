local telescope = require('telescope.builtin')
vim.keymap.set("n", "<leader>gf", telescope.git_files, {desc="(G)it Search (F)iles"})
vim.keymap.set("n", "<leader>ff", telescope.find_files, {desc="(F)ind (F)iles"})
vim.keymap.set("n", "<leader>fg", telescope.live_grep, {desc="(F)ind (G)rep"})

