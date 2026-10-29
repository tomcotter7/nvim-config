return {
  "rose-pine/neovim",
  name = "rose-pine",
  config = function()
    require("rose-pine").setup({
      variant = "dawn",
      dark_variant = "moon",
      dim_inactive_windows = true
    })

    -- ColorScheme command fires after any `colorscheme` command.
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "rose-pine*",
      callback = function()
        if require("rose-pine.config").options.variant == "dawn" then
          vim.api.nvim_set_hl(0, "DiffChange", { bg = "#f5dfe4" })
          vim.api.nvim_set_hl(0, "DiffText", { bg = "#d7827e", fg = "#faf4ed", bold = true })
        end
      end,
    })

    vim.cmd("colorscheme rose-pine")

    vim.keymap.set("n", "<leader>tb", function()
      local dawn = require("rose-pine.config").options.variant == "dawn"
      vim.cmd.colorscheme(dawn and "rose-pine-moon" or "rose-pine-dawn")
    end, { desc = "toggle rose-pine dawn/moon" })
  end
}
