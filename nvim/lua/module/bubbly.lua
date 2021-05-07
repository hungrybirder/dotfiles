vim.g.bubbly_statusline = {
  'mode',

  'truncate',

  'path',
  'branch',
  'signify',

  'divisor',

  'lsp_status.messages',
  'lsp_status.diagnostics',
  'builtinlsp.current_function',
  -- 'builtinlsp.diagnostic_count',
  'progress',
  'filetype',
  -- 'total_buffer_number',
}

disable_bubbly_filetypes = { 'NvimTree', 'Outline', 'vim-plug', }

vim.g.bubbly_filter = {
  mode = disable_bubbly_filetypes,
  path = disable_bubbly_filetypes,
  branch = disable_bubbly_filetypes,
  signify = disable_bubbly_filetypes,
  progress = disable_bubbly_filetypes,
  filetype = disable_bubbly_filetypes,
  total_buffer_number = disable_bubbly_filetypes,
  lsp_status = {
    messages = disable_bubbly_filetypes,
    diagnostics = disable_bubbly_filetypes,
  },
  builtinlsp = {
    current_function = disable_bubbly_filetypes,
    diagnostic_count = disable_bubbly_filetypes,
  },
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

vim.g.bubbly_inactive_color = {
  background = 'darkgrey',
  foreground = 'foreground',
}

vim.g.bubbly_palette = {
  background = "#34343c",
  foreground = "#c5cdd9",
  black = "#3e4249",
  red = "#ec7279",
  green = "#a0c980",
  yellow = "#deb974",
  blue = "#6cb6eb",
  purple = "#d38aea",
  cyan = "#5dbbc1",
  white = "#c5cdd9",
  lightgrey = "#57595e",
  darkgrey = "#404247",
}
