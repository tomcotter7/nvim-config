-- Percent-format cells (# %%), as in jupytext-paired notebooks.
local marker = "^# %%"

-- First and last line of the cell around the cursor, marker line included.
local function cell_range()
  local start = math.max(vim.fn.search(marker, "bcnW"), 1)
  local stop = vim.fn.search(marker, "nW")
  return start, stop == 0 and vim.fn.line("$") or stop - 1
end

local function select_cell(around)
  local start, stop = cell_range()
  if not around and vim.fn.getline(start):match("^# %%") then start = start + 1 end
  if start > stop then return end
  -- V toggles visual mode off if we are already in it, so leave it first.
  if vim.fn.mode():match("[vV\22]") then vim.cmd("normal! \27") end
  vim.cmd(("normal! %dGV%dG"):format(start, stop))
end

local opts = { buffer = true }
vim.keymap.set({ "x", "o" }, "ib", function() select_cell(false) end, vim.tbl_extend("force", opts, { desc = "in cell" }))
vim.keymap.set({ "x", "o" }, "ab", function() select_cell(true) end, vim.tbl_extend("force", opts, { desc = "around cell" }))

vim.keymap.set({ "n", "x", "o" }, "]b", function() vim.fn.search(marker, "sW") end,
  vim.tbl_extend("force", opts, { desc = "next cell" }))
vim.keymap.set({ "n", "x", "o" }, "[b", function() vim.fn.search(marker, "sbW") end,
  vim.tbl_extend("force", opts, { desc = "previous cell" }))

vim.keymap.set({ "n", "i" }, "<localleader>cc", function()
  local _, stop = cell_range()
  local new = vim.fn.getline(stop) == "" and { "# %%", "" } or { "", "# %%", "" }
  vim.api.nvim_buf_set_lines(0, stop, stop, false, new)
  vim.api.nvim_win_set_cursor(0, { stop + #new, 0 })
  vim.cmd.stopinsert()
end, vim.tbl_extend("force", opts, { desc = "create new cell" }))

vim.keymap.set("n", "<localleader>rc", "<Plug>SlimeSendCell", vim.tbl_extend("force", opts, { desc = "run cell" }))
