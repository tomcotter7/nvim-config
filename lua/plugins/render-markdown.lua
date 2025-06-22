return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    file_types = { "markdown", "Avante" },
    render_modes = true,
    latex = {
      enabled = false,
      top_pad = 0,
      bottom_pad = 0
    }
  },
  ft = { "markdown", "Avante" },
}
