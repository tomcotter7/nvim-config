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
  end
}
