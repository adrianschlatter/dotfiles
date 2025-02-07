local cmp = require('cmp')

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
    },
    formatting = {  -- show source of each completion
        format = function(entry, vim_item)
            vim_item.menu = entry.source.name
            return vim_item
        end,
    },
    window = {     -- bordered completion windows
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
})


cmp.setup.filetype({ 'sql' }, {
    sources = {
        { name = 'vim-dadbod-completion' },
    }
})

-- Set up lspconfig:
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['pylsp'].setup {
    capabilities = capabilities
}
