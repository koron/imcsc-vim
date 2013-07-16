" vim:set sts=2 sw=2 tw=0 et:
" 
" ibus-py.vim

scriptencoding utf-8

function! s:is_enable()
  " Check version (and patch)
  if !(v:version == 703 && has('patch1248') || v:version >= 704)
    return 0
  end
  " Check python
  if !(has('python') || has('python3'))
    return 0
  end
  return 1
endfunction

if !s:is_enable()
  finish
end

let s:PYPATH = expand('<sfile>:p:r').'.py'

if has('python3')
  execute 'py3file '.s:PYPATH
  function! PyIbusGet()
    return py3eval('IBusPy.get()')
  endfunction
  function! PyIbusSet(active)
    return py3eval('IBusPy.set('.a:active.')')
  endfunction
else
  execute 'pyfile '.s:PYPATH
  function! PyIbusGet()
    return pyeval('IBusPy.get()')
  endfunction
  function! PyIbusSet(active)
    return pyeval('IBusPy.set('.a:active.')')
  endfunction
endif

function! s:init()
  set imactivatefunc=PyIbusSet
  set imstatusfunc=PyIbusGet
endfunction

function! s:isGuiTerm()
  " TODO: Check running on GUI term (ex. xfce4-term).
  return 1
endfunction

if has('gui_running')
  augroup PyIbus
    autocmd!
    autocmd FocusGained * call <SID>init()
  augroup END
elseif s:isGuiTerm()
  call <SID>init()
endif
