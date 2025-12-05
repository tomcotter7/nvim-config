local state = {
  databricks = {
    path = "",
    profile = "",
  }
}


local function push_to_databricks()
  if state.databricks.path == "" then
    return
  end

  local local_file = vim.fn.expand("%:p")
  local remote_path = state.databricks.path

  local on_upload = function(obj)
    if obj.code == 0 then
      vim.schedule(function()
        vim.notify("Push to Databricks: " .. remote_path, vim.log.levels.INFO)
      end)
    else
      vim.schedule(function()
        vim.notify("Failed to push to Databricks: " .. obj.stderr, vim.log.levels.ERROR)
      end
      )
    end
  end

  local shell = os.getenv("SHELL") or "/bin/zsh"

  local cmd = table.concat({
    "databricks",
    "workspace",
    "import",
    vim.fn.shellescape(remote_path),
    "--file", vim.fn.shellescape(local_file),
    "--overwrite",
    "--format", "JUPYTER",
    "--profile", vim.fn.shellescape(state.databricks.profile),
  }, " ")

  vim.system(
    { shell, "-lc", cmd },
    { text = true },
    on_upload
  )
end

local function set_databricks_path(path)
  state.databricks.path = path
end

local function set_databricks_profile(profile)
  state.databricks.profile = profile
end

vim.api.nvim_create_user_command("DatabricksSetProfile", function(opts)
  set_databricks_profile(opts.args)
end, { nargs = 1, desc = "Set Databricks Workspace Profile" })

vim.api.nvim_create_user_command("DatabricksClearProfile", function()
  set_databricks_profile("")
end, { desc = "Clear Databricks Workspace Profile" })

vim.api.nvim_create_user_command("DatabricksSetPath", function(opts)
  set_databricks_path(opts.args)
end, { nargs = 1, desc = "Set Databricks Workspace Path" })

vim.api.nvim_create_user_command("DatabricksClearPath", function()
  set_databricks_path("")
end, { desc = "Clear Databricks Workspace Path" })

vim.api.nvim_create_user_command("DatabricksPush", function()
  push_to_databricks()
end, { desc = "Manual Push To Databricks" })

vim.api.nvim_create_user_command("DatabricksShowPath", function()
  if state.databricks.path ~= "" then
    vim.notify("Databricks path: " .. state.databricks.path, vim.log.levels.INFO, {})
  else
    vim.notify("Databricks path not set", vim.log.levels.INFO)
  end
end, {})


vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.ipynb" },
  callback = push_to_databricks
})
