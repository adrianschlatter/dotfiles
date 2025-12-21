local builtin = require('telescope.builtin')
local wk = require("which-key")

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fr', builtin.git_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fm', builtin.man_pages, {})
vim.keymap.set('n', '<leader>fo', vim.diagnostic.open_float, {})

wk.add({
    { '<leader>f', group = 'find' },
    { '<leader>ff', desc = 'find files' },
    { '<leader>fr', desc = 'git files' },
    { '<leader>fg', desc = 'live grep' },
    { '<leader>fb', desc = 'buffers' },
    { '<leader>fh', desc = 'help tags' },
    { '<leader>fd', desc = 'diagnostics' },
    { '<leader>fm', desc = 'man pages' },
    { '<leader>fo', desc = 'diagnostic, open float' },
})
