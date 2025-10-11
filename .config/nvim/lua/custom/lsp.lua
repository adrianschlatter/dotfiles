-- I want these LSP servers:
local lsp_servers = {
    'zuban',        -- python
    'lua_ls',       -- lua
    'marksman',     -- markdown
    'esbonio',      -- rst
    'texlab',       -- latex
    'awk_ls',       -- awk
}

-- Use mason.nvim to install them.
-- It will put them somewhere in ~/.local/share/nvim/mason/ and add there
-- binaries to PATH (at least inside nvim).
-- The following line also creates the `:Mason` command. Use it to install the
-- LSP servers interactively. They will not be installed automatically.
require('mason').setup({})

-- Next, we need to configure the LSP servers. However, I already did this by
-- installing the plugin nvim-lspconfig (see `packer.lua`, which automatically
-- configures many LSP servers => don't need to do anything here.

-- Tell vim.lsp to enable these LSP servers (not *all* that have been
-- configured by nvim-lspconfig):
vim.lsp.enable(lsp_servers)
