return {
  "benlubas/molten-nvim",
  version = "^1.0.0",
  build = ":UpdateRemotePlugins",
  init = function()
    vim.g.molten_output_win_max_height = 20
    vim.g.molten_auto_open_output = false
    vim.g.molten_wrap_output = true
    vim.g.molten_virt_text_output = false
    vim.g.molten_virt_lines_off_by_1 = true
  end,
  config = function()
    vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>",
      { silent = true, desc = "(M)olten (I)nitialize" })
    -- vim.keymap.set("n", "<localleader>el", ":MoltenEvaluateLine<CR>",
    --   { silent = true, desc = "Molten (E)valuate (L)ine" })
    -- vim.keymap.set("n", "<localleader>rc", ":MoltenReevaluateCell<CR>",
    --   { silent = true, desc = "Molten (R)-evaluate (C)ell" })
    vim.keymap.set("v", "<localleader>ev", ":<C-u>MoltenEvaluateVisual<CR>gv<Esc>",
      { silent = true, desc = "Molten (E)valute (V)isual" })
    vim.keymap.set("n", "<localleader>so", ":noautocmd MoltenEnterOutput<CR>",
      { silent = true, desc = "Molten Enter (O)utput or (S)how Output" })
    vim.keymap.set("n", "<localleader>ho", ":MoltenHideOutput<CR>",
      { silent = true, desc = "Molten (H)ide (O)utput" })
    vim.keymap.set("n", "<localleader>nc", "<cmd>MoltenNext<cr>")
    vim.keymap.set("n", "<localleader>pc", "<cmd>MoltenPrev<cr>")
    vim.keymap.set("n", "<localleader>ec", "<Esc><cmd>call search('^```$')<CR>zzk")
    vim.keymap.set({ "n", "i" }, "<localleader>cc",
      "<Esc><cmd>call search('^```$')<CR>o<CR>```python<CR>```<Esc>0i<CR><Esc>k")

    vim.api.nvim_set_hl(0, "MoltenCell", { bold = true })

    local imb = function(e)
      vim.schedule(function()
        local kernels = vim.fn.MoltenAvailableKernels()
        local try_kernel_name = function()
          local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
          return metadata.kernelspec.name
        end
        local ok, kernel_name = pcall(try_kernel_name)
        if not ok or not vim.tbl_contains(kernels, kernel_name) then
          kernel_name = nil
          local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
          if venv ~= nil then
            kernel_name = string.match(venv, "/.+/(.+)")
          end
        end
        if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
          vim.cmd(("MoltenInit %s"):format(kernel_name))
        end
        vim.cmd("MoltenImportOutput")
      end)
    end

    vim.api.nvim_create_autocmd("BufAdd", {
      pattern = { "*.ipynb" },
      callback = imb,
    })

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = { "*.ipynb" },
      callback = function(e)
        if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
          imb(e)
        end
      end,
    })
  end
}
