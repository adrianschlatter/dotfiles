local cmp = require('cmp')

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        -- confirm completion
        ['<C-e>'] = cmp.mapping.confirm({select = true}),
    }),
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
    }
})


cmp.setup.filetype({ 'sql' }, {
    sources = {
        { name = 'vim-dadbod-completion' },
    }
})
