if vim.b.did_indent == 1 then
    return
end
vim.b.did_indent = true

-- don't do anything, my global indent settings are good enough
-- this file prevents the default indent script - which does more harm than
-- good, I think - from loading
