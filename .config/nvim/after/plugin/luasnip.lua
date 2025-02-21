local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require('luasnip.extras.fmt').fmt
local format = string.format

local function docstring_params(args, parent, user_args)
    local res = {}

    -- args has the form { { 'arg1: int, arg2: str, arg3: int' } }
    local name_type_pairs = vim.split(args[1][1], ',')
    -- iterate over the list of pairs
    for _, pair in ipairs(name_type_pairs) do
        -- split pair into tuple of name and type
        local parts = vim.split(pair, ':')
        -- create docstring and add to res
        if #parts == 2 then
            table.insert(res, format('\t%s : %s', vim.trim(parts[1]),
                         vim.trim(parts[2])))
            table.insert(res, '\t\t<XXX>')
            table.insert(res, '')
        elseif #parts == 1 then
            table.insert(res, format('\t%s :', vim.trim(parts[1])))
            table.insert(res, '\t\t<XXX>')
            table.insert(res, '')
        end
    end

    -- remove the last empty line
    table.remove(res, #res)

    return res
end

local function docstring_returns(args, parent, user_args)
    return {'\t' .. args[1][1],
            '\t\t<XXX>'}
end

ls.config.set_config({
    -- keep the last snippet around so we can jump back into it:
    history = true,

    update_events = 'TextChanged,TextChangedI',
    enable_autosnippets = true,
})

ls.add_snippets('all', {
    -- shebang:
    s({trig = '#!'},
      fmt(
        [[
            #!/usr/bin/env python
            """
            """
        ]],
        {})
    ),
    -- umlauts:
    s({trig = "''a", snippetType = 'autosnippet', wordTrig = false}, {t('ä')}),
    s({trig = "''A", snippetType = 'autosnippet', wordTrig = false}, {t('Ä')}),
    s({trig = "''o", snippetType = 'autosnippet', wordTrig = false}, {t('ö')}),
    s({trig = "''O", snippetType = 'autosnippet', wordTrig = false}, {t('Ö')}),
    s({trig = "''u", snippetType = 'autosnippet', wordTrig = false}, {t('ü')}),
    s({trig = "''U", snippetType = 'autosnippet', wordTrig = false}, {t('Ü')}),
    s({trig = "$$o", snippetType = 'autosnippet', wordTrig = false}, {t('ø')}),
    s({trig = "&&a", snippetType = 'autosnippet', wordTrig = false}, {t('à')}),
    s({trig = "&&e", snippetType = 'autosnippet', wordTrig = false}, {t('è')}),
    s({trig = "%%e", snippetType = 'autosnippet', wordTrig = false}, {t('é')}),
})

ls.add_snippets('python', {
    -- python function:
    s({trig = 'def'},
      fmt(
        [[
            def {}({}) -> {}:
                """
                <XXX>

                Parameters
                ----------

            {}

                Returns
                -------

            {}

                Raises
                ------

                XXXException
                    <If XXX goes wrong.>
                """

                {}
        ]],
        {i(1, 'function_name'), i(2, 'arg1: int'), i(3, 'int'),
         f(docstring_params, {2}), f(docstring_returns, {3}), i(0, 'pass')})
    ),
})

ls.add_snippets('rst', {
    -- figure:
    s({trig = 'fig'},
      fmt(
        [[
        .. figure:: {}
            :alt: {}
            :width: 80%

            {}
        ]],
        {i(1, 'filename'), i(2, '<alternate text>'), i(0, '<caption>')})
    ),
})
