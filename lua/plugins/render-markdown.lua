return {
  'MeanderingProgrammer/render-markdown.nvim',
  -- commit = "e724a49",
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},
  config = function()
    require('render-markdown').setup({
      render_modes = true,
      latex = {
        enabled = false,
        top_pad = 0,
        bottom_pad = 0,
      },
    })
  end
}
