return {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
        local cmp = require('cmp')
        cmp.setup({
            sources = {
                    {name = 'nvim_lsp'}
            },
            window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-y>'] = cmp.mapping.confirm({select = true}),
                    ['<C-Space>'] = cmp.mapping.complete(),
            })
        })
    end
}
