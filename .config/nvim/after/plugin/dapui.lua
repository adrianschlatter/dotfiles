require("dapui").setup()

-- keymaps:
vim.keymap.set('n', '<C-F5>', ':lua require("dapui").open()<CR>')
vim.keymap.set('n', '<S-C-F5>', ':lua require("dapui").close()<CR>')
