-- - Some variables are supported:
--   - ${file}: Active filename
--   - ${fileBasename}: The current file's basename
--   - ${fileBasenameNoExtension}: The current file's basename without extension
--   - ${fileDirname}: The current file's dirname
--   - ${fileExtname}: The current file's extension
--   - ${relativeFile}: The current file relative to getcwd()
--   - ${relativeFileDirname}: The current file's dirname relative to getcwd()
--   - ${workspaceFolder}: The current working directory of Neovim
--   - ${workspaceFolderBasename}: The name of the folder opened in Neovim
local dap = require("dap")

dap.adapters.cpp = {
    type = "executable",
    attach = { pidProperty = "pid", pidSelect = "ask" },
    command = "lldb-vscode",
    env = { LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES" },
    name = "lldb",
}

dap.configurations.cpp = {
    {
        type = "cpp",
        name = "Launch",
        request = "launch",
        program = "${workspaceFolder}/${relativeFileDirname}/build/${fileBasenameNoExtension}",
        args = args,
        cwd = vim.fn.getcwd(),
        environment = {},
        externalConsole = true,
        MIMode = mi_mode or "lldb",
        MIDebuggerPath = mi_debugger_path,
    },
}
