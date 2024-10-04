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
    {"preservim/nerdtree"},
    {"mbbill/undotree"},
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
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    }
})

vim.api.nvim_create_autocmd({"VimEnter"}, {
        command = "AirlineTheme molokai",
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile", "BufEnter"}, {
        pattern = "*.mojo",
        callback = function ()
            vim.api.nvim_buf_set_option(
                vim.api.nvim_get_current_buf(),
                "filetype",
                "mojo"
            )
        end
})
