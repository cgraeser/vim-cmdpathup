" Vim global plugin for faster path navigation in command line
" Last Change:  2012-05-11
" Maintainer:   Carsten Gräser <graeser@mi.fu-berlin.de>
" License:      This file is placed in the public domain.

if exists("g:loaded_cmdpathup")
  finish
endif
let g:loaded_cmdpathup = 1


function! s:UnifyPath(p,type)
    let fullPath = fnamemodify(a:p,':p')
    let r = fnamemodify(fullPath, a:type)
    if (isdirectory(fullPath) && r[-1:]!='/' && len(r)>0)
        let r=r.'/'
    endif
    return r
endfunction


function! s:PathUp()
    let format=':~:.'

    " get line until cursor
    let p_cmd=getcmdline()[:(getcmdpos()-2)]

    " get string from first unescaped space
    let i=strridx(p_cmd, ' ')
    while i>0 && p_cmd[(i-1)]=='\'
        let i=strridx(p_cmd, ' ', i-1)
    endwhile
    let p_cmd=p_cmd[(i+1):]

    let p = fnamemodify(p_cmd,':p')
    let i = strridx(p,'/', len(p)-2)
    let p = ((i<0) && p!='/')?'':p[:(i)]
    let p = s:UnifyPath(p,format)

    " this computes the length counting multi-byte characters by one only
    let l = len(substitute(p_cmd, ".", "x", "g"))
    return repeat("\<bs>",l).p
endfunction


cmap <unique> <expr> <plug>CmdPathUp <sid>PathUp()

if !hasmapto('<plug>CmdPathUp', 'c')
    cmap <unique> <c-bs> <plug>CmdPathUp
endif

