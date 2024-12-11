require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all"
  -- ("c", "lua", "vim", "vimdoc", "query" should allways be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query",
                       "python", "html", "javascript", "rst" },

  -- Install parsers synchronously (only applied to )
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have  CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,

    -- Setting this to true will run  and tree-sitter at the same time.
    -- Set this to  if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
