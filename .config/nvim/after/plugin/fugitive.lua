local wk = require("which-key")

vim.keymap.set('n', '<leader>gs', vim.cmd.Git);
wk.add({
    { '<leader>g', group = 'git' },
    { '<leader>gs', desc = 'git status' },
})
