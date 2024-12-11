require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
require('dap-python').test_runner = 'pytest'

-- debug/test/method:
vim.keymap.set('n', '<leader>dtm', ':lua require("dap-python").test_method()<CR>')
-- debug/test/class:
vim.keymap.set('n', '<leader>dtc', ':lua require("dap-python").test_class()<CR>')


