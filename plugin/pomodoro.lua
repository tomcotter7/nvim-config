local state = {
  timer = nil,
}

local sound_path = vim.fn.stdpath("config") .. "/plugin/pomodoro.mp3"

local pomodoro_popup = function(args)
  local height = math.floor(vim.o.lines * 0.25)
  local width = math.floor(vim.o.columns * 0.25)
  local buf = vim.api.nvim_create_buf(false, true)
  local ascii_art = {
    "╔═══════════════╗",
    "║   Pomodoro!   ║",
    "╚═══════════════╝",
  }
  local v_padding = math.floor((height - #ascii_art) / 2)
  local h_padding = string.rep(" ", math.floor((width - vim.fn.strdisplaywidth(ascii_art[2])) / 2))
  local lines = {}
  for _ = 1, v_padding do
    table.insert(lines, "")
  end
  for _, line in ipairs(ascii_art) do
    table.insert(lines, h_padding .. line)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded"
  }
  vim.api.nvim_open_win(buf, true, win_config)
  vim.fn.jobstart('paplay ' .. sound_path)
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

vim.keymap.set("n", "<leader>pd", "<cmd>Pomodoro 55<cr>")
