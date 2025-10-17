if vim.b.did_indent == 1 then
    return
end
vim.b.did_indent = true

-- I want these special settings instead of my default treesitter indenting:
vim.opt.autoindent = true
vim.opt.indentexpr = nil
