local wk = require("which-key")

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
wk.add({
    { '<leader>u', desc = 'toggle undotree' },
})
