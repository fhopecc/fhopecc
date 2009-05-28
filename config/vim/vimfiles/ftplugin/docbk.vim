" vim600: set foldmethod=marker:
" $Id: $
"
" Vim plugin to assist in editing DocBook documents.
" Last Change:  $Date: $
" Maintainer:   Cédric Bouvier <cbouvi@free.fr>
" License:      GNU General Public License
"
source $VIM/vimfiles/ftplugin/xml.vim
" Menu options: {{{1
menu &Plugin.DocBoo&k.-Sep1- :
" Section: sections and para {{{2
amenu &Plugin.DocBoo&k.Add\ Para<Tab>^P o<para>>
amenu &Plugin.DocBoo&k.Add\ Chapter<Tab>^C mxo<chapter id="">><title><ESC>o<para>><ESC>'xj$2F"a
amenu &Plugin.DocBoo&k.Add\ Section\ 1<Tab>^S,1 mxo<sect1 id="">><title><ESC>o<para>><ESC>'xj$2F"a
amenu &Plugin.DocBoo&k.Add\ Section\ 2<Tab>^S,2 mxo<sect2 id="">><title><ESC>o<para>><ESC>'xj$2F"a
amenu &Plugin.DocBoo&k.Add\ Section\ 3<Tab>^S,3 mxo<sect3 id="">><title><ESC>o<para>><ESC>'xj$2F"a
menu &Plugin.DocBoo&k.-Sep2- :

" Section: emphasis {{{2
imenu &Plugin.DocBoo&k.&Emphasis\ (strong)<Tab>^B <emphasis role="strong">
vmenu &Plugin.DocBoo&k.&Emphasis\ (strong)<Tab>^B "kc<emphasis role="strong"><C-R>k
imenu &Plugin.DocBoo&k.&Emphasis<Tab>^U <emphasis>
vmenu &Plugin.DocBoo&k.&Emphasis<Tab>^U "kc<emphasis><C-R>k

menu &Plugin.DocBoo&k.-Sep3- :

" Section: lists (itemized, ordered) {{{2
" Normal mode: add a list and its first item, or a single item {{{3
nmenu &Plugin.DocBoo&k.Itemized\ &List<Tab>^L o<itemizedlist>><listitem>><para>>       
nmenu &Plugin.DocBoo&k.&Ordered\ List<Tab>^O o<orderedlist>><listitem>><para>>       
amenu &Plugin.DocBoo&k.&Item<Tab>^* <listitem>><para>>       

" Visual mode: turn selected <para>s into a list (or series of items) {{{3
vmenu &Plugin.DocBoo&k.Itemized\ &List<Tab>^L :s/<para>/<listitem>\r&/g<CR>gv:s/<\/para>/&\r<\/listitem>/g<CR>'<O<itemizedlist\><ESC>'>jo</itemizedlist><ESC>gvjj=
vmenu &Plugin.DocBoo&k.&Ordered\ List<Tab>^O :s/<para>/<listitem>\r&/g<CR>gv:s/<\/para>/&\r<\/listitem>/g<CR>'<O<orderedlist\><ESC>'>jo</orderedlist><ESC>gvjj=
vmenu &Plugin.DocBoo&k.&Item<Tab>^* :s/<para>/<listitem>\r&/g<CR>gv:s/<\/para>/&\r<\/listitem>/g<CR>gvj=
" }}}1

" Key bindings {{{1
" Section: sections and para {{{2
"noremap <buffer> <C-P> :emenu Plugin.DocBook.Add\ Para<CR>
noremap <buffer> <C-C> :emenu Plugin.DocBook.Add\ Chapter<CR>
noremap <buffer> <C-S>1 :emenu Plugin.DocBook.Add\ Section\ 1<CR>
noremap <buffer> <C-S>2 :emenu Plugin.DocBook.Add\ Section\ 2<CR>
noremap <buffer> <C-S>3 :emenu Plugin.DocBook.Add\ Section\ 3<CR>

" Section: emphasis {{{2
"noremap <buffer> <C-B> :emenu Plugin.DocBook.Emphasis\ (strong)<CR>
noremap <buffer> <C-U> :emenu Plugin.DocBook.Emphasis<CR>
" Section: lists {{{2
noremap <buffer> <C-L> :emenu Plugin.DocBook.Itemized\ List<CR>
"noremap <buffer> <C-O> :emenu Plugin.DocBook.Ordered\ List<CR>
noremap <buffer> <C-*> :emenu Plugin.DocBook.Item<CR>
" }}}1
