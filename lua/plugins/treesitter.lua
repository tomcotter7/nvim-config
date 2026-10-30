return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install({
      "python", "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "markdown", "markdown_inline",
      "bash", "css", "csv", "diff", "dockerfile", "editorconfig", "git_config", "gitcommit", "gitignore",
      "go", "gomod", "gosum", "groovy", "htmldjango", "ini", "java", "jinja", "json", "kotlin", "latex",
      "make", "properties", "requirements", "scala", "sql", "ssh_config", "swift", "terraform", "tmux",
      "toml", "tsv", "xml", "yaml",
    })

    local max_filesize = 100 * 1024 -- 100 KB
    local no_indent = { groovy = true }

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
        if ok and stats and stats.size > max_filesize then
          return
        end

        -- Fails when no parser is installed for this filetype
        if not pcall(vim.treesitter.start, args.buf) then
          return
        end

        if not no_indent[vim.bo[args.buf].filetype] then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end
}

