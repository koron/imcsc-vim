" vim:set sts=2 sw=2 tw=0 et:
"
" uimfep-vim.vim

scriptencoding utf-8

function! s:is_enable()
  " Check version (and patch)
  if !(v:version == 703 && has('patch1248') || v:version >= 704)
    return 0
  end
  " Disable for GUI.
  if has('gui_running')
    return 0
  endif
  if !exists('$UIM_FEP_GETMODE') || !exists('$UIM_FEP_SETMODE')
    return 0
  endif
  return 1
endfunction

if !s:is_enable()
  finish
end

function! UimGet()
  " TODO: debug.
  let lines = readfile($UIM_FEP_GETMODE, '', 1)
  let uim_enabled = lines[0] + 0
  return uim_enabled != 0 ? 1 : 0
endfunction

function! UimSet(active)
  " TODO: debug.
  let lines = [ a:active ? 1 : 0 ]
  call writefile(lines, $UIM_FEP_SETMODE)
endfunction

set imactivatefunc=UimGet
set imstatusfunc=UimSet
