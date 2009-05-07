" Vim compiler file
" Language:		Ruby Rant
" Function:		Syntax check and/or error reporting
" Maintainer:		fhopecc <fhope.tw@yahoo.com.tw>
" Info:			$Id: rant.vim,v 0.1, fhopecc modified at 2006-12-09
" Anon CVS:		See above site
" Release Coordinator:	fhopecc <fhope.tw@yahoo.com.tw>
" ----------------------------------------------------------------------------
"
" Changelog:
" 0.1:	initial release
"
" Contributors:
"
" Todo:
"
" Comments:
" Compiler pluging for rant
" ----------------------------------------------------------------------------

if exists("current_compiler")
  finish
endif
let current_compiler = "rant"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

" default settings runs script normally
" add '-c' switch to run syntax check only:
"
"   CompilerSet makeprg=ruby\ -wc\ $*
"
" or add '-c' at :make command line:
"
"   :make -c %<CR>
"
CompilerSet makeprg=rant\ $*

"A rant error message example;
"rant: [ERROR] in file `C:/vim/vim70/compiler/Rantfile', line 4:
"              NameError: undefined local variable or method `w' for main:Object

CompilerSet errorformat=
     \%Erant:\ [ERROR]\ in\ file\ `%f'\\,\ line\ %l:%.%#,
     \%C\ %\\+referenced\ in\ `%f'\\,\ line\ %l!,
     \file:///%f;\ 行號%l;\ 欄號%c;\ %m,
     \%C\ %\\+%m,
     \%Crant:\ [ERROR]\ %m,
     \%Erant:\ [ERROR]\ %m,
     \%Zrant\ aborted!,
     \(%.%#位置不明)%m,
     \%n)\ %m,%\\tat\ %.%#(%f:%l)%.%#,%ITests\ %m,
     \%E%f:%l:\ %m,
     \%+C%.%#,
     \%+Z%.%#,
     \%+G%.%#
     "\%E%f:%l:\ %m,%-Z%p^,%-C%.%#,%-G%.%#

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: nowrap sw=2 sts=2 ts=8 ff=unix:
