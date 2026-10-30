return {
  "GCBallesteros/jupytext.nvim",
  opts = {
    style = "markdown",
    output_extension = "md",
    force_ft = "markdown"
  },
  config = function(_, opts)
    require("jupytext").setup(opts)

    -- Paired .py: push each save to its .ipynb. Only files with jupytext's header are paired.
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = "*.py",
      callback = function(ev)
        local head = table.concat(vim.api.nvim_buf_get_lines(ev.buf, 0, 20, false), "\n")
        if not head:find("jupytext:", 1, true) then return end
        -- pcall: vim.system throws if jupytext is missing.
        pcall(vim.system, { "jupytext", "--sync", ev.file }, { text = true }, function(res)
          if res.code ~= 0 then
            vim.schedule(function() vim.notify("Jupytext sync failed: " .. res.stderr, vim.log.levels.ERROR) end)
          end
        end)
      end,
    })
  end,
}
