local remap = vim.api.nvim_set_keymap
local npairs = require('nvim-autopairs')

npairs.setup({
  check_ts = true,
  disable_filetype = { "TelescopePrompt" },
})

require'compe'.setup {
  enabled = true,
  autocomplete = true;
  debug = false;
  min_length = 1;
  -- preselect = 'enable';
  preselect = 'always';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true,
    buffer = true,
    calc = true,
    vsnip = true,
    nvim_lsp = true,
    nvim_lua = true,
    spell = true,
    tags = true,
    snippets_nvim = true,
    ultisnips = true,
    emoji = {
      filetypes={"markdown", "text"},
    },
  },
}

_G.MUtils= {}

vim.g.completion_confirm_key = ""
MUtils.completion_confirm=function()
  if vim.fn.pumvisible() ~= 0  then
    if vim.fn.complete_info()["selected"] ~= -1 then
      return vim.fn["compe#confirm"](npairs.esc("<cr>"))
    else
      return npairs.esc("<cr>")
    end
  else
    return npairs.autopairs_cr()
  end
end

-- remap('i', '<CR>', [[compe#confirm('<CR>')]], {
--   expr = true,
--   silent = true,
-- })
--
remap('i' , '<CR>','v:lua.MUtils.completion_confirm()', {
    expr = true,
    noremap = true,
})
remap('i', '<C-Space>', [[compe#complete()]], {
    expr = true,
    silent = true,
})
remap('i', '<C-d>', [[compe#close('<C-e>')]], {
    expr = true,
    silent = true,
})
remap('i', '<C-f>', [[compe#scroll({ 'delta': +4 })]], {
  expr = true,
  silent = true,
})
remap('i', '<C-b>', [[compe#scroll({ 'delta': -4 })]], {
  expr = true,
  silent = true,
})

-- for tab
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

_G.MUtils.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t'<C-n>'
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t'<Plug>(vsnip-expand-or-jump)'
  elseif check_back_space() then
    return t'<Tab>'
  else
    return vim.fn['compe#complete']()
  end
end

_G.MUtils.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t'<C-p>'
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t'<Plug>(vsnip-jump-prev)'
  else
    return t'<S-Tab>'
  end
end

remap("i", "<Tab>", "v:lua.MUtils.tab_complete()", { expr = true, silent = true, })
remap("s", "<Tab>", "v:lua.MUtils.tab_complete()", { expr = true, silent = true, })
remap("i", "<S-Tab>", "v:lua.MUtils.s_tab_complete()", { expr = true, silent = true, })
remap("s", "<S-Tab>", "v:lua.MUtils.s_tab_complete()", { expr = true, silent = true, })
