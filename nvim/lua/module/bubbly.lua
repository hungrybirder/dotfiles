vim.g.bubbly_statusline = {
  'mode',

  'truncate',

  'path',
  'branch',
  'signify',

  'divisor',

  'lsp_status.messages',
  'builtinlsp.current_function',
  'lsp_status.diagnostics',
  -- 'builtinlsp.diagnostic_count',
  'progress',
  'filetype',
  -- 'total_buffer_number',
}

vim.g.bubbly_colors = {
  default = 'red',

  mode = {
    normal = 'green', -- uses by default 'background' as the foreground color.
    insert = 'blue',
    visual = 'red',
    visualblock = 'red',
    command = 'red',
    terminal = 'blue',
    replace = 'yellow',
    default = 'white'
  },
  path = {
    readonly = { background = 'lightgrey', foreground = 'foreground' },
    unmodifiable = { background = 'darkgrey', foreground = 'foreground' },
    path = 'white',
    modified = { background = 'lightgrey', foreground = 'foreground' },
  },
  -- branch = 'purple',
  branch = 'cyan',
  signify = {
    added = 'green',
    modified = 'blue',
    removed = 'red',
  },
  paste = 'red',
  coc = {
    error = 'red',
    warning = 'yellow',
    status = { background = 'lightgrey', foreground = 'foreground' },
  },
  builtinlsp = {
    diagnostic_count = {
      error = 'red',
      warning = 'yellow',
    },
    current_function = 'purple',
  },
  filetype = 'blue',
  progress = {
    rowandcol = { background = 'darkgrey', foreground = 'foreground' },
    percentage = { background = 'darkgrey', foreground = 'foreground' },
  },
  tabline = {
    active = 'blue',
    inactive = 'white',
    close = 'darkgrey',
  },
  total_buffer_number = 'cyan',
  lsp_status = {
    messages = 'white',
    diagnostics = {
      error = 'red',
      warning = 'yellow',
      hint = 'white',
      info = 'blue',
    },
  },
}
