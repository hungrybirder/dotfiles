function! CloseQuickfixOrLocationListWindow()
  if getwininfo(win_getid())[0]['quickfix'] == 1
    if getwininfo(win_getid())[0]['loclist'] == 1
      lclose
      return
    else
      cclose
    endif
  endif
endfunction

nnoremap <silent> <ESC> :<C-U>call CloseQuickfixOrLocationListWindow()<CR>
