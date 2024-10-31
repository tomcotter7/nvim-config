require("tcotts.set")
require("tcotts.remap")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
                "git",
                "clone",
                "--filter=blob:none",
                "https://github.com/folke/lazy.nvim",
                lazypath,
        })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { "nvim-lua/plenary.nvim" },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    {"rose-pine/neovim"},
    {"github/copilot.vim"},
    {
        "folke/zen-mode.nvim",
        opts = {
            window = {
                width = 0.8,
                height = 1.0,
            },
            plugins = {
                options = {
                    laststatus = 3,
                }
            }
        }
        },
    {"nvim-treesitter/nvim-treesitter"},
    {"nvim-treesitter/nvim-treesitter-context"},
    {"nvim-treesitter/playground"},
    {'vim-airline/vim-airline'},
    {'vim-airline/vim-airline-themes'},
    {
        'ThePrimeagen/harpoon',
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-treesitter/nvim-treesitter",
        },
        config = function()
          require("refactoring").setup()
        end,
    },
    -- {"preservim/nerdtree"},
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup({
                filters = {
                    dotfiles = true,
                },
            })
        end,
    },
    {
        "mbbill/undotree",
        lazy = true
    },
    {"tpope/vim-fugitive"},
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},
    {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp'},
    {'L3MON4D3/LuaSnip'},
    {
        "iamcco/markdown-preview.nvim",
        lazy = true,
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    -- {
    --     'huggingface/llm.nvim',
    --     config = function()
    --         require('llm').setup({
    --             api_token = "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",
    --             model = "bigcode/starcoder2-15b",
    --             backend = "huggingface",
    --             url = nil,
    --             tokens_to_clear = { "<|endoftext|>" },
    --             request_body = {
    --                 parameters = {
    --                     max_new_tokens = 60,
    --                     temperature = 0.2,
    --                     top_p = 0.95,
    --                 },
    --             },
    --             fim = {
    --                 enabled = true,
    --                 prefix = "<fim_prefix>",
    --                 middle = "<fim_middle>",
    --                 suffix = "<fim_suffix>",
    --             },
    --             debounce_ms = 150,
    --             accept_keymap = "<C-j>",
    --             dismiss_keymap = "<C-k>",
    --             tls_skip_verify_insecure = false,
    --             lsp = {
    --                 bin_path = nil,
    --                 host = nil,
    --                 port = nil,
    --                 cmd_env = nil,
    --                 version = "0.5.3",
    --             },
    --             tokenizer = { repository = "bigcode/starcoder2-15b" },
    --             context_window = 1024,
    --             enable_suggestions_on_startup = true,
    --             enable_suggestions_on_files = "*",
    --             disable_url_path_completion = false,
    --         })
    --     end
    -- },
})

vim.api.nvim_create_autocmd({"VimEnter"}, {
        command = "AirlineTheme molokai",
})
