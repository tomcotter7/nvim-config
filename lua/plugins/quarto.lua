return {
  "quarto-dev/quarto-nvim",
  dependencies = {
    "jmbuhr/otter.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local quarto = require("quarto")
    quarto.setup({
      lspFeatures = {
        languages = { "python" },
        chunks = "all",
        diagnostics = {
          enabled = true,
          triggers = { "BufWritePost" },
        },
        completion = {
          enabled = true,
        },
      },
      codeRunner = {
        enabled = true,
        default_method = "slime",
      },
    })

    local runner = require("quarto.runner")
    vim.keymap.set("n", "<localleader>rc", runner.run_cell, { desc = "run cell", silent = true })
    vim.keymap.set("n", "<localleader>ra", runner.run_above, { desc = "run cell and above", silent = true })
    vim.keymap.set("n", "<localleader>rA", runner.run_all, { desc = "run all cells", silent = true })
    vim.keymap.set("n", "<localleader>rl", runner.run_line, { desc = "run line", silent = true })
    vim.keymap.set("n", "<localleader>RA", function()
      runner.run_all(true)
    end, { desc = "run all cells of all languages", silent = true })

    vim.keymap.set("n", "<localleader>nc", "<cmd>call search('^```python')<CR>",
      { desc = "next cell", silent = true })
    vim.keymap.set("n", "<localleader>pc", "<cmd>call search('^```python', 'b')<CR>",
      { desc = "previous cell", silent = true })
    vim.keymap.set({ "n", "i" }, "<localleader>cc",
      "<Esc><cmd>call search('^```$')<CR>o<CR>```python<CR>```<Esc>0i<CR><Esc>k",
      { desc = "create new cell", silent = true })

    -- jupytext opens .ipynb as a markdown buffer, so quarto never auto-activates.
    -- Turn on otter LSP (completion + diagnostics) for python chunks in notebooks.
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = { "*.ipynb" },
      callback = function()
        require("quarto").activate()
      end,
    })
  end
}
