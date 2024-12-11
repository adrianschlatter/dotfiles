vim.cmd('colorscheme catppuccin')

require("catppuccin").setup({
    integrations = {
        harpoon = true,
        treesitter = true,
        mason = true,
        dap = true,
        dap_ui = true,
        cmp = true,
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
            },
            underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
            },
            inlay_hints = {
                background = true,
            },
        },
        telescope = {
            enabled = true,
        }
    }
})
