return {
  "github/copilot.vim",
  config = function()
    vim.g.copilot_filetypes = {
      ["*"] = false
    }
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    -- vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
    vim.keymap.set({ "i", "n" }, "<C-J>", "<CMD>Copilot panel<CR>", { desc = "Open (C)opilot (P)anel" })
  end
}
