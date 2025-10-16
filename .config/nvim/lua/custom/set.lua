-- block cursor:
vim.opt.guicursor = ""

-- line numbers and relative line numbers:
vim.opt.nu = true
vim.opt.relativenumber = true

-- indenting:
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- no line wrapping:
vim.opt.wrap = false

-- don't create backups but use persistent undotree:
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath('data') .. '/undodir'
vim.opt.undofile = true

-- don't keep search highlighted but do incremental search:
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- 24bit color in the TUI:
vim.opt.termguicolors = true

-- no less than 8 lines "look-ahead" / "look-behind":
vim.opt.scrolloff = 8

-- always show sign-column:
vim.opt.signcolumn = 'yes'

-- set textwidth (used by gq):
vim.opt.textwidth = 79

-- highlight column 80:
vim.opt.colorcolumn = '80'

-- leader key is space:
vim.g.mapleader = ' '

-- enable spell checking:
vim.opt.spelllang = 'en_us,de_ch'
vim.opt.spell = true

-- enable folding:
vim.api.nvim_create_autocmd({ "FileType" }, {
    callback = function()
        -- check if treesitter has parser 
        if require("nvim-treesitter.parsers").has_parser() then
            -- use treesitter folding
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
            -- keep all folds open by default:
            vim.opt.foldlevel = 99
            -- just use the existing line as fold text (this also preserves the
            -- syntax highlighting):
            vim.opt.foldtext = ""
        else
            -- use alternative fold method:
            vim.opt.foldmethod = "syntax"
        end
    end,
})

-- markdown-preview: Don't close preview when switching buffer:
vim.g.mkdp_auto_close = 0

-- use nerdfonts in dadbod-ui:
vim.g.db_ui_use_nerd_fonts = true
