local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local wk = require("which-key")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end)
vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end)
vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end)
vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end)
vim.keymap.set("n", "<leader>5", function() ui.nav_file(5) end)
vim.keymap.set("n", "<leader>6", function() ui.nav_file(6) end)

wk.add({
    { '<leader>a', desc = 'add file to harpoon' },
    { '<C-e>', desc = 'toggle harpoon menu' },
    { '<leader>1', desc = 'harpoon file 1' },
    { '<leader>2', desc = 'harpoon file 2' },
    { '<leader>3', desc = 'harpoon file 3' },
    { '<leader>4', desc = 'harpoon file 4' },
    { '<leader>5', desc = 'harpoon file 5' },
    { '<leader>6', desc = 'harpoon file 6' },
})
