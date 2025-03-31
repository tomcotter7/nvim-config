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
    require('lspconfig').mojo.setup {}
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end
        if client.supports_method('textDocument/formatting') then
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = args.buf,
            callback = function()
              vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
            end,
          })
        end
      end,
    })
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, {
        border = "rounded",
        title = "documentation",
        width = 60,
        max_height = 20
      }
    )
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end)
    vim.keymap.set("n", "grr", function() vim.lsp.buf.references() end)
    vim.keymap.set("n", "grn", function() vim.lsp.buf.rename() end)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end)

    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      pattern = { "*.tf", "*.tfvars" },
      callback = function()
        vim.lsp.buf.format()
      end,
    })
  end,
}
