require("rose-pine").setup({
    variant = "moon",
    dim_inactive_windows = true,

    groups = {
        border = "muted",
        link = "iris",
        panel = "surface",
        error = "love",
        hint = "iris",
        info = "foam",
        note = "pine",
        todo = "rose",
        warn = "gold"
    },
})

vim.cmd("colorscheme rose-pine-moon")
