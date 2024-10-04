vim.keymap.set("n", "<leader>no", vim.cmd.NERDTreeVCS, {desc="(N)ERDTree (O)pen"})
vim.keymap.set("n", "<leader>nt", vim.cmd.NERDTreeToggleVCS, {desc="(N)ERDTree (T)oggle"})
vim.keymap.set("n", "<leader>nr", vim.cmd.NERDTreeExplore, {desc="Open (N)ERDTree (R)oot"})

vim.g.NERDTreeIgnore = {'venv$[[dir]]', 'node_modules$[[dir]]', '__pycache__$[[dir]]'}
