" Vim compiler file
" Compiler:	Deno JS
" Maintainer:	...
" Last Change:	...

if exists("current_compiler")
  finish
endif
let current_compiler = "ncdeno"
let s:keepcpo= &cpo
set cpo&vim

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=ncdeno

CompilerSet errorformat=
CompilerSet errorformat+=%A%t%*\\w[%*[^]]]:\ %m
CompilerSet errorformat+=%C\ %#-->\ %f:%l:%c
CompilerSet errorformat+=%C%[0-9\ ]%\\+\\|%.%#
CompilerSet errorformat+=%C
CompilerSet errorformat+=%C\ %#\=\ hint:\ %m
CompilerSet errorformat+=%Z\ %#docs:\ %m

let &cpo = s:keepcpo
unlet s:keepcpo

