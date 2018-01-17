let s:save_cpo = &cpoptions
set cpoptions&vim

let s:dir_separator   = fnamemodify('.', ':p')[-1 :]
let s:plugin_root_dir = expand('<sfile>:p:h:h')

function! fsac#start() abort
    if !exists('s:job') || job_status(s:job) !=# 'run'
        echom s:plugin_root_dir
        let l:fsac_path = fsac#path_join(['bin', 'fsautocomplete.exe'])
        let l:command = [ l:fsac_path ]
        let s:job = job_start(
            \ l:command,
            \ { 'out_cb': 'fsac#out_handler',
            \   'err_cb': 'fsac#err_handler' })
        let s:channel = job_getchannel(s:job)
        echom s:channel
    endif
endfunction

function! fsac#out_handler(channel, msg)
    echom a:msg
endfunction

function! fsac#sendLine(msg)
    call ch_sendraw(s:channel, a:msg)
    call ch_sendraw(s:channel, "\n")
endfunction

function! fsac#path_join(parts) abort
    if type(a:parts) == type('')
        let parts = [a:parts]
    elseif type(a:parts) == type([])
        let parts = a:parts
    else
        throw 'Unsupported type for joining paths'
    endif
    return join([s:plugin_root_dir] + parts, s:dir_separator)
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
