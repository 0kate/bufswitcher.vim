function! bufswitcher#OpenBuffer()
  let current_line = getpos(".")[1]
  let target_buffer = s:buffers[current_line - 1]

  execute ":bd"
  execute ":b" . target_buffer
endfunction

function! bufswitcher#SwitchBuffer()
  if bufnr("$") == 1
    echo "You only have this buffer"
    return
  endif

  " let s:buffer s= nvim_list_bufs()
  let all_buffers = nvim_list_bufs()
  let s:buffers = []
  for buffer in all_buffers
    if buflisted(buffer)
      call add(s:buffers, buffer)
    endif
  endfor
  echo s:buffers

  let current_buffer = nvim_get_current_buf()
  let buffers_len = len(s:buffers)

  let window_opts = {'relative': 'editor',
                     \ 'row': 0,
                     \ 'col': (&columns / 2) - ((&columns / 2) / 2),
                     \ 'width': &columns / 2,
                     \ 'height': buffers_len }

  let switcher_buf = nvim_create_buf(v:false, v:true)
  let swithcer_win = nvim_open_win(switcher_buf, v:true, window_opts)

  let lineno = 1
  for buffer in s:buffers
    let buffer_name = bufname(buffer)
    if len(buffer_name) < 1
      let buffer_name = "[No Name]"
    endif

    let line = buffer_name
    if buffer == current_buffer
      let line = line . "\t\t<=="
    endif

    call setbufline(switcher_buf, lineno, line)
    let lineno = lineno + 1
  endfor

  setlocal buftype=nofile nobuflisted nomodifiable bufhidden=hide nonumber cursorline cc=0
  execute ":" . (index(s:buffers, "" . current_buffer) + 1)

  execute "nnoremap <buffer><cr> :call bufswitcher#OpenBuffer()<cr>"
endfunction
