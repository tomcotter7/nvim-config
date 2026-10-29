-- Maintained by Claude Code.
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
              "<C-a>f",
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

    -- Open diffs in the background: go back to the tab and window we were in.
    vim.api.nvim_create_autocmd("User", {
      pattern = "ClaudeCodeDiffOpened",
      callback = function(args)
        if not (args.data or {}).tab_number then return end
        local prev_tab = vim.api.nvim_list_tabpages()[vim.fn.tabpagenr("#")]
        vim.schedule(function()
          if prev_tab and vim.api.nvim_tabpage_is_valid(prev_tab) then
            vim.api.nvim_set_current_tabpage(prev_tab)
          end
        end)
      end,
    })

    -- Claude's screen garbles after the terminal is hidden for a diff and shown
    -- again (coder/claudecode.nvim#298). Send Ctrl-L so Claude redraws it.
    vim.api.nvim_create_autocmd("User", {
      pattern = "ClaudeCodeDiffClosed",
      callback = function()
        vim.defer_fn(function()
          local bufnr = require("claudecode.terminal").get_active_terminal_bufnr()
          if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
            pcall(vim.fn.chansend, vim.bo[bufnr].channel, "\12")
          end
        end, 300)
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
    { "<leader>a", nil,                              desc = "AI/Claude Code" },
    {
      "<C-a>c",
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
    {
      "<C-a>f",
      function()
        vim.cmd("ClaudeCodeFocus")
        vim.cmd.startinsert()
      end,
      desc = "Focus Claude + Send Recent Change"
    },
    { "<C-a>r",    "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
    { "<C-a>C",    "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<C-a>b",    "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
    { "<C-a>s",    "<cmd>ClaudeCodeSend<cr>",        mode = "v",                 desc = "Send to Claude" },
    {
      "<C-a>t",
      function()
        -- Save first so Claude reads the comments from disk.
        if vim.bo.modified and vim.bo.buftype == "" then vim.cmd("write") end

        local path = vim.fn.expand("%:.")
        local locations = {}
        for lnum, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
          if line:find("@claude", 1, true) then
            table.insert(locations, path .. ":" .. lnum)
          end
        end

        local prompt
        if #locations > 0 then
          prompt = "I left task(s) for you as @claude comments at: " .. table.concat(locations, ", ")
              .. ". Do each task, then remove its @claude comment."
        else
          prompt = "I left task(s) for you as @claude comments in the code. Search the repo for them, "
              .. "do each task, then remove its @claude comment."
        end

        -- Claude Code treats a burst of input as a paste, so a CR sent with the text
        -- becomes a newline. Send the text, then send the CR on its own a moment later.
        local terminal = require("claudecode.terminal")
        if not terminal.send_to_terminal(prompt, { submit = false }) then return end
        local bufnr = terminal.get_active_terminal_bufnr()
        vim.defer_fn(function()
          if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
            vim.fn.chansend(vim.bo[bufnr].channel, "\r")
            vim.notify("Sent @claude task(s) to Claude")
          end
        end, 200)
      end,
      desc = "Send @claude tasks to Claude"
    },
  },
}
