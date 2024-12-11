coverage = require("coverage")
coverage.setup()

-- keymap:
vim.keymap.set('n', '<leader>cl', ':Coverage<CR>')
vim.keymap.set('n', '<leader>ct', ':CoverageToggle<CR>')
vim.keymap.set('n', '<leader>cs', ':CoverageSummary<CR>')
