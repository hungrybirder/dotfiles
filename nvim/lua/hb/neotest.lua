require("neotest").setup({
    adapters = {
        require("neotest-plenary"),
        require("neotest-python")({
            dap = { justMyCode = false },
        }),
        require("neotest-go"),
        require("neotest-vim-test")({
            ignore_file_types = { "python", "vim", "lua", "go" },
        }),
    },
})

vim.api.nvim_command("command! -nargs=0 NeotestRun :lua require('neotest').run.run()<CR>")
vim.api.nvim_command("command! -nargs=0 NeotestStop :lua require('neotest').run.stop()<CR>")
vim.api.nvim_command("command! -nargs=0 NeotestAttach :lua require('neotest').run.attach()<CR>")
vim.api.nvim_command("command! -nargs=0 NeotestDebugNearest :lua require('neotest').run.run({strategy = 'dap'})<CR>")
vim.api.nvim_command("command! -nargs=0 NeotestRunFile :lua require('neotest').run.run(vim.fn.expand('%'))<CR>")
vim.api.nvim_command("command! -nargs=0 NeotestToggleSummary :lua require('neotest').summary.toggle()<CR>")
vim.api.nvim_command(
    "command! -nargs=0 NeotestJumpPrevFailed :lua require('neotest').jump.prev({ status = 'failed' })<CR>"
)
vim.api.nvim_command(
    "command! -nargs=0 NeotestJumpnextFailed :lua require('neotest').jump.next({ status = 'failed' })<CR>"
)
