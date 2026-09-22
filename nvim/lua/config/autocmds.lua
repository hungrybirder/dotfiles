local function augroup(name)
    return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- 终端里按 <Esc> 回到 normal 模式
vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup("terminal"),
    callback = function(args)
        vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = args.buf, desc = "Terminal normal mode" })
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup("lsp_attach_disable_ruff_hover"),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
            return
        end
        if client.name == "ruff" then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
        end
    end,
    desc = "LSP: Disable hover capability from Ruff",
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup("lsp_attach_post"),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
            return
        end
        require("util.lsp").lsp_on_attach_post(client, args.buf)
    end,
    desc = "LSP Attach Post",
})

-- from neovim v0.12.0 LspInfo/LspLog/LspRestart are deprecated
vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", {
    desc = "Show LSP Info",
})

vim.api.nvim_create_user_command("LspLog", function(_)
    local state_path = vim.fn.stdpath("state")
    local log_path = vim.fs.joinpath(state_path, "lsp.log")

    vim.cmd(string.format("edit %s", log_path))
end, {
    desc = "Show LSP log",
})

vim.api.nvim_create_user_command("LspRestart", "lsp restart", {
    desc = "Restart LSP",
})

-- 如果不想用 fidget.nvim，可以改用 0.12 原生的进度消息：
-- vim.api.nvim_create_autocmd("LspProgress", {
--     callback = function(ev)
--         local value = ev.data.params.value
--         vim.api.nvim_echo({ { value.message or "done" } }, false, {
--             id = "lsp." .. ev.data.client_id,
--             kind = "progress",
--             source = "vim.lsp",
--             title = value.title,
--             status = value.kind ~= "end" and "running" or "success",
--             percent = value.percentage,
--         })
--     end,
-- })

-- Neovim 0.12 实验性的 ui2：不再有 "Press ENTER" 提示（noice.nvim 已在 disabled.lua 关闭）
require("vim._core.ui2").enable({
    enable = true,
    msg = { -- Options related to the message module.
        ---@type 'cmd'|'msg' Default message target, either in the
        ---cmdline or in a separate ephemeral message window.
        ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
        ---or table mapping |ui-messages| kinds and triggers to a target.
        targets = "cmd",
        cmd = { -- Options related to messages in the cmdline window.
            height = 0.5, -- Maximum height while expanded for messages beyond 'cmdheight'.
        },
        dialog = { -- Options related to dialog window.
            height = 0.5, -- Maximum height.
        },
        msg = { -- Options related to msg window.
            height = 0.5, -- Maximum height.
            timeout = 4000, -- Time a message is visible in the message window.
        },
        pager = { -- Options related to message window.
            height = 0.5, -- Maximum height.
        },
    },
})
