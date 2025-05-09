return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
  },
  config = function()
    require('lspconfig').mojo.setup({})
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method('textDocument/formatting') then
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = args.buf,
            callback = function()
              vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
            end,
          })
        end
      end,
    })

    vim.lsp.config("lua_ls", {})
    vim.lsp.config("ruff", {})
    vim.lsp.config("pyright", {})
    vim.lsp.config("ts_ls", {})
    vim.lsp.config("gopls",
      { settings = { gopls = { gofumpt = true, completeUnimported = true, hoverKind = "FullDocumentation" } } })

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end)
    vim.keymap.set("n", "grr", function() vim.lsp.buf.references() end)
    vim.keymap.set("n", "grn", function() vim.lsp.buf.rename() end)
    vim.keymap.set("n", "K",
      function() vim.lsp.buf.hover({ border = "rounded", width = 60, max_height = 20 }) end)

    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      pattern = { "*.tf", "*.tfvars" },
      callback = function()
        vim.lsp.buf.format()
      end,
    })

    vim.diagnostic.config({
      float = {
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
      },
      virtual_text = true,
      severity_sort = false
    })
    vim.keymap.set('n', 'ge', vim.diagnostic.open_float)
  end,
}
