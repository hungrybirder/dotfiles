return {
    {
        "norcalli/nvim-colorizer.lua",
        opts = {},
    },

    -- {
    --     "airblade/vim-rooter",
    --     config = function()
    --         vim.g.root_patterns = {
    --             ".git",
    --             "_darcs",
    --             ".hg",
    --             ".bzr",
    --             ".svn",
    --             "Makefile",
    --             "package.json",
    --             "tox.ini",
    --             "pom.xml",
    --         }
    --         vim.g.rooter_cd_cmd = "lcd"
    --         vim.g.rooter_silent_chdir = 1
    --         vim.g.rooter_resolve_links = 1
    --     end,
    -- },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

            -- for Telescope lsp_document_symbols keymap
            { "stevearc/aerial.nvim", opts = {} },
        },
        keys = {
            {
                "<c-p>",
                function()
                    local builtin = require("telescope.builtin")
                    builtin.git_files()
                end,
                desc = "Git files",
            },
            {
                "<leader>m",
                function()
                    local builtin = require("telescope.builtin")
                    builtin.oldfiles()
                end,
                desc = "Recent files",
            },
            -- {
            --     "<leader>n",
            --     function()
            --         local builtin = require("telescope.builtin")
            --         builtin.marks()
            --     end,
            -- },
            {
                "<leader>F",
                function()
                    local builtin = require("telescope.builtin")
                    builtin.current_buffer_fuzzy_find()
                end,
                desc = " Fuzzy find on current buffer",
            },
            {
                "<leader>ts",
                function()
                    local builtin = require("telescope.builtin")
                    builtin.tagstack()
                end,
                desc = "Tag stack",
            },
            {
                "<leader>cc",
                function()
                    local builtin = require("telescope.builtin")
                    builtin.commands()
                end,
                desc = "Run command",
            },
            {
                "<leader>jl",
                function()
                    local builtin = require("telescope.builtin")
                    builtin.jumplist()
                end,
                desc = "Jumplist",
            },
            {
                "<F2>",
                function()
                    local builtin = require("telescope.builtin")
                    builtin.resume()
                end,
                desc = "Resume the previous telescope picker",
            },
            -- {
            --     "<leader>pf",
            --     function()
            --         local builtin = require("telescope.builtin")
            --         builtin.find_files()
            --     end,
            --     desc = "Find files",
            -- },
            {
                "<leader>ps",
                function()
                    local builtin = require("telescope.builtin")
                    builtin.grep_string({
                        search = vim.fn.input("Grep For > "),
                    })
                end,
                desc = "Search for a input string",
            },
            {
                "<leader>pw",
                function()
                    local builtin = require("telescope.builtin")
                    builtin.grep_string({
                        search = vim.fn.expand("<cword>"),
                    })
                end,
                desc = "Search for a current cursor string",
            },
            {
                "<leader>ws",
                function()
                    local builtin = require("telescope.builtin")
                    builtin.lsp_workspace_symbols({ query = "*" })
                end,
                desc = "Search workspace symbol",
            },
            {
                "<leader>cs",
                function()
                    local builtin = require("telescope.builtin")
                    builtin.lsp_document_symbols()
                end,
                desc = "Search document symbol",
            },
            {
                "<leader>o",
                "<cmd>Telescope aerial theme=ivy<CR>",
                desc = "Select document symbol",
            },
            {
                "<leader>gc",
                function()
                    local builtin = require("telescope.builtin")
                    builtin.git_branches()
                end,
                desc = "List git branches",
            },
        },
        config = function(_, opts)
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local action_layout = require("telescope.actions.layout")
            opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
                mappings = {
                    i = {
                        ["<c-s>"] = actions.select_horizontal,
                        ["<c-v>"] = actions.select_vertical,
                        ["<c-j>"] = actions.move_selection_next,
                        ["<c-k>"] = actions.move_selection_previous,
                        ["<esc>"] = actions.close,
                        ["<c-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        ["<c-q>"] = actions.send_to_qflist + actions.open_qflist,
                        ["<c-l>"] = actions.add_selected_to_loclist + actions.open_loclist,
                        ["<c-h>"] = actions.send_to_loclist + actions.open_loclist,
                        ["<M-p>"] = action_layout.toggle_preview,
                        -- ["<c-t>"] = trouble.open_with_trouble,
                    },
                    n = {
                        ["<c-s>"] = actions.select_horizontal,
                        ["<c-v>"] = actions.select_vertical,
                        ["<c-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        ["<c-q>"] = actions.send_to_qflist + actions.open_qflist,
                        ["<c-l>"] = actions.add_selected_to_loclist + actions.open_loclist,
                        ["<c-h>"] = actions.send_to_loclist + actions.open_loclist,
                        ["<M-p>"] = action_layout.toggle_preview,
                        -- ["<c-t>"] = trouble.open_with_trouble,
                    },
                },
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                },
                layout_strategy = "horizontal",
                file_ignore_patterns = { ".clang", ".trash", "node_modules" },
                path_display = { "truncate" },
                set_env = { ["COLORTERM"] = "truecolor" },
            })

            opts.pickers = {
                commands = { theme = "ivy", previewer = false },
                current_buffer_fuzzy_find = { theme = "ivy" },
                grep_string = { theme = "ivy" },
                jumplist = { theme = "ivy", previewer = false },
                loclist = { theme = "ivy", previewer = false },
                live_grep = { theme = "ivy" },
                man_pages = { sections = { "2", "3" } },
                lsp_references = { path_display = { "shorten" }, theme = "ivy" },
                lsp_document_symbols = { path_display = { "hidden" }, theme = "ivy" },
                lsp_workspace_symbols = { path_display = { "shorten" }, theme = "ivy" },
                lsp_incoming_calls = { theme = "ivy" },
                lsp_outgoing_calls = { theme = "ivy" },
                oldfiles = { theme = "ivy", previewer = false },
                tagstack = { theme = "ivy" },
                treesitter = { theme = "ivy" },
                git_branches = { theme = "ivy" },
                marks = { theme = "ivy", previewer = false },
                git_files = { theme = "ivy" },
                find_files = { theme = "ivy" },
                file_browser = { theme = "ivy" },
                buffers = {
                    sort_mru = true,
                    theme = "ivy",
                    selection_strategy = "closest",
                    previewer = false,
                    mappings = {
                        i = {
                            ["<c-d>"] = actions.delete_buffer,
                        },
                    },
                },
            }

            opts.extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            }

            telescope.setup(opts)

            local extensions = {
                "fzf",
                "notify",
                "aerial",
            }
            for _, ext in pairs(extensions) do
                status, _ = pcall(require, ext)
                if status then
                    telescope.load_extension(ext)
                end
            end
        end,
    },

    -- {
    --     "rhysd/clever-f.vim",
    --     config = function()
    --         vim.keymap.set({ "n", "v" }, ";", "<Plug>(clever-f-repeat-forward)", { desc = "clever-f forward" })
    --         vim.keymap.set({ "n", "v" }, ",", "<Plug>(clever-f-repeat-back)", { desc = "clever-f back" })
    --     end,
    -- },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        vscode = true,
        -- stylua: ignore
        keys = {
            { ",s", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { ";s", mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",         mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",         mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>",     mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
        dependencies = {
            { "svermeulen/vim-subversive" },
        },
        config = function()
            vim.keymap.del({ "n", "x", "o" }, "s")
            vim.keymap.del({ "n", "x", "o" }, "S")

            -- for vim-subversive
            vim.keymap.set("n", "s", "<plug>(SubversiveSubstitute)", { noremap = true, silent = true })
            vim.keymap.set("n", "ss", "<plug>(SubversiveSubstituteLine)", { noremap = true, silent = true })
            vim.keymap.set("n", "S", "<plug>(SubversiveSubstituteToEndOfLine)", { noremap = true, silent = true })
            -- <leader>s<motion1><motion2>
            -- vim.keymap.set({ "n", "x" }, "<leader>s", "<plug>(SubversiveSubstituteRange)", { noremap = true })
            -- vim.keymap.set("n", "<leader>ss", "<plug>(SubversiveSubstituteWordRange)", { noremap = true })
        end,
    },

    -- another buffer selector
    {
        "leath-dub/snipe.nvim",
        keys = {
            {
                "<leader>b",
                function()
                    require("snipe").open_buffer_menu()
                end,
                desc = "Open Snipe buffer menu",
            },
        },
        opts = {
            ui = {
                position = "center",
            },
        },
    },

    {
        "max397574/better-escape.nvim",
        config = function()
            require("better_escape").setup()
        end,
    },

    -- delete buffer without closing windows
    {
        "moll/vim-bbye",
        keys = {
            { "<leader><BS>", "<cmd>Bdelete<CR>", desc = "Delete current buffer" },
        },
    },
    -- Delete all the buffers except the current buffer
    {
        "stevearc/stickybuf.nvim",
        opts = {},
    },

    { "schickling/vim-bufonly" },

    {
        "Bekaboo/dropbar.nvim",
        -- optional, but required for fuzzy finder support
        dependencies = {
            "nvim-telescope/telescope-fzf-native.nvim",
        },
    },

    -- best folder plugin nvim-ufo
    {
        "kevinhwang91/nvim-ufo",
        dependencies = {
            "kevinhwang91/promise-async",
            {
                "luukvbaal/statuscol.nvim",
                config = function()
                    local builtin = require("statuscol.builtin")
                    require("statuscol").setup({
                        relculright = true,
                        segments = {
                            {
                                text = { builtin.foldfunc },
                                click = "v:lua.ScFa",
                            },
                            {
                                text = { "%s" },
                                click = "v:lua.ScSa",
                            },
                            {
                                text = { builtin.lnumfunc, " " },
                                click = "v:lua.ScLa",
                            },
                        },
                    })
                end,
            },
        },
        config = function()
            ---@diagnostic disable: missing-fields
            require("ufo").setup({
                preview = {
                    mappings = {
                        close = "<ESC>",
                    },
                },
                fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
                    local newVirtText = {}
                    local suffix = (" 󰁂 %d "):format(endLnum - lnum)
                    local sufWidth = vim.fn.strdisplaywidth(suffix)
                    local targetWidth = width - sufWidth
                    local curWidth = 0
                    for _, chunk in ipairs(virtText) do
                        local chunkText = chunk[1]
                        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        if targetWidth > curWidth + chunkWidth then
                            table.insert(newVirtText, chunk)
                        else
                            chunkText = truncate(chunkText, targetWidth - curWidth)
                            local hlGroup = chunk[2]
                            table.insert(newVirtText, { chunkText, hlGroup })
                            chunkWidth = vim.fn.strdisplaywidth(chunkText)
                            -- str width returned from truncate() may less than 2nd argument, need padding
                            if curWidth + chunkWidth < targetWidth then
                                suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                            end
                            break
                        end
                        curWidth = curWidth + chunkWidth
                    end
                    table.insert(newVirtText, { suffix, "MoreMsg" })
                    return newVirtText
                end,
            })
            vim.keymap.set("n", "zR", require("ufo").openAllFolds)
            vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
            vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
            vim.keymap.set("n", "zm", require("ufo").closeFoldsWith)
            vim.keymap.set("n", "<s-tab>", "za")
        end,
    },
    -- better quickfix window
    {
        "kevinhwang91/nvim-bqf",
        config = function()
            ---@diagnostic disable: missing-fields
            require("bqf").setup({
                auto_enable = true,
                auto_resize_height = true,
                filter = {
                    fzf = { action_for = { ["ctrl-s"] = "split" } },
                    extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
                },
            })
            vim.cmd([[
                hi BqfPreviewBorder guifg=#a0c980 ctermfg=71
                hi link BqfPreviewRange Search
            ]])
        end,
    },

    -- mx              Set mark x
    -- m,              Set the next available alphabetical (lowercase) mark
    -- m;              Toggle the next available mark at the current line
    -- dmx             Delete mark x
    -- dm-             Delete all marks on the current line
    -- dm<space>       Delete all marks in the current buffer
    -- m]              Move to next mark
    -- m[              Move to previous mark
    -- m:              Preview mark. This will prompt you for a specific mark to
    --                 preview; press <cr> to preview the next mark.
    --
    -- m[0-9]          Add a bookmark from bookmark group[0-9].
    -- dm[0-9]         Delete all bookmarks from bookmark group[0-9].
    -- m}              Move to the next bookmark having the same type as the bookmark under
    --                 the cursor. Works across buffers.
    -- m{              Move to the previous bookmark having the same type as the bookmark under
    --                 the cursor. Works across buffers.
    -- dm=             Delete the bookmark under the cursor.
    {
        "chentoast/marks.nvim",
        config = function()
            require("marks").setup()
        end,
    },

    -- registers
    { "tversteeg/registers.nvim" },

    -- for gnupg
    { "jamessan/vim-gnupg" },

    -- FIX:
    -- FIXME:
    -- TODO:
    -- PERF:
    -- HACK:
    -- INFO:
    -- WARNING:
    -- NOTE:
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },

    {
        "mg979/vim-visual-multi",
        branch = "master",
        config = function()
            vim.g["VM_leader"] = "\\"
        end,
    },
    {
        "kevinhwang91/nvim-hlslens",
        config = function()
            local kopts = { noremap = true, silent = true }
            vim.api.nvim_set_keymap(
                "n",
                "n",
                [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
                kopts
            )
            vim.api.nvim_set_keymap(
                "n",
                "N",
                [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
                kopts
            )
            vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
            local hlslens = require("hlslens")
            if hlslens then
                local overrideLens = function(render, posList, nearest, idx, relIdx)
                    local _ = relIdx
                    local lnum, col = unpack(posList[idx])

                    local text, chunks
                    if nearest then
                        text = ("[%d/%d]"):format(idx, #posList)
                        chunks = { { " ", "Ignore" }, { text, "VM_Extend" } }
                    else
                        text = ("[%d]"):format(idx)
                        chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
                    end
                    render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
                end
                local lens_bak
                local hslens_config = require("hlslens.config")
                local gid = vim.api.nvim_create_augroup("VMlens", {})
                vim.api.nvim_create_autocmd("User", {
                    pattern = { "visual_multi_start", "visual_multi_exit" },
                    group = gid,
                    callback = function(ev)
                        if ev.match == "visual_multi_start" then
                            lens_bak = hslens_config.override_lens
                            hslens_config.override_lens = overrideLens
                        else
                            hslens_config.override_lens = lens_bak
                        end
                        hlslens.start()
                    end,
                })
            end
            hlslens.setup({ calm_down = true })
        end,
    },

    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({})
        end,
    },

    { "szw/vim-maximizer" },

    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end,
    },

    -- nvim-tree
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            vim.cmd(
                [[autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]]
            )
            vim.keymap.set("n", "<leader><tab>", "<cmd>NvimTreeToggle<CR>")
            local function nvim_tree_on_attach(bufnr)
                local api = require("nvim-tree.api")
                local function opts(desc)
                    return {
                        desc = "nvim-tree: " .. desc,
                        buffer = bufnr,
                        noremap = true,
                        silent = true,
                        nowait = true,
                    }
                end
                api.config.mappings.default_on_attach(bufnr)
                vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
                vim.keymap.set("n", "<c-v>", api.node.open.vertical, opts("Open: Vertical Split"))
                vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))
                vim.keymap.set("n", "<c-s>", api.node.open.horizontal, opts("Open: Horizontal Split"))
                vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts("Up"))
            end
            require("nvim-tree").setup({
                on_attach = nvim_tree_on_attach,
                disable_netrw = false,
                create_in_closed_folder = false,
                hijack_netrw = true,
                open_on_tab = false,
                hijack_cursor = false,
                update_cwd = false,
                diagnostics = { enable = true },
                update_focused_file = {
                    -- enable = false,
                    enable = true,
                    update_cwd = false,
                    ignore_list = {},
                },
                view = {
                    width = 30,
                    side = "left",
                    -- mappings = {
                    --     custom_only = false,
                    --     list = {
                    --         { key = "<C-e>", action = "" }, -- disable edit_in_place
                    --     },
                    -- },
                    -- float = {
                    --     enable = true,
                    -- },
                },
                filters = {
                    dotfiles = false,
                    -- ignore some dirs
                    custom = { ".git", "node_modules", ".cache" },
                },
                renderer = {
                    highlight_opened_files = "all",
                    group_empty = true,
                },
            })
        end,
    },

    {
        "stevearc/oil.nvim",
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {
            keymaps = {
                ["<ESC>"] = { "actions.close", desc = "Close" },
            },
        },
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
    },

    { "mbbill/undotree" },
}
