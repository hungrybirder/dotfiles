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
    { "onsails/lspkind.nvim", opts = { mode = "symbol_text", preset = "codicons" } },
    "hrsh7th/cmp-buffer",
    -- "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-path",
    -- cmp-nvim-lua 已由 LazyVim 自带的 lazydev.nvim（sources 里的 lazydev）取代
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    {
        "petertriho/cmp-git",
        dependencies = "nvim-lua/plenary.nvim",
        opts = {},
        -- git source 已在下面 cmp.setup 的 sources 里声明，不再用 init 重复插入
    },
    { "davidsierradz/cmp-conventionalcommits" },
    -- LazyVim 的 nvim-cmp 扩展会拉进 nvim-snippets，这里用 LuaSnip，关掉它
    { "garymjr/nvim-snippets", enabled = false },
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
            -- 自己的 VSCode 格式片段（原 vsnip/ 目录，补了 package.json 后 LuaSnip 才会读）
            require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
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
                    -- Neovim / LazyVim / 插件 API 的 Lua 补全（lazydev.nvim）
                    { name = "lazydev", group_index = 0 },
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
                    { name = "buffer" },
                    { name = "path" },
                    { name = "git" },
                    { name = "crates" },
                    { name = "codeium" },
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
                            lazydev = "[Lua]",
                            latex_symbols = "[Latex]",
                            vsnip = "[Vsnip]",
                            tags = "[Tag]",
                            Codeium = "",
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
                            local entries = cmp.get_entries()
                            -- 只有一个候选项时直接确认选中
                            if #entries == 1 then
                                cmp.confirm({ select = true })
                            else
                                cmp.select_next_item()
                            end
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

            -- gitcommit 的补全源在 after/ftplugin/gitcommit.lua 里（buffer 级配置优先于 filetype 级）

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
            -- cmp.setup.cmdline(":", {
            --     mapping = cmp.mapping.preset.cmdline(),
            --     sources = cmp.config.sources({
            --         -- { name = "path" },
            --     }, {
            --         {
            --             name = "cmdline",
            --             option = {
            --                 ignore_cmds = { "Man", "!" },
            --             },
            --         },
            --     }),
            -- })

            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

            -- nvim-autopairs 的 setup 已由上面 dependencies 里的 opts 完成，这里只去掉反引号规则
            require("nvim-autopairs").remove_rule("`")
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
        -- lazy.nvim 的 keys 格式是 { lhs, rhs, mode = ... }，原来把 "n" 写成了 lhs
        keys = {
            { "<leader>gh", "<cmd>diffget //2<CR>", desc = "Diffget //2 (ours)" },
            { "<leader>gf", "<cmd>diffget //3<CR>", desc = "Diffget //3 (theirs)" },
            { "<leader>gs", "<cmd>G<CR>", desc = "Fugitive status" },
            { "<leader>ga", "<cmd>Git fetch --all<CR>", desc = "Git fetch --all" },
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

                    -- Navigation（next_hunk/prev_hunk 已弃用，改用 nav_hunk）
                    map("n", "]c", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "]c", bang = true })
                        else
                            gs.nav_hunk("next")
                        end
                    end, { desc = "Next hunk" })

                    map("n", "[c", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "[c", bang = true })
                        else
                            gs.nav_hunk("prev")
                        end
                    end, { desc = "Prev hunk" })

                    -- Actions
                    map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
                    map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
                    map("n", "<leader>hS", gs.stage_buffer)
                    -- undo_stage_hunk 已弃用：stage_hunk 在已暂存的 hunk 上会取消暂存
                    map("n", "<leader>hu", gs.stage_hunk)
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
                    -- toggle_deleted 已弃用，改用行内预览
                    map("n", "<leader>td", gs.preview_hunk_inline)

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
        build = "cd app && npx --yes yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown", "mkd" }
            vim.g.mkdp_theme = "light"
        end,
        keys = {
            { "<leader>pm", "<cmd>MarkdownPreview<CR>" },
        },
        ft = { "markdown" },
    },
    -- mathjax-support-for-mkdp 是给老的 markdown-preview.vim 用的，markdown-preview.nvim 内置 KaTeX
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
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- 只需要图标，不用整个 mini.nvim
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {
            completions = {
                lsp = { enabled = true },
            },
        },
    },

    -- for js/ts dev
    {
        "barrett-ruth/live-server.nvim",
        cmd = { "LiveServerStart", "LiveServerStop" },
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
        -- 保存时的 goimports/gofumpt 由 conform.nvim（见 lsp.lua）+ LazyVim autoformat 完成，
        -- 这里不再挂 BufWritePre，避免格式化两遍
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
        config = function()
            local neotest_commands = {
                NeotestRun = function()
                    require("neotest").run.run()
                end,
                NeotestStop = function()
                    require("neotest").run.stop()
                end,
                NeotestAttach = function()
                    require("neotest").run.attach()
                end,
                NeotestDebugNearest = function()
                    require("neotest").run.run({ strategy = "dap" })
                end,
                NeotestRunFile = function()
                    require("neotest").run.run(vim.fn.expand("%"))
                end,
                NeotestToggleSummary = function()
                    require("neotest").summary.toggle()
                end,
                NeotestJumpPrevFailed = function()
                    require("neotest").jump.prev({ status = "failed" })
                end,
                NeotestJumpNextFailed = function()
                    require("neotest").jump.next({ status = "failed" })
                end,
            }
            for name, fn in pairs(neotest_commands) do
                vim.api.nvim_create_user_command(name, fn, { desc = name })
            end
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
