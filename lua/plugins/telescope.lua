return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
  },
  config = function()
    require('telescope').setup({
      extensions = {
        fzf = {}
      }
    })
    require('telescope').load_extension('fzf')
    local telescope = require('telescope.builtin')
    vim.keymap.set("n", "<leader>gf", telescope.git_files, { desc = "(G)it Search (F)iles" })
    vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "(F)ind (F)iles" })
    vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "(F)ind (G)rep" })
    vim.keymap.set("n", "<leader>en", function()
      telescope.find_files {
        cwd = vim.fn.stdpath("config")
      }
    end, { desc = "(E)dit (N)eovim Config" })
  end
}
