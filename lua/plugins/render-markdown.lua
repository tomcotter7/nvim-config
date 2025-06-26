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
    },
    ignore = function(buf)
      local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
      if buftype == "nofile" then
        return true
      end
      return false
    end

  },
  ft = { "markdown", "Avante" },
}
