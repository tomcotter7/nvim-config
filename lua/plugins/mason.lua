return {
  "williamboman/mason.nvim",
  dependencies = { "williamboman/mason-lspconfig.nvim" },
  config = function()
    require('mason').setup({
      ui = {
        border = "rounded"
      }
    })
    require('mason-lspconfig').setup({
      ensure_installed = { 'lua_ls', 'ruff', 'pyright', 'ts_ls', 'gopls' } -- 'terraformls', 'texlab', 'groovyls', 'lemminx' }
    })
    require('mason-lspconfig').setup_handlers({
      function(server_name)
        require('lspconfig')[server_name].setup({})
      end,
      ["gopls"] = function()
        require("lspconfig").gopls.setup({
          autostart = false,
          settings = {
            gopls = {
              gofumpt = true,
              completeUnimported = true,
              hoverKind = "FullDocumentation"
            }
          }
        })
      end,

    })
  end
}
