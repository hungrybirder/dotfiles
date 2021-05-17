local lspsaga = require 'lspsaga'

lspsaga.init_lsp_saga{
  code_action_keys = {
    quit = '<esc>',
    exec = '<CR>',
  },
  code_action_prompt = {
    enable = true,
    sign = true,
    sign_priority = 20,
    virtual_text = false,
  },
}
