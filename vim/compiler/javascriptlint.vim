" from http://hail2u.net/blog/software/vim-settings-for-web-development.html
if exists("current_compiler")
  finish
endif

let current_compiler = "javascriptlint"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

" CompilerSet makeprg=jsl\ -nologo\ -nofilelisting\ -nosummary\ -nocontext\ -process\ %
CompilerSet makeprg=jsl\ --nologo\ --nofilelisting\ --nosummary\ %

CompilerSet errorformat=%f(%l):\ %m

let &cpo = s:cpo_save
unlet s:cpo_save
