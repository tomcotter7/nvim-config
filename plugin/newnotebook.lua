local default_notebook = [[
  {
    "cells": [
     {
      "cell_type": "markdown",
      "metadata": {},
      "source": [
        ""
      ]
     }
    ],
    "metadata": {
     "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      "name": "python3"
     },
     "language_info": {
      "codemirror_mode": {
        "name": "ipython"
      },
      "file_extension": ".py",
      "mimetype": "text/x-python",
      "name": "python",
      "nbconvert_exporter": "python",
      "pygments_lexer": "ipython3"
     }
    },
    "nbformat": 4,
    "nbformat_minor": 5
  }
]]

local function new_notebook(filename)
  local path = filename .. ".ipynb"
  if vim.uv.fs_stat(path) then
    vim.notify(path .. " already exists", vim.log.levels.ERROR)
    return
  end
  local file = io.open(path, "w")
  if file then
    file:write(default_notebook)
    file:close()
    -- Pair with a percent-format .py and edit that: saving the .ipynb through jupytext.nvim drops the pairing.
    local ok, job = pcall(vim.system, { "jupytext", "--set-formats", "ipynb,py:percent", path })
    if ok and job:wait().code == 0 then
      vim.cmd.edit(filename .. ".py")
    else
      vim.notify("Could not pair " .. path .. " with jupytext", vim.log.levels.WARN)
      vim.cmd.edit(path)
    end
  else
    print("Error: Could not open new notebook file for writing.")
  end
end

vim.api.nvim_create_user_command('NewNotebook', function(opts)
  new_notebook(opts.args)
end, {
  nargs = 1,
  complete = 'file'
})
