-- use tree-sitter:
vim.treesitter.start()

-- Folds:
vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo[0][0].foldmethod = 'expr'

-- Indentation:
-- does not have support for indentation
