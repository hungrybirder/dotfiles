local dap_py = require("dap-python")
dap_py.test_runner = "pytest"
dap_py.setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
