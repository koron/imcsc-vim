" vim:set sts=2 sw=2 tw=0 et:
"
" uim-ctlso.vim based on uimfep-vim.vim and uim-ctl.vim

scriptencoding utf-8

function! s:is_enable()
  " Check version (and patch)
  if !(v:version == 703 && has('patch1248') || v:version >= 704)
    return 0
  end
  return 1
endfunction

if !s:is_enable()
  finish
end

if exists("s:init")
  finish
endif
let s:init = 1

let s:dll = expand("<sfile>:p:h") . "/uim-ctl.so"
let s:direct_mode = ""
let s:enable_mode = ""

augroup UimHelper
  au!
  autocmd VimLeave * call libcall(s:dll, "unload", 0)
  " poll() does not work when dll is loaded before VimEnter.
  autocmd VimEnter * let s:err = libcall(s:dll, "load", s:dll)
  autocmd VimEnter * if s:err != "" | au! UimHelper * | endif
augroup END

function! s:GetProp()
  let buf = libcall(s:dll, "get_prop", 0)
  if buf =~ '^prop_list_update'
    let cur_method = matchstr(buf, 'action_imsw_\zs\w\+\ze\t\*')
    let current_mode = matchstr(buf, 'action_' . cur_method . '_\w*\ze\t\*')
    let direct_mode = matchstr(buf, 'action_' . cur_method . '_\%(direct\|latin\)')
    return [current_mode, direct_mode]
  endif
  return ["", ""]
endfunction

function! UimGet()
  let [current_mode, s:direct_mode] = s:GetProp()
  if s:direct_mode != "" && current_mode != s:direct_mode
    let s:enable_mode = current_mode
    return 1
  endif
  return 0
endfunction

function! UimSet(active)
  if s:direct_mode == ""
    return
  endif
  if a:active
    let mode = s:enable_mode
  else
    let mode = s:direct_mode
  endif
  call libcall(s:dll, "send_message", "prop_activate\n" . mode . "\n")
endfunction

set imactivatefunc=UimSet
set imstatusfunc=UimGet
