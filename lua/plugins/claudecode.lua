return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = function()
    require("claudecode").setup({
      terminal = {
        provider = "snacks",
        split_width_percentage = 0.25,
        auto_insert = false,
        snacks_win_opts = {
          keys = {
            nav_left     = {
              "<C-w>h",
              function() vim.cmd("wincmd h") end,
              mode = "t",
              desc = "Go left"
            },
            nav_previous = {
              "<C-w>p",
              function() vim.cmd("wincmd p") end,
              mode = "t",
              desc = "Go to previous window"
            },
            hide         = {
              "<C-,>",
              function(self) self:hide() end,
              mode = "t",
              desc = "Hide"
            },
          },
        },
      },
      diff_opts = {
        open_in_new_tab = true,
        auto_resize_terminal = false,
        hide_terminal_in_new_tab = true,
      },
    })

    -- Work around claudecode.nvim capturing the wrong window's cursor pos when
    -- open_in_new_tab = true (it grabs {1,0} from the freshly-created diff
    -- window in the new tab, not our real position in the original tab).
    -- Track it ourselves via the plugin's diff lifecycle events instead.
    local pending_cursor = {}

    vim.api.nvim_create_autocmd("User", {
      pattern = "ClaudeCodeDiffOpened",
      callback = function(args)
        local data = args.data or {}
        local file_path = data.file_path
        if not file_path then return end

        local diff_tab = data.tab_number
        for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
          if tab ~= diff_tab then
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.api.nvim_buf_get_name(buf) == file_path then
                pending_cursor[file_path] = { win = win, pos = vim.api.nvim_win_get_cursor(win) }
              end
            end
          end
        end
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "ClaudeCodeDiffClosed",
      callback = function(args)
        local data = args.data or {}
        local file_path = data.file_path
        if not file_path then return end

        local saved = pending_cursor[file_path]
        pending_cursor[file_path] = nil
        if not saved then return end

        -- Defer past the plugin's own tab-switch / buffer-reload cleanup.
        vim.defer_fn(function()
          if vim.api.nvim_win_is_valid(saved.win) then
            pcall(vim.api.nvim_win_set_cursor, saved.win, saved.pos)
          end
        end, 150)
      end,
    })
  end,
  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeSelectModel",
    "ClaudeCodeAdd",
    "ClaudeCodeSend",
    "ClaudeCodeTreeAdd",
    "ClaudeCodeStatus",
    "ClaudeCodeStart",
    "ClaudeCodeStop",
    "ClaudeCodeOpen",
    "ClaudeCodeClose",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
    "ClaudeCodeCloseAllDiffs",
  },
  keys = {
    { "<leader>a",  nil,                              desc = "AI/Claude Code" },
    {
      "<leader>ac",
      function()
        local win = vim.api.nvim_get_current_win()
        local is_file = vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) ~= ""
        vim.cmd("ClaudeCode")
        if is_file then
          vim.defer_fn(function()
            if vim.api.nvim_win_is_valid(win) then
              vim.api.nvim_win_call(win, function()
                require("claudecode.selection").update_selection()
              end)
            end
          end, 1500)
        end
        vim.defer_fn(function()
          if vim.bo.buftype == "terminal" then
            vim.cmd.startinsert()
          end
        end, 0)
      end,
      desc = "Toggle Claude + set current file context"
    },
    -- { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
    {
      "<leader>af",
      function()
        -- snapshot current state with `git stash create`
        -- does a previous state exist? if so, run git diff <prev> <current>
        -- send this diff to claude, with some text.
        -- Can we send it directly to the prompt, without filling up the text box?
        vim.cmd("ClaudeCodeFocus")
        vim.cmd.startinsert()
      end,
      desc = "Focus Claude + Send Recent Change"
    },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                  desc = "Send to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
    },
    -- Diff management
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
  },
}
