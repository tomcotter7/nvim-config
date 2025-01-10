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
      ensure_installed = { 'lua_ls', 'ruff', 'pyright', 'ts_ls', 'terraformls', 'texlab', 'groovyls' }
    })
    local lspconfig = require('lspconfig')
    lspconfig.ts_ls.setup({})
    lspconfig.pyright.setup({})
    lspconfig.ruff.setup({})
    lspconfig.lua_ls.setup({})
    lspconfig.terraformls.setup({})
    lspconfig.texlab.setup({})
    lspconfig.groovyls.setup({})
  end
}
