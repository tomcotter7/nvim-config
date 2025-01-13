local state = {
  time_remaining = nil
}

local start_pomodoro = function(args)
  local timer = vim.uv.new_timer()
  local ms = tonumber(args.args) * 60 * 1000
  state.time_remaining = (ms / 1000) / 60
  timer:start(60000, 60000, vim.schedule_wrap(function()
    state.time_remaining = state.time_remaining - 1
    if state.time_remaining <= 0 then
      timer:close()
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
      state.time_remaining = nil
    end
  end))
end

vim.api.nvim_create_user_command("Pomodoro", start_pomodoro, {
  nargs = "*"
})

local check_pomodoro = function(args)
  print(string.format("Pomodoro: %s", state.time_remaining))
end

vim.api.nvim_create_user_command("PomodoroStatus", check_pomodoro, {})
vim.keymap.set("n", "<leader>pd", "<cmd>Pomodoro 55<cr>")
