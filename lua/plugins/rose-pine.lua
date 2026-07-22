return {
  "rose-pine/neovim",
  name = "rose-pine",
  config = function()
    require("rose-pine").setup({
      variant = "dawn",
      dark_variant = "moon",
      dim_inactive_windows = true
    })

    vim.cmd("colorscheme rose-pine")
    vim.api.nvim_set_hl(0, "DiffChange", { bg = "#f5dfe4" })
    vim.api.nvim_set_hl(0, "DiffText", { bg = "#d7827e", fg = "#faf4ed", bold = true })
  end
}
