return {
  "mason-org/mason.nvim",
  dependencies = { "mason-org/mason-lspconfig.nvim" },
  config = function()
    require('mason').setup({
      ui = {
        border = "rounded"
      }
    })
    require('mason-lspconfig').setup({
      ensure_installed = { 'lua_ls', 'ruff', 'basedpyright', 'ts_ls', 'gopls' },
    })
  end
}
