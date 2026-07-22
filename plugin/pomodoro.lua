local state = {
  timer = nil,
}

local sound_path = vim.fn.stdpath("config") .. "/plugin/pomodoro.mp3"

local pomodoro_popup = function(args)
  vim.fn.jobstart('afplay ' .. sound_path)
  Snacks.notifier.notify("Pomodoro finished!", "info", { style = "fancy", timeout = 10000, title = "Pomodoro" })
end

local reset_pomodoro = function(args)
  if state.timer ~= nil and not (state.timer:is_closing()) then
    state.timer:close()
    state.timer = nil
  end
end

local check_pomodoro = function(args)
  if state.timer == nil then
    print("Pomodoro not started!")
  else
    local seconds_remaining = state.timer:get_due_in() / 1000
    local minutes = math.floor(seconds_remaining / 60)
    local seconds = math.floor((seconds_remaining % 60))

    print(string.format("Time until Pomodoro: %02d:%02d", minutes, seconds))
  end
end

local start_pomodoro = function(args)
  if state.timer ~= nil then
    check_pomodoro()
    return
  end

  local timer = vim.uv.new_timer()
  if timer == nil then
    print("Unable to start timer")
    return
  end


  local ms = tonumber(args.args) * 60 * 1000
  state.timer = timer
  timer:start(ms, 0, vim.schedule_wrap(function()
    pomodoro_popup()
    timer:close()
    state.timer = nil
  end))
end

vim.api.nvim_create_user_command("Pomodoro", start_pomodoro, {
  nargs = "*"
})
vim.api.nvim_create_user_command("PomodoroStatus", check_pomodoro, {})
vim.api.nvim_create_user_command("PomodoroReset", reset_pomodoro, {})

vim.keymap.set("n", "<leader>pd", "<cmd>Pomodoro 25<cr>")
