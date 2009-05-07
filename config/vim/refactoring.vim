vmap \em :call ExtractMethod()<cr>
function! ExtractMethod() range
let name = inputdialog("Name of new method:")
'<
exe "normal O" . name ."();\<cr>\<esc>"
exe "normal Oprivate void " . name ."()\<cr>{\<esc>"
'>
exe "normal o}\<cr>"
endfunction 

