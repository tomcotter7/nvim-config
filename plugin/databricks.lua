local sync_job_id = nil

local function start_databricks_sync()
  if sync_job_id then
    vim.notify("Databricks sync is already running", vim.log.levels.WARN)
    return
  end

  sync_job_id = vim.fn.jobstart({ "databricks", "bundle", "sync", "--watch" }, {
    on_stdout = function(_, data)
      if data and data[1] ~= "" then
        vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
      end
    end,
    on_stderr = function(_, data)
      if data and data[1] ~= "" then
        vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
      end
    end,
    on_exit = function(_, exit_code)
      sync_job_id = nil
      if exit_code == 0 then
        vim.notify("Databricks sync stopped", vim.log.levels.INFO)
      else
        vim.notify("Databricks sync exited with code: " .. exit_code, vim.log.levels.ERROR)
      end
    end,
  })

  if sync_job_id > 0 then
    vim.notify("Databricks sync started", vim.log.levels.INFO)
  else
    sync_job_id = nil
    vim.notify("Failed to start Databricks sync", vim.log.levels.ERROR)
  end
end

local function stop_databricks_sync()
  if not sync_job_id then
    vim.notify("No Databricks sync is running", vim.log.levels.WARN)
    return
  end

  vim.fn.jobstop(sync_job_id)
  sync_job_id = nil
  vim.notify("Databricks sync stopped", vim.log.levels.INFO)
end

local function databricks_one_time_sync()
  vim.notify("Starting one-time Databricks sync...", vim.log.levels.INFO)

  vim.fn.jobstart({ "databricks", "bundle", "sync" }, {
    on_stdout = function(_, data)
      if data and data[1] ~= "" then
        vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
      end
    end,
    on_stderr = function(_, data)
      if data and data[1] ~= "" then
        vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.notify("Databricks one-time sync completed", vim.log.levels.INFO)
      else
        vim.notify("Databricks one-time sync failed with code: " .. exit_code, vim.log.levels.ERROR)
      end
    end,
  })
end

vim.api.nvim_create_user_command("DBStartSync", function()
  start_databricks_sync()
end, { desc = "Start Databricks Sync (Always On)" })

vim.api.nvim_create_user_command("DBStopSync", function()
  stop_databricks_sync()
end, { desc = "Stop Databricks Sync" })

vim.api.nvim_create_user_command("DBOneTimeSync", function()
  databricks_one_time_sync()
end, { desc = "Sync to Databricks One Time" })

-- Stop sync when exiting Neovim
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if sync_job_id then
      vim.fn.jobstop(sync_job_id)
    end
  end,
  desc = "Stop Databricks sync on Neovim exit",
})
