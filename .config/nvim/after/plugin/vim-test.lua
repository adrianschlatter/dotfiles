local wk = require("which-key")

-- test/method:
vim.keymap.set('n', '<leader>tm', vim.cmd.TestNearest)
-- test/class:
vim.keymap.set('n', '<leader>tf', vim.cmd.TestFile)
-- test/suide:
vim.keymap.set('n', '<leader>tt', vim.cmd.TestSuite)
-- test/last:
vim.keymap.set('n', '<leader>tl', vim.cmd.TestLast)

wk.add({
    { '<leader>t', group = 'test' },
    { '<leader>tm', desc = 'test method' },
    { '<leader>tf', desc = 'test file' },
    { '<leader>tt', desc = 'test suite' },
    { '<leader>tl', desc = 'test last' },
})
