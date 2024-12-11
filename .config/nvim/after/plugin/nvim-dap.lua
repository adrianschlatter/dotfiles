-- keymaps:
vim.keymap.set('n', '<leader>db', vim.cmd.DapToggleBreakpoint)
vim.keymap.set('n', '<leader>dB',
    ':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>')
vim.keymap.set('n', '<leader>dc', vim.cmd.DapContinue)
vim.keymap.set('n', '<leader>ds', vim.cmd.DapStepOver)
vim.keymap.set('n', '<leader>di', vim.cmd.DapStepInto)
vim.keymap.set('n', '<leader>do', vim.cmd.DapStepOut)
vim.keymap.set('n', '<leader>dr', vim.cmd.DapToggleRepl)
vim.keymap.set('n', '<leader>dx', vim.cmd.DapTerminate)

-- icons for gutter:
-- first, define highlight groups:
vim.api.nvim_set_hl(0, 'DapBreakPointSign', { fg='#ff0000', bg='#31353f' })
vim.api.nvim_set_hl(0, 'DapBreakPointLine', { bg='#31353f' })
vim.api.nvim_set_hl(0, 'DapLogPointSign', { fg='#61afef', bg='#31353f' })
vim.api.nvim_set_hl(0, 'DapLogPointLine', { bg='#31353f' })
vim.api.nvim_set_hl(0, 'DapStoppedSign', { fg='#98c379', bg='#31353f' })
vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg='#31353f' })

-- then, define the signs, and use highlight groups to color the icons
-- as well as the line and the line number:
vim.fn.sign_define('DapBreakpoint',
    { text='', texthl='DapBreakpointSign', linehl='DapBreakpointLine',
      numhl='DapBreakpointLine' })
vim.fn.sign_define('DapBreakpointCondition',
    { text='ﳁ', texthl='DapBreakpointSign', linehl='DapBreakpointLine',
      numhl='DapBreakpointLine' })
vim.fn.sign_define('DapBreakpointRejected',
    { text='', texthl='DapBreakpointSign', linehl='DapBreakpointLine',
      numhl='DapBreakpointLine' })
vim.fn.sign_define('DapLogPoint',
    { text='', texthl='DapLogPointSign', linehl='DapLogPointLine',
      numhl='DapLogPointLine' })
vim.fn.sign_define('DapStopped',
    { text='', texthl='DapStoppedSign', linehl='DapStoppedLine',
      numhl='DapStoppedLine' })
