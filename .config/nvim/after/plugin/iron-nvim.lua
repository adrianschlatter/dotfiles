local iron = require("iron.core")
local view = require("iron.view")
local wk = require("which-key")

iron.setup {
    config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
            sh = {
                -- Can be a table or a function that
                -- returns a table (see below)
                command = { "zsh" }
            },
            python = {
                command = { "ipython" },
                format = require("iron.fts.common").bracketed_paste,
            },
        },
        -- How the repl window will be displayed
        -- See below for more information
        repl_open_cmd = view.split.vertical.botright(80),
    },
    -- Iron doesn't set keymaps by default anymore.
    -- You can set them here or manually add keymaps to the functions in iron.core
    keymaps = {
        send_motion = "<leader>is",  -- send selected
        visual_send = "<leader>is",  -- send selected
        send_file = "<leader>if",
        send_line = "<leader>il",
        interrupt = "<leader>ii",
        exit = "<leader>iq",
        clear = "<leader>ic",
    },
    ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
}

-- iron also has a list of commands, see :h iron-commands for all available commands
vim.keymap.set('n', '<leader>irf', '<cmd>IronFocus<cr>')

wk.add({
    { '<leader>i', group = 'iron' },
    { '<leader>is', desc = 'iron send (motion or visual)' },
    { '<leader>if', desc = 'iron send file' },
    { '<leader>il', desc = 'iron send line' },
    { '<leader>ii', desc = 'iron interrupt' },
    { '<leader>iq', desc = 'iron quit' },
    { '<leader>ic', desc = 'iron clear' },
    { '<leader>iF', desc = 'iron focus' },
})
