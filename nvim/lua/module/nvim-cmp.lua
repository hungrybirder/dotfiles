local npairs = require('nvim-autopairs')
npairs.setup({
  check_ts = true,
  disable_filetype = { "TelescopePrompt" },
})

-- From: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
local has_words_before = function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  return not vim.api.nvim_get_current_line():sub(1, cursor[2]):match('^%s$')
end

local lspkind = require('lspkind')
local cmp = require'cmp'
cmp.setup{
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = {
    { name = 'nvim_lsp'},
    { name = 'path'},
    { name = 'nvim_lua'},
    { name = 'vsnip'},
    -- { name = 'luasnip'},
    { name = 'calc'},
    { name = 'emoji'},
    { name = 'tags'},
    { name = 'path'},
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = lspkind.presets.default[vim_item.kind]
       -- set a name for each source
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        -- luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        -- latex_symbols = "[Latex]",
        vsnip = "[Vsnip]",
        tags = "[Tag]",
      })[entry.source.name]
      return vim_item
    end
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
	  ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    -- ['<CR>'] = cmp.mapping.confirm({
    --   behavior = cmp.ConfirmBehavior.Replace,
    --   select = false,
    -- }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n', true)
      elseif has_words_before() and vim.fn['vsnip#available']() == 1 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-expand-or-jump)', true, true, true), '', true)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function()
      if vim.fn.pumvisible() == 1 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n', true)
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-jump-prev)', true, true, true), '', true)
      end
    end, { 'i', 's' }),
  },
}

-- From: https://github.com/windwp/nvim-autopairs
-- you need setup cmp first put this after cmp.setup()
require("nvim-autopairs.completion.cmp").setup({
  map_cr = true, --  map <CR> on insert mode
  map_complete = true, -- it will auto insert `(` after select function or method item
  auto_select = true -- automatically select the first item
})
