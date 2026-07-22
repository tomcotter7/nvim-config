return {
  {
    "zbirenbaum/copilot.lua",
    requires = {
      "copilotlsp-nvim/copilot-lsp",
    },
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<C-j>"
          }
        }
      })
    end
  }
}

-- return {
--   {
--     "github/copilot.vim",
--     config = function()
--       vim.g.copilot_enabled = true
--       vim.g.copilot_filetypes = { markdown = false }
--     end,
--   },
-- }
