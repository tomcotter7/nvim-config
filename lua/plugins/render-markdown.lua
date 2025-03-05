return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},
  config = function()
    require('render-markdown').setup({
      render_modes = true,
      latex = {
        enabled = true,
        top_pad = 0,
        bottom_pad = 0,
      },
    })
  end
}
