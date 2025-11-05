return {
  "rose-pine/neovim",
  name = "rose-pine",
  config = function()
    require("rose-pine").setup({
      variant = "auto",
      dark_variant = "moon",
      dim_inactive_windows = true
    })

    vim.cmd("colorscheme rose-pine")
  end
}
