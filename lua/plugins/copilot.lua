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
            accept = "<C-j>",
            accept_line = "<C-l>",
            accept_word = "<C-w>",
          }
        },
        filetypes = {
          ["*"] = true,
        },
      })
    end
  }
}
