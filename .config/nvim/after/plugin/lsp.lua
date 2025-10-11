-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = {buffer = event.buf}
        local wk = require("which-key")

        vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end,
                       opts)
        vim.keymap.set('n', 'gD', function() vim.lsp.buf.declaration() end,
                       opts)
        vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end,
                       opts)
        vim.keymap.set('n', 'go',function() vim.lsp.buf.type_definition() end,
                       opts)
        vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end,
                       opts)
        vim.keymap.set('n', 'gs', function() vim.lsp.buf.signature_help() end,
                       opts)
        vim.keymap.set('n', '<leader>r', function() vim.lsp.buf.rename() end,
                       opts)
        vim.keymap.set({'n', 'x'}, '<F3>',
                       function() vim.lsp.buf.format({async = true}) end, opts)
        vim.keymap.set('n', '<F4>', function() vim.lsp.buf.code_action() end,
                       opts)
        -- add help texts to which-key:
        wk.add({
            { 'K', desc = 'hover' },
            { 'gd', desc = 'goto definition' },
            { 'gD', desc = 'goto declaration' },
            { 'gi', desc = 'goto implementation' },
            { 'go', desc = 'goto type definition' },
            { 'gr', desc = 'goto references' },
            { 'gs', desc = 'signature help' },
            { '<leader>r', desc = 'rename' },
            { '<F3>', desc = 'format buffer' },
            { '<F4>', desc = 'code action' },
        })
    end,
})

-- setup lsp-signature:
require('lsp_signature').setup()
