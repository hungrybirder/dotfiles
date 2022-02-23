local dap_py = require("dap-python")
dap_py.test_runner = "pytest"
dap_py.setup("~/.virtualenvs/debugpy/bin/python")
