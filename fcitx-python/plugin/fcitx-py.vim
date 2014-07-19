" vim:set sts=2 sw=2 tw=0 et:
"
" fcitx-py.vim - fcitx controller

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

function! FcitxPySetup()
  call s:pyfile(s:PYPATH)

  function! FcitxPyGet()
    let flag = s:pyeval('fcitx_is_active()')
    return flag
  endfunction

  function! FcitxPySet(active)
    call s:pyeval('fcitx_set_active(' . a:active . ')')
  endfunction

  set imactivatefunc=FcitxPySet
  set imstatusfunc=FcitxPyGet
endfunction

if has('gui_running')
  augroup FcitxPy
    autocmd!
    autocmd GUIEnter * call FcitxPySetup()
  augroup END
elseif s:is_gui_term()
  call FcitxPySetup()
endif
