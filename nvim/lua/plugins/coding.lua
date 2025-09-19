---@diagnostic disable: missing-fields
return {

    {
        "hedyhli/outline.nvim",
        keys = { { "<leader>v", "<cmd>Outline<cr>", desc = "Toggle Outline" } },
        cmd = "Outline",
        opts = function()
            local defaults = require("outline.config").defaults
            local opts = {
                symbols = {
                    icons = {},
                    filter = vim.deepcopy(LazyVim.config.kind_filter),
                },
                keymaps = {
                    up_and_jump = "<up>",
                    down_and_jump = "<down>",
                },
                outline_window = {
                    wrap = true,
                },
            }

            for kind, symbol in pairs(defaults.symbols.icons) do
                opts.symbols.icons[kind] = {
                    icon = LazyVim.config.icons.kinds[kind] or symbol.icon,
                    hl = symbol.hl,
                }
            end
            return opts
        end,
    },

    -- completion sources
    "hrsh7th/cmp-nvim-lsp",
    "onsails/lspkind.nvim",
    "hrsh7th/cmp-buffer",
    -- "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lua",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    {
        "petertriho/cmp-git",
        dependencies = "nvim-lua/plenary.nvim",
        opts = {},
        init = function()
            table.insert(require("cmp").get_config().sources, { name = "git" })
        end,
    },
    { "davidsierradz/cmp-conventionalcommits" },
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
    -- "Snikimonkd/cmp-go-pkgs",

    -- auto completion
    {
        "supermaven-inc/supermaven-nvim",
        config = function()
            require("supermaven-nvim").setup({
                keymaps = {
                    accept_suggestion = "<C-l>",
                    clear_suggestion = "<C-k>",
                    accept_word = "<C-j>",
                },
            })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            {
                "windwp/nvim-autopairs",
                event = "InsertEnter",
                opts = {
                    fast_wrap = {},
                },
            },
            {
                "nvim-mini/mini.pairs",
                enabled = false,
            },
        },
        config = function()
            -- From: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
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
            local compare = require("cmp.config.compare")
            cmp.setup({
                sorting = {
                    comparators = {
                        compare.offset,
                        compare.exact,
                        compare.sort_text,
                        compare.score,
                        under_comparator,
                        compare.recently_used,
                        compare.kind,
                        compare.length,
                        compare.order,
                    },
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                    -- expand = function(fallback)
                    --     local luasnip = require("luasnip")
                    --     local suggestion = require("supermaven-nvim.completion_preview")
                    --
                    --     if luasnip.expandable() then
                    --         luasnip.expand()
                    --     elseif suggestion.has_suggestion() then
                    --         suggestion.on_accept_suggestion()
                    --     else
                    --         fallback()
                    --     end
                    -- end,
                },
                sources = cmp.config.sources({
                    {
                        name = "luasnip",
                        option = { use_show_condition = true },
                        entry_filter = function()
                            local context = require("cmp.config.context")
                            local string_ctx = context.in_treesitter_capture("string")
                                or context.in_syntax_group("String")
                            local comment_ctx = context.in_treesitter_capture("comment")
                                or context.in_syntax_group("Comment")
                            return not string_ctx and not comment_ctx
                        end,
                    },
                    { name = "nvim_lsp" },
                    { name = "supermaven" },
                    -- { name = "go_pkgs" },
                    { name = "buffer" },
                    { name = "path" },
                    { name = "git" },
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
        end,
        event = "InsertEnter",
    },

    -- git

    -- diffview
    {
        "sindrets/diffview.nvim",
        opts = {
            default_args = {
                DiffviewOpen = { "--imply-local" },
            },
            keymaps = {
                file_panel = {
                    {
                        "n",
                        "cc",
                        "<Cmd>Git commit <bar> wincmd J<CR>",
                        { desc = "Commit staged changes" },
                    },
                },
            },
        },
        keys = {
            { "<leader>vc", "<cmd>DiffviewClose<CR>", desc = "DiffView close" },
            { "<leader>vo", "<cmd>DiffviewOpen<CR>", desc = "DiffView open" },
            { "<leader>vr", "<cmd>DiffviewRefresh<CR>", desc = "DiffView refresh" },
            { "<leader>vt", "<cmd>DiffviewToggleFiles<CR>", desc = "DiffView toggle files" },
            { "<leader>vf", "<cmd>DiffviewFocusFiles<CR>", desc = "DiffView focus files" },
        },
        lazy = false,
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "sindrets/diffview.nvim",
        },
        config = function()
            require("neogit").setup({
                mappings = {
                    finder = {
                        ["<c-j>"] = "Next",
                        ["<c-k>"] = "Previous",
                    },
                    status = {
                        ["<esc>"] = "Close",
                    },
                },
            })
            vim.keymap.set("n", "<leader>g", "<cmd>Neogit<cr>")
            vim.keymap.set("n", "<leader>gv", "<cmd>lua require('neogit').open({'log'})<cr>")
        end,
    },
    {
        "tpope/vim-fugitive",
        keys = {
            { "n", "<leader>gh", "<cmd>diffget //2<CR>" },
            { "n", "<leader>gf", "<cmd>diffget //3<CR>" },
            { "n", "<leader>gs", "<cmd>G<CR>" },
            { "n", "<leader>ga", "<cmd>Git fetch --all<CR>" },
        },
        lazy = false,
    },
    {
        "lewis6991/gitsigns.nvim",
        lazy = false,
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("gitsigns").setup({
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map("n", "]c", function()
                        if vim.wo.diff then
                            return "]c"
                        end
                        vim.schedule(function()
                            gs.next_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true })

                    map("n", "[c", function()
                        if vim.wo.diff then
                            return "[c"
                        end
                        vim.schedule(function()
                            gs.prev_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true })

                    -- Actions
                    map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
                    map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
                    map("n", "<leader>hS", gs.stage_buffer)
                    map("n", "<leader>hu", gs.undo_stage_hunk)
                    map("n", "<leader>hR", gs.reset_buffer)
                    map("n", "<leader>hp", gs.preview_hunk)
                    map("n", "<leader>hb", function()
                        gs.blame_line({ full = true })
                    end)
                    map("n", "<leader>tb", gs.toggle_current_line_blame)
                    map("n", "<leader>hd", gs.diffthis)
                    map("n", "<leader>hD", function()
                        gs.diffthis("~")
                    end)
                    map("n", "<leader>td", gs.toggle_deleted)

                    -- Text object
                    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
                end,
            })
        end,
    },
    {
        "ruifm/gitlinker.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        opts = {},
    },

    -- a lot of tools
    {
        "hat0uma/prelive.nvim",
        opts = {},
        cmd = {
            "PreLiveGo",
            "PreLiveStatus",
            "PreLiveClose",
            "PreLiveCloseAll",
            "PreLiveLog",
        },
    },

    -- markdown
    -- {
    --     "preservim/vim-markdown",
    --     dependencies = { "godlygeek/tabular" },
    --     config = function()
    --         -- vim.keymap.set("n", "<leader>o", "<cmd>Toc<CR>", { buffer = true, remap = false })
    --         vim.keymap.set("n", "<leader>tf", "<cmd>TableFormat<CR>", { buffer = true, remap = false })
    --     end,
    --     ft = { "markdown" },
    -- },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown", "mkd" }
            vim.g.mkdp_theme = "light"
            vim.g.vim_markdown_math = true
        end,
        keys = {
            { "<leader>pm", "<cmd>MarkdownPreview<CR>" },
        },
        ft = { "markdown" },
    },
    { "iamcco/mathjax-support-for-mkdp" },
    -- MacOS: brew install glow
    -- https://github.com/charmbracelet/glow
    {
        "ellisonleao/glow.nvim",
        opts = {},
    },
    { "qadzek/link.vim" },

    -- markdown render
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
        opts = {},
    },

    -- for js/ts dev
    {
        "barrett-ruth/live-server.nvim",
        build = "pnpm add -g live-server",
        cmd = { "LiveServerStart", "LiveServerStop" },
        config = true,
    },
    -- for rust dev
    { "rust-lang/rust.vim" },
    {
        "simrat39/rust-tools.nvim",
        keys = {
            { "<leader>rr", "<cmd>RustRun<CR>", ft = "rust", desc = "Rust run" },
            { "<leader>rd", "<cmd>RustDebuggable<CR>", ft = "rust", desc = "Rust debuggable" },
        },
        init = function()
            vim.api.nvim_create_augroup("cargo_toml_lsp", { clear = true })
            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = "Cargo.toml",
                callback = function()
                    -- crates.nvim registered code action into null-ls
                    -- vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>")
                    vim.keymap.set("n", "<leader>ca", "<cmd>vim.lsp.buf.code_action()<CR>")

                    -- crates.nvim mappings
                    vim.keymap.set("n", "<leader>ct", "<cmd>lua require('crates').toggle()<cr>")
                    vim.keymap.set("n", "<leader>cr", "<cmd>lua require('crates').reload()<cr>")

                    vim.keymap.set("n", "<leader>cv", "<cmd>lua require('crates').show_versions_popup()<cr>")
                    vim.keymap.set("n", "<leader>cf", "<cmd>lua require('crates').show_features_popup()<cr>")

                    vim.keymap.set("n", "<leader>cu", "<cmd>lua require('crates').update_crate()<cr>")
                    vim.keymap.set("v", "<leader>cu", "<cmd>lua require('crates').update_crates()<cr>")
                    -- vim.keymap.set("n", "<leader>ca", "<cmd>lua require('crates').update_all_crates()<cr>")
                    vim.keymap.set("n", "<leader>cU", "<cmd>lua require('crates').upgrade_crate()<cr>")
                    vim.keymap.set("v", "<leader>cU", "<cmd>lua require('crates').upgrade_crates()<cr>")
                    vim.keymap.set("n", "<leader>cA", "<cmd>lua require('crates').upgrade_all_crates()<cr>")

                    vim.keymap.set("n", "<leader>cH", "<cmd>lua require('crates').open_homepage()<cr>")
                    vim.keymap.set("n", "<leader>cR", "<cmd>lua require('crates').open_repository()<cr>")
                    vim.keymap.set("n", "<leader>cD", "<cmd>lua require('crates').open_documentation()<cr>")
                    vim.keymap.set("n", "<leader>cC", "<cmd>lua require('crates').open_crates_io()<cr>")
                end,
            })
        end,
    },
    {
        "saecki/crates.nvim",
        dependencies = { { "nvim-lua/plenary.nvim" } },
        config = function()
            require("crates").setup({
                -- null_ls = {
                --     enabled = true,
                --     name = "crates.nvim",
                -- },
            })
        end,
    },

    -- for Go dev
    -- Alternate between files, such as foo.go and foo_test.go
    {
        "rgroli/other.nvim",
        config = function()
            require("other-nvim").setup({
                mappings = {
                    {
                        pattern = "(.*).go$",
                        target = "%1_test.go",
                        context = "test",
                    },
                    {
                        pattern = "(.*)_test.go$",
                        target = "%1.go",
                        context = "file",
                    },
                },
            })

            vim.api.nvim_create_user_command("A", function(opts)
                require("other-nvim").open(opts.fargs[1])
            end, { nargs = "*" })

            vim.api.nvim_create_user_command("AV", function(opts)
                require("other-nvim").openVSplit(opts.fargs[1])
            end, { nargs = "*" })

            vim.api.nvim_create_user_command("AS", function(opts)
                require("other-nvim").openSplit(opts.fargs[1])
            end, { nargs = "*" })
        end,
    },
    {
        "ray-x/go.nvim",
        dependencies = { -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            -- lsp_keymaps = false,
            -- other options
            lsp_inlay_hints = {
                enable = false,
            },
        },
        config = function(lp, opts)
            require("go").setup(opts)
            local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function()
                    require("go.format").goimports()
                end,
                group = format_sync_grp,
            })
        end,
        event = { "CmdlineEnter" },
        ft = { "go", "gomod" },
        build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
    },
    { "Valloric/ListToggle" },

    -- for lua develop
    -- {
    --     "folke/neoconf.nvim",
    --     config = function()
    --         require("neoconf").setup({})
    --     end,
    -- },
    -- {
    --     "folke/neodev.nvim",
    --     config = function()
    --         require("neodev").setup({
    --             library = {
    --                 plugins = { "nvim-dap-ui" },
    --                 types = true,
    --             },
    --         })
    --     end,
    -- },

    -- nettest
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-plenary",
            "nvim-neotest/neotest-python",
            -- "nvim-neotest/neotest-go",
            {
                "fredrikaverpil/neotest-golang",
                version = "*",
            },
            -- "nvim-neotest/neotest-vim-test",
            "mfussenegger/nvim-dap",
        },
        config = function(_, opts)
            vim.api.nvim_command("command! -nargs=0 NeotestRun :lua require('neotest').run.run()<CR>")
            vim.api.nvim_command("command! -nargs=0 NeotestStop :lua require('neotest').run.stop()<CR>")
            vim.api.nvim_command("command! -nargs=0 NeotestAttach :lua require('neotest').run.attach()<CR>")
            vim.api.nvim_command(
                "command! -nargs=0 NeotestDebugNearest :lua require('neotest').run.run({strategy = 'dap'})<CR>"
            )
            vim.api.nvim_command(
                "command! -nargs=0 NeotestRunFile :lua require('neotest').run.run(vim.fn.expand('%'))<CR>"
            )
            vim.api.nvim_command("command! -nargs=0 NeotestToggleSummary :lua require('neotest').summary.toggle()<CR>")
            vim.api.nvim_command(
                "command! -nargs=0 NeotestJumpPrevFailed :lua require('neotest').jump.prev({ status = 'failed' })<CR>"
            )
            vim.api.nvim_command(
                "command! -nargs=0 NeotestJumpnextFailed :lua require('neotest').jump.next({ status = 'failed' })<CR>"
            )
            require("neotest").setup({
                adapters = {
                    require("neotest-plenary"),
                    require("neotest-python")({
                        dap = { justMyCode = false },
                    }),
                    require("neotest-golang"),
                },
                -- TODO:
                -- consumers = {
                --     overseer = require("neotest.consumers.overseer"),
                -- },
            })
        end,
    },

    -- java maven and gradle
    {
        "oclay1st/maven.nvim",
        cmd = { "Maven", "MavenInit", "MavenExec" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        opts = {}, -- options, see default configuration
        keys = {
            {
                "<Leader>M",
                function()
                    require("maven").toggle_projects_view()
                end,
                desc = "Maven",
            },
        },
    },
    {
        "oclay1st/gradle.nvim",
        cmd = { "Gradle", "GradleExec", "GradleInit" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        opts = {}, -- options, see default configuration
        keys = {
            {
                "<Leader>G",
                function()
                    require("gradle").toggle_projects_view()
                end,
                desc = "Gradle",
            },
        },
    },
}
