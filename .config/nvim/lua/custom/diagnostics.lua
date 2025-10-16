-- gutter symbols:
local signs = { ERROR = "✘ ", WARN = "▲ ", HINT = "⚑ ", INFO = "» " }
local text = { }
local texthl = { }
local numhl = { }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    -- vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    text[vim.diagnostic.severity[type]] = icon
    texthl[vim.diagnostic.severity[type]] = hl
    numhl[vim.diagnostic.severity[type]] = hl
end

vim.diagnostic.config({
    virtual_text = { current_line = true },
    signs = { text = text, texthl = texthl, numhl = numhl }
})
