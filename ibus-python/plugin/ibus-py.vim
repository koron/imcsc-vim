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

if has('python3')
python3 << EOF
from gi.repository import IBus
class IBusPy:
    BUS = IBus.Bus()
    IC = IBus.InputContext.get_input_context(
            BUS.current_input_context(),
            BUS.get_connection())
    @staticmethod
    def ic():
        return IBusPy.IC
    @staticmethod
    def get():
        if IBusPy.ic().is_enabled():
            return 1
        else:
            return 0
    @staticmethod
    def set(v):
        if v:
            IBusPy.ic().enable()
        else:
            IBusPy.ic().disable()
        return 0
EOF
  function! IBusPyGet()
    return py3eval('IBusPy.get()')
  endfunction
  function! IBusPySet(active)
    return py3eval('IBusPy.set('.a:active.')')
  endfunction
else
python << EOF
from gi.repository import IBus
class IBusPy:
    BUS = IBus.Bus()
    IC = IBus.InputContext.get_input_context(
            BUS.current_input_context(),
            BUS.get_connection())
    @staticmethod
    def ic():
        return IBusPy.IC
    @staticmethod
    def get():
        if IBusPy.ic().is_enabled():
            return 1
        else:
            return 0
    @staticmethod
    def set(v):
        if v:
            IBusPy.ic().enable()
        else:
            IBusPy.ic().disable()
        return 0
EOF
  function! IBusPyGet()
    return pyeval('IBusPy.get()')
  endfunction
  function! IBusPySet(active)
    return pyeval('IBusPy.set('.a:active.')')
  endfunction
endif

function! s:init()
  set imactivatefunc=IBusPySet
  set imstatusfunc=IBusPyGet
endfunction

function! s:isGuiTerm()
  " TODO: Check running on GUI term (ex. xfce4-term).
  return 1
endfunction

if has('gui_running')
  call <SID>init()
elseif s:isGuiTerm()
  call <SID>init()
endif
