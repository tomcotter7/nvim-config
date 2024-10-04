local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, {desc="(A)dd file to (h)arpoon"})
vim.keymap.set("n", "<leader>hr", function() harpoon:list():remove() end, {desc="(R)emove file from (h)arpoon"})
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, {desc="(E)xplore current harpooned files"})

vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, {desc="(H)arpoon (1)"})
vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, {desc="(H)arpoon (2)"})
vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, {desc="(H)arpoon (3)"})
vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, {desc="(H)arpoon (4)"})


