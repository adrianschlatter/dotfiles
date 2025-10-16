-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = {buffer = event.buf}

        -- Note: commented out keymaps are defined by default in nvim

        -- vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set('n', 'grd', function() vim.lsp.buf.definition() end,
                       opts)
        vim.keymap.set('n', 'grD', function() vim.lsp.buf.declaration() end,
                       opts)
        -- vim.keymap.set('n', 'gri', function() vim.lsp.buf.implementation() end,
        --                opts)
        -- vim.keymap.set('n', 'grt',function() vim.lsp.buf.type_definition() end,
        --                opts)
        -- vim.keymap.set('n', 'grr', function() vim.lsp.buf.references() end,
        --                opts)
        vim.keymap.set('n', 'grs', function() vim.lsp.buf.signature_help() end,
                       opts)
        -- vim.keymap.set('n', 'gra', function() vim.lsp.buf.code_action() end,
        --                opts)
        -- vim.keymap.set('n', 'grn', function() vim.lsp.buf.rename() end,
        --                opts)
        vim.keymap.set({'n', 'x'}, '<F3>',
                       function() vim.lsp.buf.format({async = true}) end, opts)
        vim.keymap.set('n', '<F4>', function() vim.lsp.buf.code_action() end,
                       opts)
    end,
})

-- add help texts to which-key:
-- *don't* put this inside the autocmd above, otherwise it will execute for
-- every lsp attaching to a buffer and create :checkhealth issues:
local wk = require("which-key")
wk.add({
    { 'K',    desc = 'hover' },
    { 'gr',   group = '"goto" LSP' },
    { 'grd',  desc = 'goto definition' },
    { 'grD',  desc = 'goto declaration' },
    { 'gri',  desc = 'goto implementation' },
    { 'grt',  desc = 'goto type definition' },
    { 'grr',  desc = 'goto references' },
    { 'gra',  desc = 'code action' },
    { 'grs',  desc = 'signature help' },
    { 'grn',  desc = 'rename symbol' },
    { '<F3>', desc = 'format buffer' },
    { '<F4>', desc = 'code action' },
})

-- setup lsp-signature:
require('lsp_signature').setup()
