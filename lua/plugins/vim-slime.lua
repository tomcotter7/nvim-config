return {
  "jpalardy/vim-slime",
  init = function()
    vim.g.slime_target = "tmux"
    vim.g.slime_default_config = { socket_name = "default", target_pane = ":.1" }
    vim.g.slime_dont_ask_default = 1
    vim.g.slime_bracketed_paste = 1
  end,
  config = function()
    vim.keymap.set("v", "<localleader>r", "<Plug>SlimeRegionSend", { desc = "Send selection to REPL" })

    vim.api.nvim_create_user_command("ReplOpen", function()
      vim.fn.system("tmux split-window -h -p 25")
    end, {})

    vim.api.nvim_create_user_command("ReplClose", function()
      vim.fn.system("tmux kill-pane -t :.1")
    end, {})

    vim.keymap.set("n", "<localleader>ro", "<cmd>ReplOpen<cr>", { desc = "REPL (O)pen" })
    vim.keymap.set("n", "<localleader>rq", "<cmd>ReplClose<cr>", { desc = "REPL (Q)uit" })
  end,
}
