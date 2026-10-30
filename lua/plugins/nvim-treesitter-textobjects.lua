return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  init = function()
    -- Disable entire built-in ftplugin mappings to avoid conflicts.
    -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
    vim.g.no_plugin_maps = true

    -- Or, disable per filetype (add as you like)
    -- vim.g.no_python_maps = true
    -- vim.g.no_ruby_maps = true
    -- vim.g.no_rust_maps = true
    -- vim.g.no_go_maps = true
  end,
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true, -- jump forward to the next function if the cursor isn't in one
      },
    })

    local select = require("nvim-treesitter-textobjects.select")
    local map = function(keys, query, desc)
      vim.keymap.set({ "x", "o" }, keys, function()
        select.select_textobject(query, "textobjects")
      end, { desc = desc })
    end

    map("af", "@function.outer")
    map("if", "@function.inner")
    map("ac", "@class.outer")
    map("ic", "@class.inner")
  end,
}