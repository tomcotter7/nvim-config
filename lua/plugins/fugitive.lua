return {
  "tpope/vim-fugitive",
  config = function()
    vim.keymap.set("n", "<leader>gd", "<cmd>Gdiffsplit<cr>", { desc = "(g)it (d)iff" })
    vim.keymap.set("n", "<leader>gvd", "<cmd>Gvdiffsplit<cr>", { desc = "(g)it (v)ertical (d)iff" })
    vim.keymap.set("n", "<leader>gs", "<cmd>Git<cr>", { desc = "(g)it (s)tatus" })
  end
}
