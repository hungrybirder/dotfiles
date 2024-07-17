---@diagnostic disable: missing-fields

-- From: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local luasnip = require("luasnip")

-- Copy from https://github.com/lukas-reineke/cmp-under-comparator
local under_comparator = function(entry1, entry2)
    local _, entry1_under = entry1.completion_item.label:find("^_+")
    local _, entry2_under = entry2.completion_item.label:find("^_+")
    entry1_under = entry1_under or 0
    entry2_under = entry2_under or 0
    return entry1_under < entry2_under
end

local cmp = require("cmp")
cmp.setup({
    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.sort_text,
            cmp.config.compare.score,
            under_comparator,
            cmp.config.compare.recently_used,
            cmp.config.compare.kind,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    sources = cmp.config.sources({
        {
            name = "luasnip",
            option = { use_show_condition = true },
            entry_filter = function()
                local context = require("cmp.config.context")
                local string_ctx = context.in_treesitter_capture("string") or context.in_syntax_group("String")
                local comment_ctx = context.in_treesitter_capture("comment") or context.in_syntax_group("Comment")
                return not string_ctx and not comment_ctx
            end,
        },
        { name = "nvim_lsp" },
        { name = "go_pkgs" },
        { name = "buffer" },
        { name = "nvim_lsp_signature_help" },
        { name = "path" },
        { name = "git" },
        { name = "git" },
        { name = "conventionalcommits" },
        { name = "nvim_lua" },
        { name = "crates" },
    }),
    matching = {
        disallow_symbol_nonprefix_matching = false,
    },
    formatting = {
        format = require("lspkind").cmp_format({
            with_text = true,
            menu = {
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
                latex_symbols = "[Latex]",
                vsnip = "[Vsnip]",
                tags = "[Tag]",
                go_pkgs = "[pkgs]",
            },
        }),
    },
    experimental = {
        ghost_text = {
            hl_group = "CmpGhostText",
        },
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
})

cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "git" },
    }, {
        { name = "buffer" },
    }),
})

-- Use buffer source for `/`.
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "nvim_lsp_document_symbol" },
    }, {
        { name = "buffer" },
    }),
})
-- Use cmdline & path source for ':'.
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        -- { name = "path" },
    }, {
        {
            name = "cmdline",
            option = {
                ignore_cmds = { "Man", "!" },
            },
        },
    }),
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

local npairs = require("nvim-autopairs")
npairs.setup({
    -- put this to setup function and press <a-e> to use fast_wrap
    fast_wrap = {},
})
npairs.remove_rule("`")
