require('nvim-treesitter.configs').setup({
    -- A list of parser names, or "all"
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "awk",
                       "python", "html", "javascript", "rst", "markdown" },
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
        disable = function(lang, buf)
            -- disable treesitter for large files (e.g., sql-dumps):
            local max_filesize = 10 * 1024 * 1024 -- 10 MB
            local ok, stats = pcall(vim.loop.fs_stat,
                                    vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                print('disableing treesitter for large file')
                return true
            end
        end,
        -- Setting this to true will run  and tree-sitter at the same time.
        -- Set this to  if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have CLI installed locally
  auto_install = true,
})
