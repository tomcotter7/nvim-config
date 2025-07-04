vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>")

local state = {
  floating = {
    buf = -1,
    win = -1,
  }
}

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  end

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    title = "fterm",
    title_pos = "center",
    footer = "<Space>tf to close",
    footer_pos = "left",
    border = "rounded",
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window({ buf = state.floating.buf })
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

local function exit_handler()
  if vim.api.nvim_buf_is_valid(state.floating.buf) and
      vim.bo[state.floating.buf].buftype == "terminal" then
    vim.api.nvim_buf_delete(state.floating.buf, { force = true })
    state.floating.buf = -1
  end
end

vim.api.nvim_create_autocmd("ExitPre", {
  callback = exit_handler,
  desc = "Clean up floating terminal on nvim exit"
})


vim.api.nvim_create_user_command("FTerm", toggle_terminal, {})
vim.keymap.set({ "n" }, "<leader>tf", toggle_terminal)
