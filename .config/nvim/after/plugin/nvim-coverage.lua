local coverage = require("coverage")
local wk = require("which-key")
coverage.setup()

-- keymap:
vim.keymap.set('n', '<leader>cl', ':Coverage<CR>')
vim.keymap.set('n', '<leader>ct', ':CoverageToggle<CR>')
vim.keymap.set('n', '<leader>cs', ':CoverageSummary<CR>')

wk.add({
    { '<leader>c', group = 'coverage' },
    { '<leader>cl', desc = 'coverage load' },
    { '<leader>ct', desc = 'coverage toggle' },
    { '<leader>cs', desc = 'coverage summary' },
})
