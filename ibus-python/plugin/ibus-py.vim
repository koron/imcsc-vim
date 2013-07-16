" vim:set sts=2 sw=2 tw=0 et:
" 
" ibus-py.vim

scriptencoding utf-8

function! s:is_enable()
  " Check version: 'imaf' and 'imsf' are available or not.
  if !(v:version == 703 && has('patch1248') || v:version >= 704)
    return 0
  end
  " Check python:
  if !(has('python3') || has('python'))
    return 0
  end
  return 1
endfunction

if !s:is_enable()
  finish
end

function! s:pyfile(path)
  if has('python3')
    execute 'py3file ' . a:path
  elseif has('python')
    execute 'pyfile ' . a:path
  else
    throw 'pyfile: python is not supported'
  end
endfunction

function! s:pyeval(str)
  if has('python3')
    return py3eval(a:str)
  elseif has('python')
    return pyeval(a:str)
  else
    throw 'pyeval: python is not supported'
  end
endfunction

function! s:is_gui_term()
  " TODO: Check running on GUI term (ex. xfce4-term).
  return 1
endfunction

let s:PYPATH = expand('<sfile>:p:r').'.py'

function! IBusPySetup()
  call s:pyfile(s:PYPATH)

  function! IBusPyGet()
    return s:pyeval('IBusPy.get()')
  endfunction

  function! IBusPySet(active)
    return s:pyeval('IBusPy.set('.a:active.')')
  endfunction

  set imactivatefunc=IBusPySet
  set imstatusfunc=IBusPyGet
endfunction

if has('gui_running')
  augroup IBusPy
    autocmd!
    autocmd GUIEnter * call IBusPySetup()
  augroup END
elseif s:is_gui_term()
  call IBusPySetup()
endif
