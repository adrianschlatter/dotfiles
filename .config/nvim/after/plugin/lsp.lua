local lsp = require('lsp-zero')

-- fix undefined global 'vim' error:
-- (thanks to the Primeagen)
lsp.configure('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
            },
        },
    },
})

lsp.on_attach(function(client, bufnr)
    local opts = {buffer = bufnr, remap = false}

	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp.default_keymaps({buffer = bufnr})
    -- set keymap for symbol renaming:
    vim.keymap.set('n', '<leader>r', function() vim.lsp.buf.rename() end, opts)
end)

lsp.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = '»'
})

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {'pylsp', 'lua_ls'},
    handlers = {
        require('lsp-zero').default_setup,
    },
})

-- add a border around :LspInfo window:
require('lspconfig.ui.windows').default_options = {
  border = "single",
}

lsp.setup()
