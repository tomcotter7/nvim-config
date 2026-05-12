return {
  "GCBallesteros/jupytext.nvim",
  opts = {
    style = "markdown",
    output_extension = "md",
    force_ft = "markdown"
  },
  -- opts = {
  --   style = "percent",
  --   output_extension = "py",
  -- }
  config = function(_, opts)
    require("jupytext").setup(opts)

    vim.api.nvim_create_user_command("JupytextSync", function()
      local ipynb = vim.fn.expand("%:p")
      if not ipynb:match("%.ipynb$") then
        vim.notify("Not an .ipynb buffer", vim.log.levels.WARN)
        return
      end
      vim.fn.jobstart({ "jupytext", "--sync", ipynb }, {
        on_exit = function(_, code)
          vim.schedule(function()
            if code == 0 then
              vim.cmd("edit")
              vim.notify("Jupytext synced")
            else
              vim.notify("Jupytext sync failed", vim.log.levels.ERROR)
            end
          end)
        end,
      })
    end, {})
  end,
}
