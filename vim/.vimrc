"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" FIRST:  here are some commands to help 'debug' option settings and where
""         they may have been 'set'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :scriptnames			shows a list of scripts that have been loaded (& from where)
" :verbose 'option'?	to find the current value, and from where it was set
"
" For more see:  http://vim.wikia.com/wiki/Debug_unexpected_option_settings


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" MAIN Setting(s)
let mapleader = "\\"
"" NOTE:  the 'nocompatible' option automatically adjusts many other options
""        do it first, and only this once (defaults to off, but good to have)
set nocompatible
" This option causes the editer to change options based on the first N lines
" of a text file (like a "sh'bang" line).  Disable it for security & safety
set modelines=0

" Prevent the storing of file marks (0-9 and A-Z)
" NOTE:  I'm adding 'f0' BECAUSE through trial and error, I discovered that
"        VIM will **automatically** load LOTS of files behind the scenes
"        when "file marks" are saved in viminfo.  The automatically loaded
"        files are "unlisted" so the only way to notice them is `:ls!`
"        This greatly slows down the editor when the loaded buffers get
"        into the hundreds (and even low thousands)
"
"        this does NOT affect the lowercase a-z marks, they are still saved
"
"        default 'viminfo': '100,<50,s10,h,rA:,rB:
"
"        (also upping some of the limits)
"
set viminfo='999,<500,s100,h,rA:,rB:,f0

" Most of \v... is for managing the VIMRC or VIMINFOFILE
nnoremap <leader>v    <nop>
nnoremap <leader>ve   :tabedit $MYVIMRC<cr>
nnoremap <leader>vr   :so $MYVIMRC<cr>
nnoremap <leader>vi   <nop>
nnoremap <leader>vif  <nop>
nnoremap <leader>vifn :set viminfofile=NONE<cr>
nnoremap <leader>vifd :set viminfofile&<cr>
nnoremap <leader>vif? :set viminfofile?<cr>
nnoremap <leader>vif= :set viminfofile=
nnoremap <leader>vifr :rviminfo<cr>
nnoremap <leader>vifw :wviminfo<cr>
nnoremap <leader>vc   <nop>
nnoremap <leader>vcl  :call SetupViminfoClean()<cr>

" BUT some is for vertical stuff
nnoremap <expr> <leader>vb   ':vert sb '
nnoremap        <leader>vn   :vnew<cr>
nnoremap        <leader>vt   <nop>
nnoremap        <leader>vtt  :vert term<cr>
nnoremap <expr> <leader>vtr  ':vert term ++close '

function! SetupViminfoClean() abort
    let vicur = &viminfofile
    if l:vicur == 'NONE'
        echoerr "Already doing VI editing ?!?"
        interrupt()
    endif

    if l:vicur == ''
        if has('win32')
            let vicur = expand('~') . '\_viminfo'
        else
            let vicur = expand('~') . '/.viminfo'
        endif
    endif
    set viminfofile=NONE
    let @q = 'd}knzz'
    exe 'edit' l:vicur
    call feedkeys('/\v\n\>.{-}(\\nerd_tree_|\\temp\\|fugitive:|\[bufexplorer\]|\\controlp$|diffpanel_\d|undotree_\d)' . "\n")
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" This bit of magic will force this file to reload every time it is saved
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup myvimrc
	au!
	""  NOTE:  currently I don't have a ".gvimrc file, so I have commented that part out
	""au bufwritepost $MYVIMRC,$MYGVIMRC so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
	au bufwritepost $MYVIMRC so $MYVIMRC
augroup end




" Customized versions of the 'default' settings "{{{
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" from a 8.2.1-2735 default install _vimrc


""
"" My take on the settings contained within '$VIMRUNTIME/defaults.vim'
""     (which is loaded when no other vimrc file is found)
""

" The default vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2020 Sep 30
"
" This is loaded if no vimrc file was found.
" Except when Vim is run with "-u NONE" or "-C".
" Individual settings can be reverted with ":set option&".
" Other commands can be reverted as mentioned below.

" When started as "evim", evim.vim will already have done these settings.
"if v:progname =~? "evim"
"  finish
"endif

" Bail out if something that ran earlier, e.g. a system wide vimrc, does not
" want Vim to use these default values.
"if exists('skip_defaults_vim')
"  finish
"endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
"if &compatible
"  set nocompatible
"endif

" When the +eval feature is missing, the set command above will be skipped.
" Use a trick to reset compatible only when the +eval feature is missing.
"silent! while 0
"  set nocompatible
"silent! endwhile

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=5000	" keep 200 lines of command line history
set ruler			" show the cursor position all the time
set showcmd			" display incomplete commands
set wildmenu		" display completion matches in a status line

set timeout         " activates BOTH time outs:  ':mappings' and 'key codes'
set ttimeoutlen=50  " 'key code' time out length (for <ESC> and <ALT> which are multi-code keys)
                    " The above '50' solves the delay after pressing Esc (default is 100ms)
set timeoutlen=2000 " ':mappings' time out length (one more sec than default of 1000)

" Show @@@ in the last line if it is truncated.
if version >= 800
	set display=truncate
endif

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
"set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Set this up for all options (default is just "bin,octal,hex")
if version < 800
	set nrformats=alpha,octal,hex
else
	set nrformats=alpha,bin,octal,hex
endif


" Default guioptions:  egmrLtT
" NOTE:  the default vimrc file will remove 't' on Win32
"   e: pretty tabs (vs ascii tabs)
"   g: grey out inactive menu items
"   m: menu bar is present
"   r: right-hand scroll bar is present
"   L: left-hand scroll bar is present when vert split exists
"   t: include tear off menus
"   T: include toolbar
" I disable most of the above just to save screen real-estate
" I don't need the typical menu/tool bars or fancy tabs
" Regarding the scroll bars... I hardly use them, but they provide visual "clues"
set guioptions=

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>
" To understand more see:  ":help i_CTRL-G_u"
" Do the same for <C-W>, see:  http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U
inoremap <C-W> <C-G>u<C-W>


" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
" Only xterm can grab the mouse events when using the shift key, for other
" terminals use ":", select text and press Esc.
if has('mouse')
  if &term =~ 'xterm'
    set mouse=a
  else
    set mouse=nvi
  endif
endif

" Only do this part when Vim was compiled with the +eval feature.
if 1

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on
  " NOTE: down below 'filetype' is disabled for Vundle and re-enabled

  " Put these in an autocmd group, so that you can revert them with:
  " ":augroup vimStartup | au! | augroup END"
  augroup vimStartup
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

  augroup END

endif

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
  " Revert with ":syntax off".
  "syntax on

  "" For an explanation of ':syntx on' -VS- ':syntax enable', and why I have
  "" the 'if', see:  https://stackoverflow.com/a/33380495/5844631
  if !exists("g:syntax_on")
    syntax enable
  endif

  " I like highlighting strings inside C comments.
  " Revert with ":unlet c_comment_strings".
  let c_comment_strings=1
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif



""
"" My take on the settings contained within '$VIMRUNTIME/vimrc_example.vim'
""     (which is loaded by the default vimrc, which is used when no other vimrc is found)
""

" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2019 Dec 17
"
" To use it, copy it to
"	       for Unix:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"	 for MS-Windows:  $VIM\_vimrc
"	      for Haiku:  ~/config/settings/vim/vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings, bail
" out.
"if v:progname =~? "evim"
"  finish
"endif

" Get the defaults that most users want.
"source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if empty(glob(expand('~/.vim/backupdir')))
    call mkdir(expand('~/.vim/backupdir'), 'p')
  endif
  if has('win32')
    set backupdir=~/.vim/backupdir,$TEMP,c:/tmp,c:/temp
  else
    set backupdir=~/.vim/backupdir,~/tmp
  endif
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
                    " create .<filename>.un~ files persist undo chains
    if empty(glob(expand('~/.vim/undodir')))
      call mkdir(expand('~/.vim/undodir'), 'p')
    endif
    if has('win32')
      set undodir=~/.vim/undodir,$TEMP,c:/tmp,c:/temp
    else
      set undodir=~/.vim/undodir,~/tmp
    endif
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Put these in an autocmd group, so that we can delete them easily.
"augroup vimrcEx
"  au!
"
"  " For all text files set 'textwidth' to 78 characters.
"  autocmd FileType text setlocal textwidth=78
"augroup END

nnoremap <leader>t   <nop>
nnoremap <leader>tw? :set textwidth?<cr>
nnoremap <leader>tw& :set textwidth&<cr>
nnoremap <leader>tw<space> :set textwidth=
nnoremap <expr> <leader>tww ":<c-u>set textwidth=" . v:count . "<cr>"
" Add optional packages.
"
" NOTE:  this should be superceeded by the "chrisbra/matchit" plugin managed
"        by my plugin manager (which is upstream from the built-in one)
"
""    " The matchit plugin makes the % command work better, but it is not backwards
""    " compatible.
""    " The ! means the package won't be loaded right away but when plugins are
""    " loaded during initialization.
""    if has('syntax') && has('eval')
""      packadd! matchit
""    endif


" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This bit is the default '_vimrc' file...
" (it includes 'vimrc_example.vim' which in turn includes 'defaults.vim')

"" Vim with all enhancements
"source $VIMRUNTIME/vimrc_example.vim

"" Use the internal diff if available.
"" Otherwise use the special 'diffexpr' for Windows.
"if &diffopt !~# 'internal'
"  set diffexpr=MyDiff()
"endif
"function MyDiff()
"  let opt = '-a --binary '
"  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
"  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
"  let arg1 = v:fname_in
"  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
"  let arg1 = substitute(arg1, '!', '\!', 'g')
"  let arg2 = v:fname_new
"  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
"  let arg2 = substitute(arg2, '!', '\!', 'g')
"  let arg3 = v:fname_out
"  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
"  let arg3 = substitute(arg3, '!', '\!', 'g')
"  if $VIMRUNTIME =~ ' '
"    if &sh =~ '\<cmd'
"      if empty(&shellxquote)
"        let l:shxq_sav = ''
"        set shellxquote&
"      endif
"      let cmd = '"' . $VIMRUNTIME . '\diff"'
"    else
"      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
"    endif
"  else
"    let cmd = $VIMRUNTIME . '\diff'
"  endif
"  let cmd = substitute(cmd, '!', '\!', 'g')
"  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
"  if exists('l:shxq_sav')
"    let &shellxquote=l:shxq_sav
"  endif
"endfunction

"}}}


" Other settings that should be right at the top "{{{

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" References:
""
""  Nice 'Coming home to Vim' article: http://stevelosh.com/blog/2010/09/coming-home-to-vim/
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" tame searching/moving settings
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v
set ignorecase		" use case insensitive searching by default
set smartcase		" however, if a capital letter was entered, go back to case SENSitive
set showmatch		" briefly highlight the matching 'bracket' (i.e. '[]','()','{}',...)
nnoremap <leader><space> :nohl<cr>
nnoremap <leader>rr :redraw!<cr>

" Borrow <Enter> in normal mode to just highlight the current word
function! HighlightText(text)
    if v:count == 0
        let rex = '\v' . VimRxEscape(a:text)
    else
        let rex = '\v%(^|<)' . VimRxEscape(a:text) . '%(>|$)'
    endif
    let @/ = l:rex
    echo '/'.@/
    call histadd("search", l:rex)
    set hls
endfunction
nnoremap <silent> <leader>h  <nop>
nnoremap <silent> <leader>hh :call HighlightText(expand("<cword>"))<cr>
nnoremap <silent> <leader>hH :call HighlightText(expand("<cWORD>"))<cr>
xnoremap <silent> <leader>hh :call HighlightText(VisualSelection())<cr>

""
"" For formatting:  gq
""
" :h fo-table
"
"      a    Automatic formatting of paragraphs every time text is inserted/deleted
"
"      t    Auto-wrap text using 'textwidth'
"      c    Auto-wrap comments using 'textwidth', inserting comment leader automatically.
"
"      r    Automatically insert comment leader after <Enter> from Insert mode
"      o    Automatically insert comment leader after 'O' or 'o' from Normal mode
"
"      n    Recognize numbered lists  (does not play nice with '2')
"           (note:  uses 'formatlistpat' to identify lists)
"      2    When formatting, use 2nd line of paragraph to pick indent level
"
"      l    Break long lines that were long before entering insert mode
"      j    Join lines "smartly" - i.e. removing comment leader
"
"  homemade:
"      w    'all' auto-wrapping  (i.e. both 't' and 'c')
"
""
""  current 'fo':  jcroql
""
nnoremap <leader>fo   <nop>
nnoremap <leader>foh  <nop>
nnoremap <leader>fohh :h fo-table<cr>
nnoremap <expr> <leader>fo<space> ':set fo=' . &fo
nnoremap <leader>fo?  :set fo?<cr>
nnoremap <leader>fo&  :set fo&<cr>:echo "formatoptions now: " . &fo<cr>
nnoremap <leader>foa  :set fo+=a<cr>:echo "formatoptions now: " . &fo<cr>
nnoremap <leader>fot  :set fo+=t<cr>:echo "formatoptions now: " . &fo<cr>
nnoremap <leader>foc  :set fo+=c<cr>:echo "formatoptions now: " . &fo<cr>
nnoremap <leader>for  :set fo+=r<cr>:echo "formatoptions now: " . &fo<cr>
nnoremap <leader>foo  :set fo+=o<cr>:echo "formatoptions now: " . &fo<cr>
nnoremap <leader>fon  :set fo+=n<cr>:echo "formatoptions now: " . &fo<cr>
nnoremap <leader>fo2  :set fo+=2<cr>:echo "formatoptions now: " . &fo<cr>
nnoremap <leader>fol  :set fo+=l<cr>:echo "formatoptions now: " . &fo<cr>
nnoremap <leader>foj  :set fo+=j<cr>:echo "formatoptions now: " . &fo<cr>
nnoremap <leader>fow  :set fo+=tc<cr>:echo "formatoptions now: " . &fo<cr>
nnoremap <leader>foz  <nop>
nnoremap <leader>foza :set fo-=a<cr>:echo "formatoptions now: " . &fo<cr>
nnoremap <leader>fozt :set fo-=t<cr>:echo "formatoptions now: " . &fo<cr>
nnoremap <leader>fozc :set fo-=c<cr>:echo "formatoptions now: " . &fo<cr>
nnoremap <leader>fozr :set fo-=r<cr>:echo "formatoptions now: " . &fo<cr>
nnoremap <leader>fozo :set fo-=o<cr>:echo "formatoptions now: " . &fo<cr>
nnoremap <leader>fozn :set fo-=n<cr>:echo "formatoptions now: " . &fo<cr>
nnoremap <leader>foz2 :set fo-=2<cr>:echo "formatoptions now: " . &fo<cr>
nnoremap <leader>fozl :set fo-=l<cr>:echo "formatoptions now: " . &fo<cr>
nnoremap <leader>fozj :set fo-=j<cr>:echo "formatoptions now: " . &fo<cr>
nnoremap <leader>fozw :set fo-=tc<cr>:echo "formatoptions now: " . &fo<cr>

""
"" Search for selected text, forwards or backwards.
"" (from https://vim.fandom.com/wiki/Search_for_visually_selected_text)
"" NOTE:  I've changed it to pre-pend "\v" to the search so that it is VERY MAGIC
""  WHY:  so that when I pull up the search history, and copy the search -- I can use it with PCRE engines as-is
""   SO:  therefore, I have to escape all the "very magic" characters.  One of those characters
""        has to be escaped EVEN in the string argument to `escape()`:  the pipe or branch, "|"
""        (this is so weird, even the backslash does not need to be escaped
""
""       branching chars:           '|', '&'
""       various anchors:           '^', '$', '%'
""       any char & repeats:        '.', '*', '+', '?', '=', '{'
""       char class & slashes:      '[', '\', '/'
""       groupings & zero-width:    '(', ')', '@'
""       word boundaries:           '<', '>'
""
function! VimRxEscape(val)
    return escape(a:val, '()[{?*+|^$.&~%=\/@<>')
endfunction

function! PerlRxEscape(val)
    "" #
    "" # From Python 3.10 re.escape() source:
    "" #      _special_chars_map = {i: '\\' + chr(i) for i in b'()[]{}?*+-|^$\\.&~# \t\n\r\v\f'}
    "" #
    return escape(a:val, '()[{?*+|^$.&~#\')
endfunction

function! ToLinuxVARIfExists(match)
    let env = environ()
    let name = a:match[1:-2]
    if exists('l:env[l:name]')
        return '${' . l:name . '}'
    endif
    return a:match
endfunction

function! VimCmdEscape(val)
    let line = a:val
    if ! has('win32')
        "" # NOTE:  why didn't this work?
        " let line = substitute(l:line, '\v\%(\w+)\%', ToLinuxVARIfExists, 'g')
        let line = substitute(l:line, '\v(\%\w+\%)', '\=ToLinuxVARIfExists(submatch(1))', 'g')
    endif
    return escape(l:line, "#%!")
endfunction

function! CygEscape(val)
    let rv = a:val
    " For Cygwin we need to follow Linux-like cmd-line quoting:
    " - each ' becomes '\'' (to preserve as part of the parameter)
    let rv = substitute(l:rv, "'", "'\\\\''", 'g')
    " - each " becomes '"' (to preserve as part of the parameter)
    let rv = substitute(l:rv, '\v("+)', "'\\1'", 'g')
    " - each ^ becomes '\\' (converting cmd-escape-char to bash-escape-char)
    let rv = substitute(l:rv, '\v\^', "'\\\\\\\\'", 'g')

    " DISABLED
    " " - each * becomes \* (to prevent globbing)
    " let rv = substitute(l:rv, '*', '\\*', 'g')

    return l:rv
endfunction

function! CmdEscape(val)
    "
    " NOTE: CMD's escape character is ^, so we escape using that character
    "       and any pre-existing ^ chars also need to be escaped, with a 2nd ^ char
    "
    "       Documentation says that CMD's escape character will work with:
    "       (see:  https://ss64.com/nt/syntax-esc.html#escape)
    "                &\<>^|
    "
    "       Through experimentation, it appears Vim **ITSELF** will apply
    "       CMD's escape operator for the following additional characters:
    "                ()"@
    "       (  the following where observed to be escaped by VIM:  ()"^|@  )

    "       currently, the only other characters we are handling involve
    "       piping commands together & escape itself
    "
    return substitute(a:val, '\v([|^])', '^\1', 'g')
endfunction

"" for %s in (semsrv) do @(sc query %s | ag "^S|STATE")

function! CmdPipeEscape(line)
    " NOTE:  there is an **ODD** side-effect of the CMD behavior of
    "        launching TWO shells when there are two '|' (pipes)
    "        see:  https://ss64.com/nt/syntax-esc.html#pipeline
    "   SO:  if the user's cmd (l:line) contains an escaped pipe,
    "        we need to *double* escape it
    "        (non-escaped pipes can be left alone)
    return substitute(a:line, '\v\^\|', '^^^|', 'g')
    ""
    "" PS:  Here's an example that is not currently handled:
    ""        TWO levels of PIPEing:
    ""      (for /f %f in ('git ... ^^^| tr "/" "\\\\"') do @(echo %f)) | wc
    ""
    ""        which when getting captured adds our own extra level (now Three):
    ""      ((for /f %f in ('git ... ^^^| tr "/" "\\\\"') do @(echo %f)) | wc) 2>&1 | tee -ai out.txt
    ""
endfunction

function! WatchCmdEscape(val)
    "" #
    "" # This function also performs VimCmdEscape() on the passed in value:
    "" #    - VimCmdEscape : to get out of VIM unmolested
    "" #    - The rest ...
    "" #        - to get out of `watch` unmolested
    "" #        - for dbl-quotes since we surround it all by double quotes
    "" #
    "" # Working on getting the "quoting" right for passing CMD's *through* GNU `watch`:
    "" #
    "" #    Src:            for %s in (svcname) do @(sc query %s | ag "^S|STATE")
    "" #
    "" #   into:  cmd /c '"'for \%s in (svcname) do @(sc query \%s | ag '""'^^S^|STATE'""')'"'
    "" #
    "" # HOWEVER:  this transormation does NOT work for the following command:
    "" #
    "" #    Src:            toolname runsqlcmd "select * from table"
    "" #
    "" #           more digging is needed to figure out what is going on
    "" #

    "" The following cmd:
    ""
    ""      sqltool sql "select top 30 ... from V_SERVER_LOG where field like '%expr%';"
    ""
    "" Should become the following Watch command, which works:
    ""
    ""      watch cmd /c     sqltool sql '"'select top 30 ... from V_SERVER_LOG where field like '\''%expr%'\'';'"'
    ""

    " NOTE: This WHole function exists to solve a special case:
    "
    "   because we pass a string into `CMD` (through `watch`),
    "   the whole entire user command must be surrounded by DBL quote
    "   characters, which engages CMD's command-parsing like we have
    "   on the actual command line itself.
    "
    "   normally with Vim's :! command, Vim parses the arguments on Vim's command line,
    "   and passed them into a raw Win32 CreateProcess bypassing CMD's string parsing.
    "
    " NOTE: my \e[pl]l mappings below do NOT have this problem.
    "
    "   They invoke:     :!start cmd /c ...
    "   Here we invoke:  :term watch cmd /c ...
    "
    "   For the \e[pl]l mappings we surround the user's command (the current line)
    "   with paranthesis and then quotes:     "(<line>)"
    "   AND IT DOES NOT MATTER if the <line> contains string literals w/ special chars!!!
    "   I  now think this is an artifact of how `start` processes it's own cmd-line
    "   and I bet it does NOT engage CMD's command-processing, much like how Vim's :!
    "   must be avoiding it.
    "
    " SO:   we need to handle CMD special characters when they appear in string literals
    "       we are TRUSTING that special characters OUTSIDE of string literals are there
    "       on purpose by the user, and we should leave them alone.
    "
    "
    let rv = a:val
    let Repl = {m -> '"'.CmdEscape(m[1]).'"'}
    " Expression for literal strings -- contents of each one passed into lambda for internal cleaning
    let rv = substitute(l:rv, '\v"(%(\\"|[^"])*)"', Repl, 'g')
    "" #
    "" # TODO:  fix this!!!   I have to figure out how to "generically" quote ANY command
    "" #        as it stands, I have two commands that highlight my problem:
    "" #            * one of them only works if the below `if`s main clause executes
    "" #            * the other only works if the `else` clause executes
    "" #
    if 0
        "" # allows:   toolname runsqlcmd "select * from table"
        let rv = '(' . l:rv . ')'
    else
        "" # allows:   for %s in (semsrv) do @(sc query %s | ag "^S|ST ?ATE")
        let rv = shellescape(l:rv)
    endif
    return l:rv
endfunction

vnoremap <silent> * :<C-U> let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
                   \gvy/\v<C-R>=&scs?'':&ic?'\c':'\C'<CR>
                   \<C-R><C-R>=substitute(VimRxEscape(@"), '\s\+', '\\s+', 'g')<CR><CR>
                   \gVzv:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U> let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
                   \gvy?\v<C-R>=&scs?'':&ic?'\c':'\C'<CR>
                   \<C-R><C-R>=substitute(VimRxEscape(@"), '\s\+', '\\s+', 'g')<CR><CR>
                   \gVzv:call setreg('"', old_reg, old_regtype)<CR>

" NOTE:  this will affect the behavior of the "unnamed" register and which
"        actual REGister gets the stuff that goes into the "unnamed" register
"  Deciding to disable this - I think I got used to the VIM default register NOT being the OS clipboard
"  AND instead...   only choosing when to interact with the clipboard
"set clipboard=unnamed	" Use the OS clipboard by default (on versions compiled with `+clipboard`)
""
"" This is for controlling whether VIM forces good behavior into already
"" existing TXT files that may have to be edited by other editors that
"" engage in horrific behavior ;)
""    Is '\n' a "terminator" or a "separator" ??   that is the question.
"" see:  https://stackoverflow.com/a/16224292/5844631
""
"set noendofline
if version >= 800
	set nofixendofline
endif
" "}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" This section is about making my BASH shell aliases available to '!' commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings & settings related to :! and :shell "{{{
"" NOTE:  see the docs for "Bash Startup Files" - bash looks for this env
""        whenever a shell is launched NON-interactively (which vim does ;)
nnoremap <leader>shcf? :set shellcmdflag?<cr>
nnoremap <leader>shcf& :set shellcmdflag&<cr>

if has('macunix')
	" MacOS now uses ZShell - and the zshell mechanism uses ZDOTDIR env var
	let $ZDOTDIR = expand("~/.vim")
	" Still keep the Bash mechanism just in case Bash shell is used on MacOS
	let $BASH_ENV = expand("~/.vim/.bashrc")
	set pyxversion=2
    " i: 'interactive' to get all the aliases
    "set shellcmdflag=-ic
    " NOTE:  I *wanted* to enable interactive shells all the time on MacOS, but...
    "        for some reason VIM launched in my iTerm was crashing!?!  I do not know why :(
    "        I do know, it was THIS LINE -- setting the 'shellcmdflag' option.
    "        So for now -- I will create a mapping to add interactive :D
    nnoremap <leader>shcfi :set shellcmdflag=-ic<cr>
elseif ! has('win32')
	let $BASH_ENV = expand("~/.vim/.bashrc")
	set shellcmdflag=-l\ -c
endif
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Settings related to Fonts "{{{

" This bit "adds on" to what the FontSize plugin provides
" (but is stand-alone and does not need it at all,
"  so here instead of the fontsize options section)
nnoremap <leader><leader>? :set guifont?<cr>

" This bit was inspired by the answer here:  https://stackoverflow.com/a/3316521/5844631
nnoremap <leader>rf :echom 'No font mappings available'<cr>

let s:default_guifont=''
if has('gui_win32')
    let s:default_guifont='Lucida_Console:h8:cANSI:qDRAFT'
elseif has('gui_macvim')
    let s:default_guifont='Menlo-Regular:h11'
elseif has('gui_gtk2') && !has('unix')
    let s:default_guifont='Consolas:h11:cANSI'
    "let s:default_guifont='Monospace:10'
endif

if has('gui_running')
    let s:first_run = 0
    if ! exists("s:font_set")
        let s:font_set = 1
        let s:first_run = 1
    endif

    let s:guifont=s:default_guifont

    ""
    "" NOTE:  this is an attemped workaround for something that is VERY
    ""        annoying.  my current VIM's `getfontname()` method returns
    ""        NOTHING at first!  Then if I `:set guifont=` using the
    ""        mapping below, it starts returning the right value?!?!?!?
    ""
    ""        So that is why I create a mapping for \rf -- and I must
    ""        use it before attempting to 'resize' using vim-fontsize
    ""
    ""        Additionally -- even `:set`ting the value here, does not help
    ""        I still must use the mapping after VIM finishes loading :(
    ""
    function! MakeGuiFont(count) range
        if a:count == 0
            return s:guifont
        endif
        return substitute(s:guifont, '\v:h\d+', ':h' . a:count, '')
    endfunction

    if s:guifont != ""
        nnoremap <expr> <leader>rf ':<c-u>set guifont=' . MakeGuiFont(v:count) . '<cr>'
        if s:first_run == 1
            let &guifont=s:guifont
            normal \<Plug>FontsizeDefault
        endif
    endif
else
    " NOTE: this depends on the guifont default for p
    "let &printfont='Courier_New:h8'
    let &printfont='Arial:h8'
    "let &printfont='Consolas:h8'
endif


nnoremap <leader>pf  <nop>
nnoremap <leader>pfn <nop>
nnoremap <leader>pfn? :set printfont?<cr>
nnoremap <leader>pfn& :set printfont&<cr>
nnoremap <expr> <leader>pfn<space> ':set printfont=' . &pfn

"
" NOTE: each 'point' (pt) is 1/72 of an inch -- so 36pt is 1/2 in
"
set popt=left:36pt,right:36pt,top:36pt,bottom:36pt,paper:letter,header:0

nnoremap <leader>pt <cmd>call PrintBuffer()<cr>
function! PrintBuffer() abort
    " NOTE: MacOS authored!
    let ps = expand('%:r') . '.ps'
    let pdf = expand('%:r') . '.pdf'
    let font = split(&pfn, ':')[0]
    execute 'hardcopy > ' . l:ps
    call system('perl -i -pe "s/Courier/' . l:font . '/g" ' . l:ps)
    call system('ps2pdf ' . l:ps)
    "call system('rm ' . l:ps)
    call system('open ' . l:pdf)
endfunction

"}}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Tabs/show.../listchar/...
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" general settings that 'just make things better' "{{{
""
"" JES:  new for macos - not sure why this is needed only there...  but
""       without this syntax highlighting will be off by default :(
""       see:  https://stackoverflow.com/a/3765883/5844631
"syntax on
syntax enable

" I am *TIRED* of accidentally bringing up help via 'F1' on my touchbar Mac --
" so this will turn that into the '<Esc>' I was likely trying to hit
noremap  <F1> <esc>
inoremap <F1> <esc>

" I am inspired by something I read/saw somewhere I cannot remember:  a mapping to exit insert mode!
" (i know of no word that legimately contains 'jj')
inoremap jj <esc>

" Start using <space> as a leader for executing macros:
" BUT do not make a single space a 'no-op', so that it can still be used to navigate
"" So, make a single space a no-op (I don't use it for navigation anway)
"nnoremap <space>        <nop>
"xnoremap <space>        <nop>
" And make a 2nd space cancel the pending macro execution
nnoremap <space><space> <nop>
xnoremap <space><space> <nop>
function! CreateRunMacroMaps() abort
    for ltr in "abcdefghijklmnopqrstuvwxyz"
        execute 'nnoremap <space>'.l:ltr.' @'.l:ltr
        execute 'xnoremap <space>'.l:ltr.' @'.l:ltr
    endfor
endfunction
call CreateRunMacroMaps()

"set autoread        " This allows smooth re-read of altered files when no changes
set encoding=utf-8
set sidescroll=1
" set showmode		" on by default anyway
" set visualbell	" turn the beeps into flashes
set ttyfast			" smoother redrawing when terminal connection is fast
set laststatus=2	" show status line ('2' == always)

set relativenumber	" display relative line numbers (new in 7.3)
set number			" display the absolute line number on the current line only
augroup helpnumbers
	au!
	au FIleType help setlocal number | setlocal relativenumber
augroup END

" NOTE:  the listchars settings are in the section borrowed from 'gmarik'
"set breakindent
"set breakindentopt=sbr
if has('win32')
	"let &showbreak='└→\ '
	"let &showbreak='∟\ '
	"let &showbreak='└\ '
	let &showbreak='└\ '
else
	"let &showbreak='⤹→\ '
	let &showbreak='⤹\ '
endif

"" This is an attempt to create an inverse of the 'J' command (split)
"nnoremap <c-j> gEa<cr><esc>ew		" join with <ctrl>+j

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" The following options came from:  https://github.com/gmarik/vimfiles/blob/1f4f26d42f54443f1158e0009746a56b9a28b053/vimrc#L136
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" I did this a loooong time aga - i'm not even exactly sure where the parts I took from gmarik's repo conclude...
" Anyhow, here is the URL for reference;  https://github.com/gmarik/dotfiles/blob/master/.vim/vimrc
"" NOTE:  gmarik uses F10 for this, but I have not disabled F10 in gnome
set pastetoggle=<F11>	" easy toggle of paste mode
nnoremap <expr> <leader>pm ':set ' . (&paste == 0 ? '' : 'no') . 'paste<cr>'
"inoremap c-v :set paste!<cr>

""
"" NOTE:  In order to prevent the annoying 'Press ENTER or type command to coninue'
""        message from appearing, even with all shortening flags enabled (i.e. 'a')
""        I also needed to add either 'o' or 'O'. (I choose 'o')
""
set shortmess=atI		" shortens response messages
set shortmess+=o		" prevents 'Press ENTER or type...' message

"" use F12 to toggle whitespace
nnoremap <silent> <F12> :set invlist<CR>
"set listchars=tab:›·,eol:¶
set listchars=tab:›·,eol:¬
set listchars+=trail:·
set listchars+=extends:»,precedes:«

""
"" NOTE: this is useful EVERYWHERE!!!   (even though it was inspired while upgrading my Normalize mappings)
""
"
" This creates my first mapping for "operator pending" mode
"
" It works with built-ins as well:   d#   (delete whole file)
"                                    y#   (yank whole file)
"
onoremap # :<c-u>norm! ggVG<cr>
xnoremap # :<c-u>norm! ggVG<cr>
"onoremap % :<c-u>norm! ggVG<cr>  <-- this interferes with using `%` to "go to matching brace"

""
"" I just encountered a situation where a Markdown file I created had a bunch of it's
"" 'space' characters -- not all, but a bunch -- changed into NBSP characters by
"" another developer's editor.
""
"" In UTF-8:    c2a0
"" In UTF-16:   00a0
""
"" Ctrl-V can be used to enter it:  <c-v>u00a0
""
"" This command can be used to highlight all NBSP with bright red:
"" (b/w the quotes is a NBSP)
""
""      :syn match ErrorMsg " "
""
"" (note:  had to escape the '|' just to make the mapping, i think because i'm not using '<bar>'
nnoremap <leader><leader><space> :syn match ErrorMsg " "<cr>:syn match ErrorMsg /\s\+$/<cr>/<c-u>\v%u00a0\|\s+$<cr>

"" Advice from S.O. here: https://stackoverflow.com/a/48951029/5844631
"" is to put the following at the end of your .vimrc:
""
""    highlight RedundantSpaces ctermbg=red guibg=red
""    match RedundantSpaces /\s\+$/
""
"" But I'll just add something to my above mapping to do it on demand together with my NBSP highlight
""

""
"" NOTE:  this is me TRYing to get alt+ left/right to navigate the jump list
""
"nnoremap <esc>[1;3D <c-o>
"nnoremap <esc>[1;3C <c-i>
nnoremap <a+left> <c-o>
nnoremap <a+right> <c-i>

""
"" Lots of times syntax highlighting is soooo slow that redrawtime is exceeded
"" and it is auto disabled.   Even if it does not get that bad, there is still
"" super slow scrolling :(
""
"" Found this issue that has a lot of explanation, and a work around to
"" reclaim some of that lost performance:
""
""     https://github.com/vim/vim/issues/2712
""
"" NOTE: I just discovered that 're=1' actually causes TypeScript files to
""       hang the IDE when opened.  ahgharghaghghrhghragaggagghrhgh!!!!!
""       ( For MacOS, use re=2 )
""
""       (see: https://vi.stackexchange.com/questions/25086/vim-hangs-when-i-open-a-typescript-file)
""
""       So now I have a mapping to set it to '1' only when my scrolling sucks
""
""
if has('macunix')
    set regexpengine=2
else
    set regexpengine=0
endif
nnoremap <leader>rx <nop>
nnoremap <leader>rx? :set regexpengine?<cr>
nnoremap <leader>rx= :set regexpengine=
nnoremap <expr> <leader>rxx ':<c-u>set regexpengine=' . v:count . '<cr>:set regexpengine?<cr>'

"" Here's something to speed up the opening of the jump list
nnoremap <leader>j  <nop>
nnoremap <leader>jj :jumps<cr>

"" Finally setting up a spell file that captures my custom words
set spellfile=~/.vim/spell/en.utf-8.add
nnoremap <leader>sl <nop>
nnoremap <leader>sl? :set spelllang?<cr>
nnoremap <leader>sl= :set spelllang=
nnoremap <leader>sf <nop>
nnoremap <leader>sf? :set spellfile?<cr>
nnoremap <leader>sfe :sp <c-r>=&spellfile<cr><cr>
"}}}


" Artifactory section "{{{
"" #
"" # So this section reads data from various 'dot' files to get credentials,
"" # then sets those values into env. vars for use in subsequent commands.
"" #
"" # I think we were suggested to use API Keys for our authentication
"" # But now we are suggested to use ID Tokens
"" #
"" # I am a bit unsure as to the specific differences, since I was *at first*
"" # under the impression that the ID Token contained both the ID of the user
"" # and the level of privilege allowed once logged in.
"" #
"" # However, it seems that EVEN WITH the use of the ID Token, we *STILL* have
"" # to specify our Okta ID -- so I'm stumped.
"" #
"" # I have logged into Artifactory and created BOTH an API Key, and an
"" # Identity Token -- and I also use them both just because I can.
"" #
"" # It may be that everywhere I'm using one, I could replace with the other...
"" # I don't care for now.
"" #
nnoremap <leader>sa  <nop>

function! SetArtifactoryToken()
    for line in readfile(expand('~/.netrc'))
        let tokens = l:line->split(' ')
        if len(l:tokens) && l:tokens[0] == 'login'
            let $ARTUSR=l:tokens[1]
            echo 'Setting %ARTUSR% to: ' . l:tokens[1]
        endif
        if len(l:tokens) && l:tokens[0] == 'password'
            let $ARTTOK=l:tokens[1]
            echo 'Setting %ARTTOK% to: ' . l:tokens[1][0:10] . '...'
        endif
    endfor
endfunction
nnoremap <leader>sat :call SetArtifactoryToken()<cr>

function! SetApiKey()
    for line in readfile(expand('~/.gradle/gradle.properties'))
        let tokens = l:line->split('=')
        if len(l:tokens) && l:tokens[0] == 'artifactoryUser'
            let $ORG_GRADLE_PROJECT_artifactoryUser=l:tokens[1]
            echo 'Setting %ORG_GRADLE_PROJECT_artifactoryUser% to: ' . l:tokens[1]
            let $APIUSR=l:tokens[1]
            echo 'Setting %APIUSR% to: ' . l:tokens[1]
        endif
        if len(l:tokens) && l:tokens[0] == 'artifactoryApiKey'
            let $ORG_GRADLE_PROJECT_artifactoryApiKey=l:tokens[1]
            echo 'Setting %ORG_GRADLE_PROJECT_artifactoryApiKey% to: ' . l:tokens[1][0:10] . '...'
            let $APIKEY=l:tokens[1]
            echo 'Setting %APIKEY% to: ' . l:tokens[1][0:10] . '...'
        endif
    endfor
endfunction
nnoremap <leader>sak :call SetApiKey()<cr>
"}}}


" Java development section "{{{
function! SetJavaHomeToToolsArea()
    "
    " NOTE:  This calculation of where to "glob" for Java is based on my
    "        typical work project layout.  A "tools" directory is rooted
    "        right next to the source tree on the local HDD, with the
    "        same name but with a "_tools" suffix.  So, the following
    "        expression produces the root folder of the 'tools' client
    "        spec:    getcwd() . '_tools'
    "
    let search_dir = getcwd() . '_tools'
    if !isdirectory(l:search_dir)
        let search_dir = './SDK/tools'
    endif
    if !isdirectory(l:search_dir)
        echom "WARNING:  Leaving the JAVA_HOME env var alone, cannot find tools area"
        return
    endif

    "" # glob() arg2:  {nosuf}, if TRUE ignore 'suffixes' and 'wildignore' options
    "" # glob() arg3:  {list}, if TRUE return a list
    "" # The only reason I have the 2nd is to get to the 3rd
    let matches = glob(fnamemodify(l:search_dir, ':p') . '**/javac.exe', 0, 1)
    if !len(matches)
        echom "WARNING:  Search dir [".l:search_dir."] exists, but javac.exe still not found"
        return
    endif
    let javas = {}
    for match in l:matches
        let ver = split(trim(system(l:match . ' -version')))[1]
        let javas[l:ver] = l:match
    endfor

    "" # TODO:  should this always just be the "highest" vesion?
    let highest = sort(keys(l:javas))[-1]

    let $JAVA_HOME = fnamemodify(fnamemodify(l:javas[l:highest], ':h'), ':h')
    echom 'Set JAVA_HOME to:  ' . $JAVA_HOME
endfunction

function! SetJavaInPath()
    call ReloadEnvVar('PATH')
    let jbin = join([$JAVA_HOME, 'bin'], '\')
    let $PATH = join([$PATH, l:jbin], ';')
    echom 'Appended [' . l:jbin . '] to the %PATH% env var'
    echo join(split($PATH, ";"), "\n")
endfunction

nnoremap <leader>jh :call SetJavaHomeToToolsArea()<cr>
nnoremap <leader>jp :call SetJavaInPath()<cr>

nnoremap <expr> <leader>jc ':w<cr>:!cd "'.expand('%:p:h').'" && javac '.expand('%:t').'<cr>'
nnoremap <expr> <leader>jr ':w<cr>:!cd "'.expand('%:p:h').'" && java '.expand('%:t:r').' '
"" #
"" # JDK 11 and newer can run single Java files with a single launch:
"" #
nnoremap <expr> <leader>ja ':w<cr>:!cd "'.expand('%:p:h').'" && java '.expand('%:t').' '

nnoremap <expr> <leader>ji ':call CocAction(''organizeImport'')<cr>'



augroup Java
	au!
	au BufEnter *.java setlocal makeprg=javac\ -g\ %
	nnoremap <leader>8 :w<cr>:make<cr>:cwindow<cr>
	"nnoremap <leader>9 :!clear; echo <c-r>=expand('%:t')<cr> \| xargs java<cr>
	nnoremap <leader>9 :!clear; java <c-r>=expand('%:t')<cr><cr>
augroup END
"}}}


" Helper to create command abbreviations, i.e. all lowercase user-commands "{{{

" see lower-case user commands: http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
"                          and: https://learnvimscriptthehardway.stevelosh.com/chapters/08.html
"
"  NOTE:  'ccab' cannot be used within this file -- just the command line directly :/
"
function! ShouldReplaceCommand()
    " NOTE:  not using v:true & v:false below b/c trying to remain compatible with VIM 7.4
    if getcmdtype() != ":"
        return 0
    endif
    if getcmdpos() == 1
        return 1
    endif
    return -1 == match(getcmdline(), "[^.$%'`<>,0-9 ]")
endfunction
function! CommandAbbrev(abbreviation, expansion)
  execute 'cabbrev ' . a:abbreviation . ' <c-r>=ShouldReplaceCommand() ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
endfunction

command! -nargs=+ CommandAbbrev call CommandAbbrev(<f-args>)

" Use it on itself to define a simpler abbreviation for itself.
"    (abbrev only for manual use in interactive command line mode)
"    (i.e. 'ccab' cannot be used below in this script)
CommandAbbrev ccab CommandAbbrev

function! ArgTest(...)
    let idx = 1
    let msg = [ 'Count: ' . a:0, 'Args:', ]
    for i in a:000
        call add(l:msg, '  arg ' . l:idx . ': ' . i)
        let idx = l:idx + 1
    endfor
    echo join(l:msg, "\n")
endfunction
command! -nargs=* -complete=command -range ArgTestQ call ArgTest(<range>, <line1>, <line2>, <q-args>)
CommandAbbrev argtestq ArgTestQ
command! -nargs=* -complete=command -range ArgTestF call ArgTest(<range>, <line1>, <line2>, <f-args>)
CommandAbbrev argtestf ArgTestF

function! DumpHistory(type, count) abort
    if a:count == 0
        let cnt = 10
    else
        let cnt = a:count
    endif
    let idx = l:cnt
    while l:idx > 0
		"" # one of:                    *hist-names*
		"" #    "cmd"    or ":"   command line history
		"" #    "search" or "/"   search pattern history
		"" #    "expr"   or "="   typed expression history
		"" #    "input"  or "@"   input line history
		"" #    "debug"  or ">"   debug command history
		"" #    empty         the current or last used history
        echo printf('%4d %s', -l:idx, histget(a:type, "-" . l:idx))
        let idx = l:idx - 1
    endwhile
endfunction
nnoremap <leader>q: :<c-u>call DumpHistory(':', v:count)<cr>
nnoremap <leader>q/ :<c-u>call DumpHistory('/', v:count)<cr>
nnoremap <leader>q= :<c-u>call DumpHistory('=', v:count)<cr>
nnoremap <leader>q@ :<c-u>call DumpHistory('@', v:count)<cr>
nnoremap <leader>q> :<c-u>call DumpHistory('>', v:count)<cr>

nnoremap <leader>qp  <nop>
nnoremap <leader>qp: :<c-u>norm ]op<c-r>=histget(':', "-" . v:count1)<cr><cr>
nnoremap <leader>qp/ :<c-u>norm ]op<c-r>=histget('/', "-" . v:count1)<cr><cr>
nnoremap <leader>qp= :<c-u>norm ]op<c-r>=histget('=', "-" . v:count1)<cr><cr>
nnoremap <leader>qp@ :<c-u>norm ]op<c-r>=histget('@', "-" . v:count1)<cr><cr>
nnoremap <leader>qp> :<c-u>norm ]op<c-r>=histget('>', "-" . v:count1)<cr><cr>

" "}}}


" Functions/mappings for toggling options like Unimpaired "{{{

""
"" NOTE:  turning these off, so I force myself to learn the ones
""        provided by the "Unimpaired" plugin:
""           On    Off   Toggle
""           [on,  ]on,  yon  :  numbers
""           [or,  ]or,  yor  :  relative numbers
""           [ow,  ]ow,  yow  :  wrap
""        the only drawback -- is that there is no "both numbers" option
""        automatically provided by the plugin :(
""
"function! ToggleBoolOption(val)
"	if eval('&'.a:val)
"		execute 'set no'.a:val
"	else
"		execute 'set '.a:val
"	endif
"endfunction
"nnoremap <leader>tn :call ToggleBoolOption('nu')<bar>call ToggleBoolOption('rnu')<cr>
"nnoremap <leader>tnr :call ToggleBoolOption('rnu')<cr>
"nnoremap <leader>tnl :call ToggleBoolOption('nu')<cr>
"nnoremap <leader>tw :set wrap!<cr>
"}}}


" Mappings to grab current VIM settings into a new split "{{{
" Simple mapping to create a new buffer that contains a copy of the current mappings
" Inspired from:  https://vi.stackexchange.com/a/19471/9912
"                 the answer I liked - was broken so I fixed it here :)
"                 i would add a comment but not enough rep
"
"     Here is a working version:
"         nnoremap <leader>gm :redir @"<bar>silent map<bar>redir END<bar>new<bar>put! \"<cr>
"
" NOTE (jes):  I found that NOT ALL info can be retrieved with the above command
"              for `:au` and `:comm` the above technique fails, so i created a function
"              that works in all situations
"
"" NOTE:  this one to gather all the autocmd entries in a buffer DOES NOT WORK :(
nnoremap <leader>g <nop>
nnoremap <leader>ge <nop>
nnoremap <leader>gem :<c-u>call GetSpecifiedInfo("map", 0, v:count)<cr>
nnoremap <leader>gek :<c-u>call GetSpecifiedInfo("marks", 0, v:count)<cr>
nnoremap <leader>gec :<c-u>call GetSpecifiedInfo("command", 0, v:count)<cr>
nnoremap <leader>gea :<c-u>call GetSpecifiedInfo("autocmd", 0, v:count)<cr>
nnoremap <leader>geh :<c-u>call GetSpecifiedInfo("highlight", 0, v:count)<cr>
nnoremap <leader>gel :<c-u>call GetSpecifiedInfo("let", 0, v:count)<cr>
nnoremap <leader>ger :<c-u>call GetSpecifiedInfo("registers", 0, v:count)<cr>
nnoremap <leader>ges :<c-u>call GetSpecifiedInfo("scriptnames", 0, v:count)<cr>
nnoremap <leader>geg :<c-u>call GetSpecifiedInfo("messages", 0, v:count)<cr>
nnoremap <leader>geq :<c-u>call GetSpecifiedInfo("clist", 0, v:count)<cr>
nnoremap <leader>geb <nop>
nnoremap <leader>gebq :<c-u>call GetSpecifiedInfo("clist!", 0, v:count)<cr>

nnoremap <leader>gev <nop>
nnoremap <leader>gevm :<c-u>call GetSpecifiedInfo("map", 1, v:count)<cr>
nnoremap <leader>gevk :<c-u>call GetSpecifiedInfo("marks", 1, v:count)<cr>
nnoremap <leader>gevc :<c-u>call GetSpecifiedInfo("command", 1, v:count)<cr>
nnoremap <leader>geva :<c-u>call GetSpecifiedInfo("autocmd", 1, v:count)<cr>
nnoremap <leader>gevh :<c-u>call GetSpecifiedInfo("highlight", 1, v:count)<cr>
nnoremap <leader>gevl :<c-u>call GetSpecifiedInfo("let", 1, v:count)<cr>
nnoremap <leader>gevr :<c-u>call GetSpecifiedInfo("registers", 1, v:count)<cr>
nnoremap <leader>gevs :<c-u>call GetSpecifiedInfo("scriptnames", 1, v:count)<cr>
nnoremap <leader>gevg :<c-u>call GetSpecifiedInfo("messages", 1, v:count)<cr>
nnoremap <leader>gevq :<c-u>call GetSpecifiedInfo("clist", 1, v:count)<cr>
nnoremap <leader>gevb <nop>
nnoremap <leader>gevbq :<c-u>call GetSpecifiedInfo("clist!", 1, v:count)<cr>

nnoremap <leader>geyd :<c-u>call GetSpecifiedInfo("YcmDebugInfo", 0, v:count)<cr>

function! GetSpecifiedInfo(cmd, verbose, count)
	redir @"
	if a:verbose
		execute "verbose silent " . a:cmd
		" There is a special case for 'map' which does not print the mappings
		" for insert mode...  ever.       So we have to also call 'imap'
		if a:cmd == 'map'
			execute "verbose silent imap"
		endif
	else
		execute "silent " . a:cmd
		if a:cmd == 'map'
			execute "silent imap"
		endif
	endif
	redir END
	if a:count == 1
		put \"
	else
		new
		put! \"
	endif
endfunc

function! MakeScratch()
    " setl bt=nofile bh=wipe nobl noswf
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
endfunc
nnoremap <leader>wc <cmd>call MakeScratch()<cr>
function! MakeUnscratch()
    " setl bt= bh= bl swf
    setlocal buftype= bufhidden= buflisted swapfile
endfunc
nnoremap <leader>wu <cmd>call MakeUnscratch()<cr>

""
"" This helper is a modified copy of: https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
""
function! s:RedirExec(cmd) abort
    redir => cmd_output
    silent! execute a:cmd
    redir END
    return split(l:cmd_output, "\n")
endfunction

function! Redir(cmd, count, start, end)
    "for win in range(1, winnr('$'))
    "	if getwinvar(win, 'redir_scratch_window')
    "		execute win . 'windo close'
    "	endif
    "endfor
    if a:cmd =~ '^!'
        let cmd = a:cmd
        " NOTE:  this only handles the simpliest case:  just a single '%'
        if l:cmd =~ ' %\($\|\s\)'
            let cmd = substitute(l:cmd, ' %\($\|\s\)', ' ' . shellescape(escape(expand('%:p'), '\')), '')
        endif
        let cmd = matchstr(l:cmd, '^!\zs.*')
        let output = systemlist(l:cmd)
        "if a:count == 0
        "	let output = systemlist(cmd)
        "else
        "	let joined_lines = join(getline(a:start, a:end), '\n')
        "	let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
        "	"let output = systemlist(cmd . " <<< $" . cleaned_lines)
        "	let output = split(cleaned_lines, "\n")
        "endif
    else
        let output = s:RedirExec(a:cmd)
    endif
    if a:count == a:start && a:count == a:end && a:count == 1
        vnew
    else
        new
    endif
    let w:redir_scratch_window = 1
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
    call setline(1, output)
endfunction
command! -nargs=1 -complete=command -range Redir silent call Redir(<q-args>, <count>, <line1>, <line2>)
CommandAbbrev cap Redir

"}}}


" Exploring getpos() and getcurpos() and other marks "{{{
function! PosDump() range
    " A few notes about "v:count" ...
    "
    "    First, typing `N:` (populates command w/ :.,.+N-1) then finishing with `call PosDump()`
    "       WILL populate v:count  (and a:firstline & a:lastline)
    "
    "    However, manually inputting a range will NOT -- v:count will always be zero
    "        (though a:firstline & a:lastline will be populated)
    "
    "    Also, if you used something like !8j to build it, then backspace the '!' char,
    "    and complete the command manually -- it WILL populate v:count (and first/last line)
    "
    "    But, similarly, if you used !ip to build it...  it will NOT populate v:count
    "        (though a:firstline & a:lastline will be populated)
    "
    " A few notes about "mode()" ...
    "
    "    When using the command line (:) -- it will NEVER be "v" for visual
    "
    "    The only way I have seen to get that, is a "x" mode mapping that runs in visual
    "    mode and that does NOT include ":" to enter a command (i.e. an "<expr>" mapping)
    "    (also maybe a "<cmd>" mapping -- which can execute a command without a ":")
    "
    " A few notes about "'<" and "'>" ...
    "
    "    ...
    "
    " A note about: curswant
    "
    "    curswant is a value included in the dictionary returned by `winsaveview()`
    "
    "    winsaveview() returns a dictionary that can be used with
    "    winrestview() to restore the view if the function jumps around
    "
    let view = winsaveview()
    try
        echom "mode        : " . mode()
        echom "visualmode  : " . visualmode()
        echom "getcurpos() : " . join(getcurpos(), ", ")
        echom "getpos(.)   : " . join(getpos("."), ", ")
        echom "getpos(v)   : " . join(getpos("v"), ", ")
        echom "getpos('<)  : " . join(getpos("'<"), ", ")
        echom "getpos('>)  : " . join(getpos("'>"), ", ")
        echom "getpos('[)  : " . join(getpos("'["), ", ")
        echom "getpos('])  : " . join(getpos("']"), ", ")
        echom "getpos('{)  : " . join(getpos("'{"), ", ")
        echom "getpos('})  : " . join(getpos("'}"), ", ")
        echom "v:count     : " . v:count
        echom "a:firstline : " . a:firstline
        echom "a:lastline  : " . a:lastline

        " SEE:  https://vi.stackexchange.com/a/14294/9912
        " NOTE: I changed the patterns to only match fully blank lines
        "       to match the behavior of the "{}" marks & motion
        "
        "       It seems the S.O. author was attempting to mimic the
        "       behavior of the "inner paragraph" object which DOES
        "       use lines containing only spaces as a boundary
        let mark_is_ptop = (match(getline("'{"),'^$') == -1)
        let mark_is_pbot = (match(getline("'}"),'^$') == -1)
        "echom "{ is ptop   : " . l:mark_is_ptop
        "echom "} is pbot   : " . l:mark_is_pbot
        echom "p linecount : " . (line("'}") - line("'{") + (l:mark_is_ptop + l:mark_is_pbot - 1))
    finally
        call winrestview(l:view)
    endtry
    " Without this return statement -- the <expr> mappings just below RESET the cursor to column 1 :/
    return ''
endfunction
" This kind of mapping, with <expr>, that calls the helper to build the string, is
" the ONLY way I've found so far to execute a function while staying in Visual mode
" NOTE:  I think I found another way:   <cmd> mappings  (:h :map-cmd)
xnoremap <expr> <leader>pz PosDump() . ':<c-u>13mes<cr>'
nnoremap <expr> <leader>pz PosDump() . ':<c-u>13mes<cr>'
" Other ways of launching PosDump(), with :N or :<range>, can be done manually

function! VisualSelection()
    if mode()=="v"
        let [line_start, column_start] = getpos("v")[1:2]
        let [line_end, column_end] = getpos(".")[1:2]
    else
        let [line_start, column_start] = getpos("'<")[1:2]
        let [line_end, column_end] = getpos("'>")[1:2]
    end
    if (line2byte(line_start)+column_start) > (line2byte(line_end)+column_end)
        let [line_start, column_start, line_end, column_end] =
        \   [line_end, column_end, line_start, column_start]
    end
    let lines = getline(line_start, line_end)
    if len(lines) == 0
            return ''
    endif
    let lines[-1] = lines[-1][: column_end - 1]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function! GetMarksFile(fname) abort
    let path = a:fname->resolve()
    " Determine path to "marks" file
    if l:path =~? '\vDocuments[/\\]build-files[/\\]%([^/\\]+[/\\])*[^/\\]{-}-cmds\.(txt|md)$'
        return substitute(l:path, '\v-cmds\.(txt|md)$', '-marks.\1', '')
    elseif l:path =~? '\vDocuments[/\\]%(test-files|work)[/\\]%([^/\\]+[/\\])*cmds-[^/\\]+\.(txt|md)$'
        return substitute(l:path, '\vcmds-([^/\\]+\.(txt|md))$', 'marks-\1', '')
    endif
    echoe "Only know how to save marks for my cmds files"
    return
endfunction

function! QuickSplit(lines) abort
    let numlines = len(a:lines)
    new
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile winfixheight
    set nowrap
    call setline(1, a:lines)
    exe 'resize ' . l:numlines
    wincmd p
endfunction

function! OpenMarks(forRemaking) abort
    let marks = DumpMarks(a:forRemaking)
    call QuickSplit(l:marks)
endfunction

function! DumpMarks(forRemaking) abort
    ""
    "" NOTE:  forRemaking ALSO controls return value!!!
    ""
    ""      forRemaking == TRUE  : returns a string (expecting to end up in the messages log)
    ""      forRemaking == FALSE : creates a lower scratch win with the current list of marks
    ""
    ""   I dont like that.   For now it works :/
    ""
    let cmdout = s:RedirExec('marks')
    let marks = []
    for line in l:cmdout
        let fields = l:line->split()
        " if it is an a-z mark...
        if len(l:fields) > 0 && l:fields[0] =~# '^[a-z]$'
            let marks += [[l:fields[0], l:fields[1], join(l:fields[3:])]]
        endif
    endfor
    if len(l:marks) == 0
        throw 'Found no marks'
    endif

    " NOTE: to get numerical comparison, I had to "coerce" with `+0` to each item :(
    let Comp = {e1, e2 -> (e1[1]+0) > (e2[1]+0) ? 1 : (e1[1]+0) < (e2[1]+0) ? -1 : 0 }
    call sort(l:marks, l:Comp)

    if a:forRemaking
        ""
        "" Here the format needs to be exact:
        ""
        let expr = 'v:val[1] . "mark " . v:val[0] . " \" " . v:val[2]'
        return map(l:marks, l:expr)
    endif

    ""
    "" If not to re-create, then print 'easy to read'
    ""

    let expr = 'printf("% 7d %s \" %s", v:val[1], v:val[0], v:val[2])'
    return map(l:marks, l:expr)
endfunction

function! MultiEchoM(header, data) abort
    echom a:header
    for line in a:data
        echom line
    endfor
endfunction

function! LoadMarks(fname) abort
    echo 'Loading marks...'
    let markspath = GetMarksFile(a:fname)
    for line in l:markspath->readfile()
        let fields = l:line->split()
        " if it is an a-z mark...
        if len(l:fields) > 0 && l:fields[0] =~# '^[a-z]$'
            " set the mark in the current buffer
            echo l:fields[1] . ' mark ' . l:fields[0]
            exe l:fields[1] . 'mark ' . l:fields[0]
        endif
    endfor
endfunction

function! SaveMarks(fname) abort
    echo 'Saving marks...'
    let markspath = GetMarksFile(a:fname)
    let cmdout = s:RedirExec('marks')
    let marks = []
    for line in l:cmdout
        let fields = l:line->split()
        " if it is an a-z mark...
        if len(l:fields) > 0 && l:fields[0] =~# '^[a-z]$'
            echo l:fields[1] . ' mark ' . l:fields[0]
            let marks += [l:line]
        endif
    endfor
    call writefile(l:marks, l:markspath)
endfunction

" See this S.O. answer for a good explanation of PRECISELY when the '%' character
" will be expaned into a filename, and how to do it when it is not automatic:
"
"    https://stackoverflow.com/a/28612666/5844631
"
" Here, I choose to use the register notation:  @%
nnoremap <leader>kk :call OpenMarks(0)<cr>
nnoremap <leader>kd :call OpenMarks(1)<cr>
nnoremap <leader>ky :let @" = DumpMarks(1)->join("\n")<cr>
nnoremap <leader>kz :wincmd j<cr>:q<cr>
nnoremap <leader>kl :call LoadMarks(@%)<cr>
nnoremap <leader>ks :call SaveMarks(@%)<cr>
nnoremap <leader>kw :call MultiEchoM("Wiping marks, the following can be used to re-create them:", DumpMarks(1))<cr>:delmarks!<cr>

"}}}


" Mappings to execute the current line "{{{

""
"" Options and Helper functions first...
""
if has('win32')
    set shellcmdflag=/v:on\ /c
endif
let g:WatchHighlightDiffs = 1
function! LineAsWatchCmd(count) abort
    let darg = g:WatchHighlightDiffs == 1 ? " -d " : " "
    if a:count == 0
        let cmd = "term ++kill=term ++close watch" . l:darg
    else
        let cmd = "term ++kill=term ++close watch -n " . a:count . l:darg
    endif
    if has ('win32')
        let cmd0 = split(getline('.'))[0]
        let loc = trim(system('where ' . l:cmd0))
        let ext = fnamemodify(l:loc, ':e')
        if tolower(l:ext) == 'exe'
            return l:cmd . "'" . VimCmdEscape(CygEscape(getline('.'))) . "'"
        elseif tolower(l:ext) == 'py'
            " NOTE:  Next 2 lines are a CUSTOMIZED version of WatchCmdEscape()
            let Repl = {m -> '"'.CmdEscape(m[1]).'"'}
            let rv = substitute(getline('.'), '\v"(%(\\"|[^"])*)"', Repl, 'g')
            return l:cmd . 'cmd /c ' . VimCmdEscape(CygEscape(l:rv))
        endif
        return l:cmd . 'cmd /c ' . VimCmdEscape(CygEscape(WatchCmdEscape(getline('.'))))
    endif
    return l:cmd . getline('.')
endfunction
function! OutputCaptureHeading(data)
    if type(a:data) == type('')
        "" # NOTE: for string data, `writefile()` automatically replaces
        "" #       newlines with NULL so we split early just in case.
        "" #       (though this helper is only called from a couple places...)
        let writedata = a:data->split('\\n')
    else
        let writedata = a:data
    endif

    "" # NOTE:  `-1` means Not Found
    let fsize = getfsize('out.txt')

    "" # Size used to decide if file is NEW -- or if spacer lines and appending should be used
    if l:fsize == -1 || l:fsize == 0
        call writefile(l:writedata, 'out.txt', 's')
        return
    endif

    call writefile(['',''], 'out.txt', 'as')
    call writefile(l:writedata, 'out.txt', 'as')
endfunction
function! LineAsSplitCmd(capture) abort
    let text =getline('.')
    if has('win32')
        let text = 'cmd /c ' . l:text . ' && pause'
    else
        "let text = substitute(l:text, '\v\|', '\\|', 'g')
        let text = '++shell ' . l:text
    endif
    " NOTE: we pass '1' for "wait" param, to prevent prefixing with "start "
    return TextAsShellCmd(a:capture, 1, l:text)
endfunction
function! LineAsShellCmd(capture, wait) abort
    return TextAsShellCmd(a:capture, a:wait, getline('.'))
endfunction
function! VisualAsSplitCmd(capture) abort
    let text = VisualSelection()
    if has('win32')
        let text = 'cmd /c ' . l:text . ' && pause'
    else
        "let text = substitute(l:text, '\v\|', '\\|', 'g')
        let text = '++shell ' . l:text
    endif
    " NOTE: we pass '1' for "wait" param, to prevent prefixing with "start "
    return TextAsShellCmd(a:capture, 1, l:text)
endfunction
function! VisualAsShellCmd(capture, wait) abort
    return TextAsShellCmd(a:capture, a:wait, VisualSelection())
endfunction
function! TextAsShellCmd(capture, wait, text) abort
    " NOTE:  internally to VIM, :!start... is handled WAAAY differetly than :!...
    "        without "start", the :! command calls `vimrun.exe` with an ADJUSTED
    "        string, escaping a few different characters with an "^" !!!
    "
    " Considering the following example command:    echo !@#$%^&*,.?%;:[]{}"`|\/''()<>"
    "
    " If a:wait == 1, and we do NOT prepend ":!start "
    "     i.e.  literal VIM cmd line, :!echo \!@\#$\%^&*,.?\%;:[]{}"`|\/''()<>"
    " then GVIM calls `vimrun` with:
    "       C:\tools\vim\vim90\vimrun C:\Windows\system32\cmd.exe /v:on /c (echo !^@#$%^^^&*,.?%;:[]{}^"`^|\/''^(^)^<^>^")
    "
    " BUT if a:wait == 0, and we DO prepend ":!start "
    "     i.e.  literal VIM cmd line, :!start cmd /v:on /c (echo \!@\#$\%^&*,.?\%;:[]{}"`|\/''()<>")
    " then GVIM calls `cmd` DIRECTLY with:
    "       cmd /v:on /c (echo !@#$%^&*,.?%;:[]{}"`|\/''()<>")
    "
    " (the above was captured with procmon)
    "
    " As we see, the VIMRUN cmd-line is QUITE escaped....
    "
    " If this presents a problem, try delayed-expansion with '!' instead of '%'
    "

    " TODO:  this OS detection is duplicated just below, remove that
    "        duplication
    let line = a:text
    if a:capture
        call OutputCaptureHeading('(' . l:line . ')')
        let capsfx = ' 2>&1 | tee -ai out.txt'
        if has('win32')
            let line = '(' . CmdPipeEscape(l:line) . ')'
        endif
        let line = l:line . l:capsfx
    endif
    if a:wait == 0
        if has('win32')
            let line = 'start cmd /v:on /c (' . l:line . ') & pause'
        else
            let line = l:line . ' &'
        endif
    endif
    return VimCmdEscape(l:line)
endfunction
function! GetInnerParagraph() abort
    ""
    "" The below block is a home-made version of "inner paragraph"
    "" this avoids using `normal yip` -- providing 2 benefits:
    ""   - this function can be called from an <expr> mapping
    ""   - no need to save & restore register contents
    ""
    " Flags for search:  b=backward, n=do not move cursor, W=do not wrap
    let empty = search('^\s*$', 'bnW')
    let l:first = l:empty ? l:empty + 1 : 1
    let empty = search('^\s*$', 'nW')
    let l:last = l:empty ? l:empty - 1 : line('$')
    return [l:first, l:last]
endfunction
function! InnerParagraphForExecution(capture) abort
    let inner = GetInnerParagraph()
    let lines = getline(l:inner[0], l:inner[1])

    " NOTE:  Here, each line will be surrounded by "()" and joined by "&"
    "        to combine multiple commands onto a single command line.
    "        the whole thing is intended to be executed with a single :!

    "        we cannot use shellescape(), since it surrounds each line with
    "        quotes so we use escape() to do what shellescape(..., 1) would do
    "        (i.e. escape the 'special' items)
    if a:capture
        if has('win32')
            let lines = map(l:lines, '"(" . CmdPipeEscape(v:val) . ")"')
        endif
        let heading = has('win32') ? l:lines : map(l:lines, '"(" . v:val . ")"')
        call OutputCaptureHeading(l:heading)

        let capsfx = ' 2>&1 | tee -ai out.txt'
        let lines = map(l:lines, 'v:val . l:capsfx')
    elseif has('win32')
        let lines = map(l:lines, '"(" . v:val . ")"')
    endif
    return join(l:lines, has('win32') ? ' & ' : ' ; ')
endfunction
function! InnerParagraphAsShellCmd(capture, wait) abort
    let retval = InnerParagraphForExecution(a:capture)
    if a:wait == 0
        if has('win32')
            let retval = 'start cmd /v:on /c (' . l:retval . ') & pause'
        else
            " For *nix surround it all with "()" for the "&" to apply (i.e. background all of it)
            let retval = '(' . l:retval . ') &'
        endif
    endif
    return VimCmdEscape(l:retval)
endfunction
function! InnerParagraphAsSplitCmd(capture) abort
    let text = InnerParagraphForExecution(a:capture)
    if has('win32')
        let text = 'cmd /c ' . l:text . ' && pause'
    else
        "let text = substitute(l:text, '\v\|', '\\|', 'g')
        let text = '++shell ' . l:text
    endif
    return VimCmdEscape(l:text)
endfunction
" NOTE:  because this helpful debugging macro is using single-quotes to surround the whole expression,
"        AND b/c it is executing a VIM command, :echo, the rules for escaping contained "'" is to double them up
"        if this were actually getting sent to the shell -- the rules would be different:  see shellescape()
nnoremap <leader>ep  <nop>
nnoremap <leader>epz :<c-u>echo '<c-r>=substitute(InnerParagraphAsShellCmd(v:count), "'", "''", "g")<cr>'<cr>

function! ExecuteInnerParagraph() abort
    let inner = GetInnerParagraph()
    let lines = getline(l:inner[0], l:inner[1])
    for line in l:lines
        execute l:line
    endfor
endfunction

""
"" Now the MAPPINGS  (w/ comments of mnemonic)
""

"" ee     : [E]xecute [E]xpression   (run as expression, paste output just below current line)
"" em     : [E]xecute [M]ath         (run with `bc` tool, ... forgot where output goes)
"" ec     : [E]xecute [C]ommand      (run as command, no pasting)
nnoremap <leader>e  <nop>
nnoremap <leader>ee :norm ]op<c-r>=eval(getline('.'))<cr><cr>
xnoremap <leader>ee :<c-u>norm ]op<c-r>=eval(VisualSelection())<cr><cr>
nnoremap <leader>eh yypkA =<Esc>jOscale=2<Esc>:.,+1!bc<CR>kJ0
nnoremap <leader>ec :<c-r>=getline('.')<cr><cr>
xnoremap <leader>ec :<c-u><c-r>=VisualSelection()<cr><cr>

""
"" ODDball ECHO mappings..
"" I don't like this, but for now, don't know where to put them.
""
function! EpochToDate(sec)
    if len(a:sec) == 10
        let sec = a:sec
        let ms = ''
    elseif len(a:sec) == 13
        let sec = a:sec[:9]
        let ms = a:sec[10:]
    endif
    if has('win32')
        let rv = system('cdate --date @' . l:sec)
    else
        let rv = system('date -j -f "%s" ' . l:sec)
    endif
    return trim(l:rv) . (l:ms ? ' (ms: '.l:ms.')' : '')
endfunction

nnoremap <leader>ed :norm ]op<c-r>=EpochToDate(<c-r><c-w>)<cr><cr>
xnoremap <leader>ed :<c-u>norm ]op<c-r>=EpochToDate(VisualSelection())<cr><cr>

cnoremap <expr> <c-s> <nop>
inoremap <expr> <c-s> <nop>

nnoremap <leader>shrug  :echo '¯\_(ツ)_/¯'<cr>
cnoremap <expr> <c-s>s  '¯\_(ツ)_/¯'
inoremap <expr> <c-s>s  '¯\_(ツ)_/¯'
cnoremap <expr> <c-s>g  substitute(trim(system('guidgen')), '\v^.{-}\{(.{-})\}.*', '\1', '')
inoremap <expr> <c-s>g  substitute(trim(system('guidgen')), '\v^.{-}\{(.{-})\}.*', '\1', '')
cnoremap <expr> <c-s>t  trim(system((has('win32') ? 'cdate' : 'date') . ' +"%Y-%m-%d-%H-%M-%S"'))
inoremap <expr> <c-s>t  trim(system((has('win32') ? 'cdate' : 'date') . ' +"%Y-%m-%d-%H-%M-%S"'))
cnoremap <expr> <c-s>d  trim(system(has('win32') ? 'cdate' : 'date'))
inoremap <expr> <c-s>d  trim(system(has('win32') ? 'cdate' : 'date'))

""
"" The above mapping was created and used when dealing with a saved VIMINFO file
"" which saves a timestamp for most saved items.  This mapping helped quickly see
"" in human terms the age of the oldest entry.
""
"" Also, at that time, I used this macro to 'condense' the timestamps so
"" I could merge two VIMINFO files, intending for one to 'appear' older.
""
""     let @q="yiw?\\v%<.l\\d{10}\nciw010b"
""
"" It moves to and sets the entry above it to 10 seconds later in time
"" The technique to save so I don't forget:  %<.
"" That expression limits results to lines above the current line
"" I used it to prevent the search from wrapping without changing options
""

""
"" For Lines
""
"" eg       : [E]xecute [G]et    -- in foreground, paste output just below
nnoremap <leader>eg :r !<c-r>=LineAsShellCmd(0,1)<cr><cr>
xnoremap <leader>eg :r !<c-r>=VisualAsShellCmd(0,1)<cr><cr>
nnoremap <leader>es :r !echo <c-r>=VimCmdEscape(getline('.'))<cr><cr>

"" er.    : [E]xecute [R]un           -- in foreground (no pasting)
"" el.    : [E]xecute [L]aunch        -- in background (no pasting)
"" e.f    : [E]xecute ... [F]ree      -- no redirection
"" e.c    : [E]xecute ... [C]apture   -- redirection & tee  (with: "2>&1 | tee -ai out.txt")
"" NEW:
"" elr    : [E]xecute [L]ine [R]un      -- w/o count: "free", with count: "capture"
"" ell    : [E]xecute [L]ine [L]aunch   -- w/o count: "free", with count: "capture"
"" NEW:
"" els    : [E]xecute [L]ine [S]plit [R]un      -- w/o count: "free", with count: "capture"
"" elv    : [E]xecute [L]ine [V]ert  [R]un      -- w/o count: "free", with count: "capture"

""  0 == LAUNCH
""  1 == RUN  (i.e. wait)

nnoremap <leader>el   <nop>
if has('win32')
    nnoremap <leader>elr  :<c-u>silent !<c-r>=LineAsShellCmd(v:count, 1)<cr><cr>
    nnoremap <leader>ell  :<c-u>silent !<c-r>=LineAsShellCmd(v:count, 0)<cr><cr>
else
    nnoremap <leader>elr  :<c-u>!<c-r>=LineAsShellCmd(v:count, 1)<cr><cr>
    nnoremap <leader>ell  :<c-u>!<c-r>=LineAsShellCmd(v:count, 0)<cr><cr>
endif
nnoremap <leader>eld  :<c-u>:Dispatch <c-r>=LineAsShellCmd(v:count, 1)<cr><cr>

nnoremap <leader>elu  <nop>
nnoremap <leader>elur :<c-u>put =LineAsShellCmd(v:count, 1)<cr>
nnoremap <leader>elul :<c-u>put =LineAsShellCmd(v:count, 0)<cr>
nnoremap <leader>eluw :<c-u>put =LineAsWatchCmd(v:count)<cr>
nnoremap <leader>elus :<c-u>put =LineAsSplitCmd(v:count)<cr>

" Not sure if I want to keep the delayed resize or not...    as of now, not.
"nnoremap <leader>els :<c-u>term ++close <c-r>=LineAsSplitCmd(v:count)<cr><cr><c-w>:sleep 750ms<cr><c-w>:resize <c-r>=2+getbufinfo("%")[0]["linecount"]<cr><cr><c-w>:set wfh<cr>
nnoremap <leader>els :<c-u>term ++close <c-r>=LineAsSplitCmd(v:count)<cr><cr><c-w>p
nnoremap <leader>elv :<c-u>vert term ++close <c-r>=LineAsSplitCmd(v:count)<cr><cr><c-w>:set wfw<cr><c-w>p

xnoremap <leader>ev   <nop>
xnoremap <leader>evr  :<c-u>!<c-r>=VisualAsShellCmd(v:count, 1)<cr><cr>
xnoremap <leader>evl  :<c-u>!<c-r>=VisualAsShellCmd(v:count, 0)<cr><cr>
xnoremap <leader>evs  :<c-u>term ++close <c-r>=VisualAsSplitCmd(v:count)<cr><cr><c-w>p
xnoremap <leader>evv  :<c-u>vert term ++close <c-r>=VisualAsSplitCmd(v:count)<cr><cr><c-w>:set wfw<cr><c-w>p

nnoremap <leader>ef   <nop>
nnoremap <leader>efr  :<c-u>!<c-r>=TextAsShellCmd(v:count, 1, '"' . Expand('p') . '"')<cr><cr>
nnoremap <leader>efl  :<c-u>!<c-r>=TextAsShellCmd(v:count, 0, '"' . Expand('p') . '"')<cr><cr>

""
"" Mappings to execute the paragraph AT A MARK within the specified buffer
""
"" This section frees up registers I used to record frequently, and kept around
""    (i.e. I always knew to keep 'm' available for jumping to 'm' and executing)
""
function! InitMarkExecuteMaps() abort
    nnoremap <leader>em    <nop>
    nnoremap <leader>emc   <nop>
    nnoremap <leader>eml   <nop>
    nnoremap <leader>emr   <nop>
    nnoremap <leader>emd   <nop>
    nnoremap <leader>ema   <nop>

    function! ExecuteMark(count, mark, cmd, rst) abort
        if a:count == 0
            execute 'norm ' . printf("'%s%s\<c-o>", a:mark, a:cmd)
        else
            execute 'tab sb ' . a:count
            let t:markrun = 1
            " The user paragraph can create tabs, and finish with whatever tab
            " active - so we save the tab we just opened so we jump back to it
            execute 'norm ' . printf("'%s%s\<c-o>", a:mark, a:cmd)
            " Jump back to the fresh tab we marked with a tab-local value
            let IsMarkTab = {k, v -> gettabvar(v, 'markrun', -1) == -1 ? 0 : k + 1}
            let marktabs = filter(map(range(1, tabpagenr('$')), l:IsMarkTab), 'v:val')
            " TODO: handle when this array has more than one tab
            "       (i.e. somehow WE left one open previously)
            execute 'tabn ' . l:marktabs[-1]
            unlet t:markrun
            " Then do the "post" work (maybe close a win, maybe a whole tab)
            execute 'norm ' . printf("%s", a:rst)
        endif
    endfunction

    for ltr in "abcdefghijklmnopqrstuvwxyz"
        execute 'nnoremap <leader>emc' . l:ltr . ' <cmd>call ExecuteMark(v:count, "'.l:ltr.'","\\epc","\\a,\\ac")<cr>'
        execute 'nnoremap <leader>eml' . l:ltr . ' <cmd>call ExecuteMark(v:count, "'.l:ltr.'","\\epl","\\a,\\ac")<cr>'
        execute 'nnoremap <leader>emr' . l:ltr . ' <cmd>call ExecuteMark(v:count, "'.l:ltr.'","\\epr","\\a,\\ac")<cr>'
        " NOTE:  \eld is LINE based, while the rest of these are PARAGRAPH based
        execute 'nnoremap <leader>emd' . l:ltr . ' <cmd>call ExecuteMark(v:count, "'.l:ltr.'","\\eld","\\a,\\ac")<cr>'
        execute 'nnoremap <leader>ema' . l:ltr . ' <cmd>call ExecuteMark(v:count, "'.l:ltr.'","\\eps","\\a,\\zz")<cr>'
    endfor
endfunction
call InitMarkExecuteMaps()

nnoremap <leader>wad  <nop>
nnoremap <leader>wad? :echo "Watch difference hightlighting is: " . (g:WatchHighlightDiffs == 1 ? "on" : "off")<cr>
nnoremap <leader>wadd :let g:WatchHighlightDiffs = 0<cr>:norm \wad?<cr>
nnoremap <leader>wade :let g:WatchHighlightDiffs = 1<cr>:norm \wad?<cr>

nnoremap <leader>wal  :<c-u><c-r>=LineAsWatchCmd(v:count)<cr><cr><c-w>:sleep 750ms<cr><c-w>:resize <c-r>=2+getbufinfo("%")[0]["linecount"]<cr><cr><c-w>:set wfh<cr><c-w>p
nnoremap <leader>wvl  :<c-u>vert <c-r>=LineAsWatchCmd(v:count)<cr><cr><c-w>:set wfw<cr><c-w>p

nnoremap <leader>waq  <c-w>j<c-w><c-c>
nnoremap <leader>wvq  <c-w>l<c-w><c-c>

""
"" For paragraphs
""
"" e.p.   : [E]xecute [R][L] [P]aragraph [F][C]
"" NEW:
"" epr    : [E]xecute [P]aragraph [R]un      -- w/o count: "free", w/ count: "capture"
"" epl    : [E]xecute [P]aragraph [L]aunch   -- w/o count: "free", w/ count: "capture"
"" epc    : [E]xecute [P]aragraph [C]ommands -- count not used (runs each line as VIM command)
"" NEW:
"" epsr   : [E]xecute [P]aragraph [S]plit [R]un      -- w/o count: "free", w/ count: "capture"

nnoremap <leader>ep   <nop>
if has('win32')
    nnoremap <leader>epr  :<c-u>silent !<c-r>=InnerParagraphAsShellCmd(v:count, 1)<cr><cr>
    nnoremap <leader>epl  :<c-u>silent !<c-r>=InnerParagraphAsShellCmd(v:count, 0)<cr><cr>
else
    nnoremap <leader>epr  :<c-u>!<c-r>=InnerParagraphAsShellCmd(v:count, 1)<cr><cr>
    nnoremap <leader>epl  :<c-u>!<c-r>=InnerParagraphAsShellCmd(v:count, 0)<cr><cr>
endif

nnoremap <leader>epd  <nop>
nnoremap <leader>epdr :<c-u>put =InnerParagraphAsShellCmd(v:count, 1)<cr>
nnoremap <leader>epdl :<c-u>put =InnerParagraphAsShellCmd(v:count, 0)<cr>
nnoremap <leader>epds :<c-u>put =InnerParagraphAsSplitCmd(v:count)<cr>

nnoremap <leader>eps :<c-u>term ++close <c-r>=InnerParagraphAsSplitCmd(v:count)<cr><cr><c-w>:set wfh<cr><c-w>p
nnoremap <leader>epv :<c-u>vert term ++close <c-r>=InnerParagraphAsSplitCmd(v:count)<cr><cr><c-w>:set wfw<cr><c-w>p

nnoremap <leader>epc  :call ExecuteInnerParagraph()<cr>
"}}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" These options have been with me for a while - not sure where they came from
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" personal preferences "{{{
""
"" Basic options that should always be set
""
set hidden			"" keeps buffers alive when the window/tab closes
set path=.,,**,~/**,~/bin,/usr/include
""
"" For managing tabs/buffers
""
"set switchbuf=usetab    "" req's vim 7.2:  ,newtab
"set tabpagemax=20
""
"" These setup a basic form of auto-indenting that applies to all file types
""
set autoindent
set smartindent
"" This makes a hotkey to toggle smart indent locally for a buffer
nnoremap <leader>si :setl si! si?<cr>
nnoremap <leader>ci :setl cin! cin?<cr>
nnoremap <leader>ai :setl ai! ai?<cr>

"" Cliff-notes on tab properties:
""
""      expandtab       never put in '\t' chars
""      tabstop=4       size of a '\t' char
""      shiftwidth=4    size of an "indent"  ('<<' and '>>')
""      softtabstop=4   size of pressing 'tab' or 'backspace'
""      smarttab        when on, tab/bs @ front of line uses 'shiftwidth'
""                      (@ other places, 'tabstop' or 'softtabstop' is used)
""                      when off, tab/bs uses 'tabstop' or 'softtabstop' everywhere
""
function! ShowTabSettings(count)
	execute 'set expandtab?'
	execute 'set tabstop?'
	execute 'set shiftwidth?'
	execute 'set softtabstop?'
endfunc
function! SetSpaceSize(count)
	execute 'set expandtab'
	"" NOTE:  because I use the 'vim-stabs' plugin, it over-rides the '=' key
	""        when 'equalprg' is set, 'vim-stabs' honors it as an over-ride
	""        therefore, I default to allowing 'vim-stabs' to handle things
	""        but if it goes wonky, this mapping can setup my own tool
	""        (the mapping is redefined every time, to honor 'a:count')
	execute 'nnoremap <leader>se :<c-u>set equalprg=tabtool\ -tw\ ' . a:count . '\ -cls<cr>'
	execute 'set tabstop=' . a:count
	execute 'set shiftwidth=' . a:count
	execute 'set softtabstop=' . a:count
	echo "Set spaces to be:  " . a:count
endfunc
function! SetTabSize(count)
	execute 'set noexpandtab'
	execute 'nnoremap <leader>se :<c-u>set equalprg=tabtool\ -tw\ ' . a:count . '\ -clt<cr>'
	execute 'set tabstop=' . a:count
	execute 'set shiftwidth=' . a:count
	execute 'set softtabstop=' . a:count
	echo "Set tabs to be:  " . a:count
endfunc

" NOTE:  if you provide a count of ZERO -- it displays the curret settings
nnoremap <expr> <leader>ss ":<c-u>call " . (v:count ? "SetSpaceSize" : "ShowTabSettings") . "(v:count)<cr>"
nnoremap <expr> <leader>st ":<c-u>call " . (v:count ? "SetTabSize" : "ShowTabSettings") . "(v:count)<cr>"
" 'smarttab' does not have to be in the functions and re-adjusted every time
execute 'set smarttab'
execute "silent normal 4\\ss\\se"


"" This is new after I started using this file with MacVIM on my new Macbook
"" Perhaps this is just from a newer version of VIM behind it all
""    see:  https://github.com/vim/vim/issues/989
let g:python_recommended_style=0
"}}}


" grep'ing preferences "{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" These settings are all about "searching":   'grepprg' and the like
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" https://aonemd.github.io/blog/finding-things-in-vim

"" NOTE:  I just found a TREASURE of a S.O. answer regarding some GREAT searching options...
"         https://vi.stackexchange.com/a/8858/9912
"
" Additional pages related to setting 'ag' as the grepprg option:
"   https://codeinthehole.com/tips/using-the-silver-searcher-with-vim/
"   https://aonemd.github.io/blog/finding-things-in-vim
"   Searching in hidden files:  --hidden
"   Searching vcs ignored:  -U (stuff specified in .gitignore, and the like, will also be searched)
"   Searching unrestricted:  -u (nothing is ignored, EVEN the cmd-line '--ignore' specified stuff)
"
"      * if the windows attribute "h" is set -- AG does not consider that "hidden"
"        * HOWEVER, if the file starts with a DOT (eg: .filename) that WILL be considered hidden
"        * files ending with '~' are not considered hidden either
"
"      * if '-t' is specified the '--ignore' cmd line option is DISREGARDED!!!!
"        * same with '-u' (for unrestricted)
"
"      * if '-U' (ignore vcs ignore files) is present, '--ignore' cmd-line is still honored :D
"

"
" Also:  about 'ag' - if you specify 'nogroup' (implies *both* nobreak &
"         noheading) ...   and THEN also specify 'noheading'...    you get BREAKS
let s:ag_cmd = 'ag\ --depth\ 50\ --hidden\ --ignore\ tags\ --vimgrep\ --silent\ $*'
let s:gg_cmd = 'ggrep\ -PIn\ $*'
"" On my windows there is a Cygwin version of GNU grep renamed "cgrep"
" Currently the only option differences:    -H and -r  (maybe can be removed)
let s:cg_cmd = 'cgrep\ -PIHnr\ $*'
let s:gr_cmd = 'grep\ -PIHn\ $*'

if executable('ag')
	execute 'set grepprg=' . s:ag_cmd
elseif executable('ggrep')
	execute 'set grepprg=' . s:gg_cmd
elseif executable('cgrep')
	execute 'set grepprg=' . s:cg_cmd
else
	execute 'set grepprg=' . s:gr_cmd
endif

"nnoremap        <leader>g         <nop> # This is done elsewhere in this file
nnoremap        <leader>gr        <nop>
nnoremap        <leader>gr?       :set grepprg?<cr>
nnoremap <expr> <leader>gr<space> ':lgrep! '
nnoremap        <leader>gc        <nop>
nnoremap <expr> <leader>gc<space> ':Redir !' . GrepPrgForCmd() . ' '

" Next we map some mappings to switch between the programs on system that have more than one choice
nnoremap <leader>gra <nop>
if executable('ag')
	execute 'nnoremap <leader>grag :set grepprg=' . s:ag_cmd . '<cr>'
else
	execute 'nnoremap <leader>grag <cmd>echo "ag not found on this system"<cr>'
endif
" NOTE:  no 'elseif'   -- all mappings defined if programs exist
nnoremap <leader>grg <nop>
if executable('ggrep')
	execute 'nnoremap <leader>grgg :set grepprg=' . s:gg_cmd . '<cr>'
else
	execute 'nnoremap <leader>grgg <cmd>echo "ggrep not found on this system"<cr>'
endif
nnoremap <leader>grc <nop>
if executable('cgrep')
	execute 'nnoremap <leader>grcg :set grepprg=' . s:cg_cmd . '<cr>'
else
	execute 'nnoremap <leader>grcg <cmd>echo "cgrep not found on this system"<cr>'
endif
execute 'nnoremap <leader>grgr :set grepprg=' . s:gr_cmd . '<cr>'
nnoremap <leader>grd <nop>
nnoremap <leader>grdf :set grepprg&<cr>

nnoremap <leader>grn <nop>
nnoremap <leader>grnv :set grepprg=<c-r>=escape(substitute(&grepprg, '--vimgrep ', '', ''), ' "\()\|')<cr><cr>
nnoremap <leader>grnb :set grepprg=<c-r>=escape(substitute(&grepprg, '--search-binary ', '', ''), ' "\()\|')<cr><cr>
nnoremap <leader>grab :set grepprg=<c-r>=escape(substitute(&grepprg, '\$\*$', '--search-binary $*', ''), ' "\()\|')<cr><cr>
nnoremap <leader>grns :set grepprg=<c-r>=escape(substitute(&grepprg, '--silent ', '', ''), ' "\()\|')<cr><cr>
nnoremap <leader>grdv :set grepprg=<c-r>=escape(substitute(&grepprg, '\$\*$', '--ignore .git --ignore node_modules --ignore .venv --ignore ''*js.map'' $*', ''), ' "\()\|')<cr><cr>
nnoremap <leader>grch :set grepprg=<c-r>=escape(&grepprg, ' "\()\|')<cr>
" NOTE: above, the '|' char needs to be escaped, while '\' does not,
"       so the first '\' means itself and is not affecting the '(' right after it


" NOTE:  these INTENTIONALLY end with a space!
"        now protected by using '<expr>' style mappings
function! GrepEscape(val)
    "" # I found that if the current selection or WORD contains quotes,
    "" # they need to be escaped also.  YET, I am not sure that this
    "" # cleaning belongs in either of the two helpers already used here.
    "" # So, I'm doing the double-quote escaping here in GrepEscape()
    return VimCmdEscape(escape(PerlRxEscape(a:val), '"'))
endfunction
function! GrepPrgForCmd()
    return join(split(&grepprg, ' ')[:-2], ' ')
endfunction
if has('macunix')
    let g:shellq = "'"
else
    let g:shellq = '"'
endif
nnoremap        <leader>gw  <nop>
nnoremap <expr> <leader>gwc ':Redir !' . GrepPrgForCmd() . ' ' . g:shellq . GrepEscape(expand('<cword>')) . g:shellq . ' '
nnoremap <expr> <leader>gwl ':lgrep! ' . g:shellq . GrepEscape(expand('<cword>')) . g:shellq . ' '
nnoremap        <leader>ga  <nop>
nnoremap <expr> <leader>gac ':Redir !' . GrepPrgForCmd() . ' ' . g:shellq . GrepEscape(expand('<cWORD>')) . g:shellq . ' '
nnoremap <expr> <leader>gal ':lgrep! ' . g:shellq . GrepEscape(expand('<cWORD>')) . g:shellq . ' '
nnoremap        <leader>gl  <nop>
nnoremap <expr> <leader>glc ':Redir !' . GrepPrgForCmd() . ' ' . g:shellq . GrepEscape(getline(".")) . g:shellq . ' '
nnoremap <expr> <leader>gll ':lgrep! ' . g:shellq . GrepEscape(getline(".")) . g:shellq . ' '
xnoremap        <leader>gw  <nop>
xnoremap <expr> <leader>gwc ':<c-u>Redir !' . GrepPrgForCmd() . ' ' . g:shellq . '<c-r>=GrepEscape(VisualSelection())<cr>' . g:shellq . ' '
xnoremap <expr> <leader>gwl ':<c-u>lgrep! ' . g:shellq . '<c-r>=GrepEscape(VisualSelection())<cr>' . g:shellq . ' '

" \cf == C-lean F-ile listing   (the output of llist or clist -- so things like gF and CTRL-W_F work)
nnoremap <leader>cf :%s/\v^%( *\d+ )?(.{-}):(\d+%( col \d+)?):/\1 \2 :/<cr>
nnoremap <leader>ch :%s/\v^ *\d+:? //<cr>


""
"" Here I'm creating a 3-letter shortcut for `substitute()`
""
function! Sub(...)
    return call('substitute', a:000)
endfunc

""
"" Cool function to simplify "search all open buffers", from here:
""     https://stackoverflow.com/questions/11975174/how-do-i-search-the-open-buffers-in-vim
""
funct! GallFunction(re)
  ""
  "" NOTE:  this depends on 'errorformat' having a VALID value :(
  ""        for a while I have had it set to EMPTY by default down
  ""        below because it seemed to interfere with :Dispatch.
  ""
  ""        HOWEVER, I just commented out my command below that always set it to empty
  ""
  ""        I may be able to solve the :Dispatch problem using
  ""        compiler definitions under "~/.vim/vimfiles/compiler"
  ""        From the :Dispatch help...
  ""            :Dispatch picks a compiler by looking for either
  ""            CompilerSet makeprg={program}\ [arguments] or
  ""            CompilerSet makeprg={program} in compiler plugins.
  ""            To force a given {program} to use a given {compiler},
  ""            create ~/.vim/after/compiler/{compiler}.vim and add to
  ""            it a line like the following: >
  ""
  cexpr []
  execute 'echo "noautocmd bufdo grepadd ' . escape(a:re, '"') . '" "%"'
  " I think I prefer 'grep' so it uses PCRE via my 'grepprg' setting
  "execute 'silent! noautocmd bufdo vimgrepadd /' . a:re . '/j "%"'
  execute 'silent! noautocmd bufdo grepadd ' . a:re . ' "%"'
  cw
endfunct
" Command to Grep through all open buffers
command! -nargs=1 Gall call GallFunction(<q-args>)
command! -nargs=1 GrepAll call GallFunction(<q-args>)
"}}}


" settings related to saving folds in 'viewdir' (:h 'viewdir') "{{{
" https://vi.stackexchange.com/questions/13864/bufwinleave-mkview-with-unnamed-file-error-32

augroup AutoSaveGroup_Views
  "autocmd!
  "" view files are about 500 bytes
  "" bufleave but not bufwinleave captures closing 2nd tab
  "" nested is needed by bufwrite* (if triggered via other autocmd)
  "" BufHidden for for compatibility with `set hidden`
  "autocmd BufWinLeave,BufLeave,BufWritePost,BufHidden,QuitPre ?* nested silent! mkview!
  "autocmd BufWinEnter ?* silent! loadview
augroup end

" # Function to permanently delete views created by 'mkview'
" #     from:  https://stackoverflow.com/a/28460676/5844631
" #
" #  NOTE:  the view will be re-created upon closing the buffer, unless other steps are taken
" #         such as:  :noautocmd bd
" #
function! MyDeleteView()
    let path = fnamemodify(bufname('%'),':p')
    " vim's odd =~ escaping for /
    let path = substitute(path, '=', '==', 'g')
    if empty($HOME)
    else
        if has('win32')
            let homeexpr = substitute($HOME, '\\', '\\\\', 'g')
            let path = substitute(path, '^'.homeexpr, '~', '')
        else
            let path = substitute(path, '^'.$HOME, '~', '')
        endif
    endif
	if has('win32')
        let path = substitute(path, ':', '=-', '')
        let path = substitute(path, '\\', '=+', 'g')
    else
        let path = substitute(path, '/', '=+', 'g')
    endif
    " view directory & final '=' decorator
    let path = &viewdir.'/'.path . '='

    echo "About to delete:  ".path
    if delete(path)
        echo "    Failed to delete: ".path
    else
        echo "    Deleted: ".path
    endif
endfunction

" # Command delview ( without having to create a Delview command :D )
CommandAbbrev delview call\ MyDeleteView()
" "}}}


" settings related to saving sessions "{{{

""
"" option:  'sessionoptions'  ('ssop')
"" Default value: blank,buffers,curdir,folds,help,options,tabpages,winsize,terminal
""
""     blank        empty windows
""     buffers      hidden and unloaded buffers, not just those in windows
""     curdir       the current directory
""     folds        manually created folds, opened/closed folds and local fold options
""     globals      global variables that start with an uppercase letter and contain at least one lowercase letter.  Only String and Number types are stored.
""     help         the help window
""     localoptions options and mappings local to a window or buffer (not global values for local options)
""     options      all options and mappings (also global values for local options)
""     skiprtp      exclude 'runtimepath' and 'packpath' from the options
""     resize       size of the Vim window: 'lines' and 'columns'
""     sesdir       the directory in which the session file is located will become the current directory (useful with projects accessed over a network from different systems)
""     slash        backslashes in file names replaced with forward slashes
""     tabpages     all tab pages; without this only the current tab page is restored, so that you can make a session for each tab page separately
""     terminal     include terminal windows where the command can be restored
""     unix         with Unix end-of-line format (single <NL>), even when on Windows or DOS
""     winpos       position of the whole Vim window
""     winsize      window sizes
""
set ssop=blank,buffers,curdir,folds,globals,help,options,resize,slash,tabpages,unix,winpos,winsize

function! SaveSession(name)
    if len(a:name) == 0
        let fname = ''
    else
        let fname = '_' . fnameescape(a:name)
    endif
    exe 'mksession! .vimsess' . l:fname
    exe 'wviminfo .viminfo' . l:fname
    "" #
    "" # TODO:  see if the '/' works just fine on Windows -- it should
    "" #        (my original '\' just broke on my MacOS)
    "" #
    exe 'set viminfofile=' . fnameescape(getcwd() . '/.viminfo' . l:fname)
endfunction
command! -nargs=? SaveSession call SaveSession(<q-args>)
CommandAbbrev saveses SaveSession

function! LoadSession(name)
    if len(a:name) == 0
        let fname = ''
    else
        let fname = '_' . fnameescape(a:name)
    endif
    exe 'rviminfo .viminfo' . l:fname
    exe 'silent! source .vimsess' . l:fname
    "" #
    "" # TODO:  see if the '/' works just fine on Windows -- it should
    "" #
    exe 'set viminfofile=' . fnameescape(getcwd() . '/.viminfo' . l:fname)
endfunction
command! -nargs=? LoadSession call LoadSession(<q-args>)
CommandAbbrev loadses LoadSession

nnoremap <leader>vs  <nop>
nnoremap <leader>vsl :LoadSession<cr>
nnoremap <leader>vss :SaveSession<cr>

" "}}}


" settings related to 'term' option "{{{

""
"" NOTE: the key codes sent into VIM sometimes differ, and it depends on the
""       terminal program used (i.e. iTerm2 or built-in Terminal)
""
"" For figuring out the key codes the Terminal sends in, use this:
""          sed -n l
"" or this:
""          cat -v
""

function! HandleTerm() abort
    " This function is designed to "FIX" the broken Screen TERMCAP settings
    " that block modified PgUp, PgDn, and other special keys (i.e. Ctrl+PgUp)
    " Here is a table of what the settings were for two different terminals:
    " ( NOTE:  the output came from `:set termcap` )

    "  +---------------------------+--------------------------+
    "  | xterm-256color            |  screen-256color         |
    "  +---------------------------+--------------------------+
    "  | t_@7 <End>       ^[[@;*F  |  t_@7 <End>       ^[[4~  |
    "  | t_F1 <F11>       ^[[23;*~ |  t_F1 <F11>       ^[[23~ | <-- BROKEN
    "  | t_F2 <F12>       ^[[24;*~ |  t_F2 <F12>       ^[[24~ | <-- BROKEN
    "  | t_k1 <F1>        ^[[11;*~ |  t_k1 <F1>        ^[OP   |
    "  | t_k2 <F2>        ^[[12;*~ |  t_k2 <F2>        ^[OQ   |
    "  | t_k3 <F3>        ^[[13;*~ |  t_k3 <F3>        ^[OR   |
    "  | t_k4 <F4>        ^[[14;*~ |  t_k4 <F4>        ^[OS   |
    "  | t_k5 <F5>        ^[[15;*~ |  t_k5 <F5>        ^[[15~ | <-- BROKEN
    "  | t_k6 <F6>        ^[[17;*~ |  t_k6 <F6>        ^[[17~ | <-- BROKEN
    "  | t_k7 <F7>        ^[[18;*~ |  t_k7 <F7>        ^[[18~ | <-- BROKEN
    "  | t_k8 <F8>        ^[[19;*~ |  t_k8 <F8>        ^[[19~ | <-- BROKEN
    "  | t_k9 <F9>        ^[[20;*~ |  t_k9 <F9>        ^[[20~ | <-- BROKEN
    "  | t_k; <F10>       ^[[21;*~ |  t_k; <F10>       ^[[21~ | <-- BROKEN
    "  | t_kB <S-Tab>     ^[[Z     |  t_kB <S-Tab>     ^[[Z   |
    "  | t_kD <Del>       ^[[3;*~  |  t_kD <Del>       ^[[3~  | <-- BROKEN
    "  | t_kI <Insert>    ^[[2;*~  |  t_kI <Insert>    ^[[2~  | <-- BROKEN
    "  | t_kN <PageDown>  ^[[6;*~  |  t_kN <PageDown>  ^[[6~  | <-- BROKEN
    "  | t_kP <PageUp>    ^[[5;*~  |  t_kP <PageUp>    ^[[5~  | <-- BROKEN
    "  | t_kb <BS>        ^?       |  t_kb <BS>        ^?     |
    "  | t_kd <Down>      ^[O*B    |  t_kd <Down>      ^[OB   | <-- BROKEN
    "  | t_kh <Home>      ^[[@;*H  |  t_kh <Home>      ^[[1~  |
    "  | t_kl <Left>      ^[O*D    |  t_kl <Left>      ^[OD   | <-- BROKEN
    "  | t_kr <Right>     ^[O*C    |  t_kr <Right>     ^[OC   | <-- BROKEN
    "  | t_ku <Up>        ^[O*A    |  t_ku <Up>        ^[OA   | <-- BROKEN
    "  +---------------------------+--------------------------+
    " The entries marked "BROKEN" above are missing the '*' that
    " captures modifier keys like Shift and Ctrl.
    " The other differences are left alone by me.  They are too different, and
    " I don't have a full handle on why, or ramifications on those.

    if &term !~ 'xterm'
        "set t_F1=[23;*~
        "set t_F2=[24;*~
        "set t_k5=[15;*~
        "set t_k6=[17;*~
        "set t_k7=[18;*~
        "set t_k8=[19;*~
        "set t_k9=[20;*~
        "set t_k;=[21;*~
        "set t_kD=[3;*~
        "set t_kI=[2;*~
        set t_kN=[6;*~
        set t_kP=[5;*~
        set t_kd=O*B
        set t_kl=O*D
        set t_kr=O*C
        set t_ku=O*A
    endif
endfunction
" On first load: handle the initial 'term' value here
if ! exists("s:term_has_been_handled")
    let s:term_has_been_handled = 1
    call HandleTerm()
endif
" For our mappings, it is reinvoked each time they change it

" I'm also mapping some codes back to the default keys
" BUT I'm not sure if this works, or is the best way, or is even necessary
" AND I tried this before adding the above direct adjustment of 't_..' options
" SO I am leaving it commented out for now, since it might still be useful,
" and perhaps move into the above HandleTerm() function
"if &term == 'screen-256color'
"    map  <esc>[5;5~  <c-pageup>
"    vmap <esc>[5;5~  <c-pageup>
"    map! <esc>[5;5~  <c-pageup>
"    map  <esc>[5;6~  <c-down>
"    vmap <esc>[5;6~  <c-down>
"    map! <esc>[5;6~  <c-down>
"    map  <esc>[1;5H  <c-home>
"    vmap <esc>[1;5H  <c-home>
"    map! <esc>[1;5H  <c-home>
"    map  <esc>[1;5F  <c-end>
"    vmap <esc>[1;5F  <c-end>
"    map! <esc>[1;5F  <c-end>
"    map  <esc>[A     <c-up>
"    vmap <esc>[A     <c-up>
"    map! <esc>[A     <c-up>
"    map  <esc>[B     <c-down>
"    vmap <esc>[B     <c-down>
"    map! <esc>[B     <c-down>
"    map  <esc>[1;5D  <c-left>
"    vmap <esc>[1;5D  <c-left>
"    map! <esc>[1;5D  <c-left>
"    map  <esc>[1;5C  <c-right>
"    vmap <esc>[1;5C  <c-right>
"    map! <esc>[1;5C  <c-right>
"endif

nnoremap        <leader>te  <nop>
nnoremap        <leader>te?       :set term?<cr>
nnoremap        <leader>te&       :set term&<cr>
nnoremap <expr> <leader>te<space> ':set term='
nnoremap        <leader>tex       :set term=xterm-256color<cr>:call HandleTerm()<cr>:set term?<cr>
nnoremap        <leader>tet       :set term=tmux-256color<cr>:call HandleTerm()<cr>:set term?<cr>
nnoremap        <leader>tes       :set term=screen-256color<cr>:call HandleTerm()<cr>:set term?<cr>
" "}}}


" settings related to 'diff' mode "{{{
set diffopt+=vertical
"" Disabling these two in favor of using the unimpaired shortcuts
"nnoremap <leader>df :diffoff<cr>
"nnoremap <leader>dt :diffthis<cr>
nnoremap <leader>xbdf :bufdo diffoff<cr>
nnoremap <leader>du :diffupdate<cr>

" Here we create handy mappings to "diff against ..." left/right/up/down
nnoremap <leader>da  <nop>
nnoremap <leader>dah <cmd>norm <c-w>hyod<c-w>p<cr>
nnoremap <leader>dal <cmd>norm <c-w>lyod<c-w>p<cr>
nnoremap <leader>daj <cmd>norm <c-w>jyod<c-w>p<cr>
nnoremap <leader>dak <cmd>norm <c-w>kyod<c-w>p<cr>

" This is a functional version of an expression that cleanly lists all the windows
" currently in 'diff' mode.  from:  https://vi.stackexchange.com/a/16949/9912
function! ListDiffs()
    let diffs = []
    for widx in range(1, winnr('$'))
        if getwinvar(l:widx, "&diff")
            let msg = "windows:".l:widx." buffer:".winbufnr(l:widx)." -> ".bufname(winbufnr(l:widx))
            call add(l:diffs, l:msg)
        endif
    endfor
    return l:diffs
endfunction
nnoremap <leader>dl :echo join(ListDiffs(), "\n")<cr>

"
" Here I create two handy wrappers around the built-in 'do' and 'dp' commands
" thae automatically jump to the next change - AND can be repeated with '.' :D
" (For an example that uses the <Plug> facility, see:  https://vi.stackexchange.com/a/9547/9912)
"      Two examples of how to invoke a <Plug> mapping:
"            nmap <leader>do <Plug>VimdiffGet
"            nmap <leader>do :execute "normal \<Plug>VimdiffGet"<cr>
"
function! DiffOp(op, count) range
    exe 'normal' (a:count == 0 ? a:op : a:count . a:op)
endfunction
nnoremap <silent> <Plug>VimdiffGet :<c-u>call DiffOp('do', v:count)<cr>]czz:silent! call repeat#set("\<Plug>VimdiffGet", v:count)<cr>
nnoremap <silent> <Plug>VimdiffPut :<c-u>call DiffOp('dp', v:count)<cr>]czz:silent! call repeat#set("\<Plug>VimdiffPut", v:count)<cr>
""
"" below i just call the new '<Plug>'-defined mapping - but unfortunately I cannot provide a {count}.
"" while trying, I learned this does the same thing:
""                   nmap <leader>do :execute "normal \<Plug>VimdiffGet"<cr>
""                   (but it too does not accept a count value)
""
nmap <leader>do <Plug>VimdiffGet
nmap <leader>dp <Plug>VimdiffPut


"function! VimdiffUpdate(dir, cnt)
"	let idx = 0
"	while l:idx < a:cnt
"		if a:dir == 'o'
"			diffget
"		else
"			diffput
"		endif
"		normal "]czz"
"	endwhile
"	repeat#set("VimDiffUpdate", v:count)
"endfunc
"command! -bar -count VimdiffGet call VimdiffUpdate('get',<count>)
"command! -bar -count VimdiffPut call VimdiffUpdate('put',<count>)

" This is here to manually re-run the commands that I have in my p4vimdiff.sh script
nnoremap <leader>ds :set diffopt=filler<cr>:wincmd =<cr>:normal gg]c<cr>:redraw!<cr>
nnoremap <leader>df   <nop>
nnoremap <leader>dfo  <nop>
nnoremap <leader>dfo? :set diffopt?<cr>
nnoremap <leader>dw  <nop>
nnoremap <leader>dwi :set diffopt+=iwhite<cr>
nnoremap <leader>dww :set diffopt-=iwhite<cr>
nnoremap <leader>dc  <nop>
nnoremap <leader>dci :set diffopt+=icase<cr>
nnoremap <leader>dcc :set diffopt-=icase<cr>
function! SetDiffContext(count) range
    let opts = filter(split(&diffopt, ','), 'v:val !~ "^context"')
    if a:count != 0
        call add(l:opts, 'context:' . a:count)
    endif
    let &diffopt=join(l:opts, ',')
endfunction
nnoremap <leader>dx :<c-u>call SetDiffContext(v:count)<cr>
" This also switch tabs when diff mode is not ON
function! PageKeysForDiffs()
    return bufname('%') =~# 'fugitive:\\' || &diff
endfunction
nnoremap <expr> <c-pageup>   PageKeysForDiffs() ? ':normal [czz<cr>' : ':tabprev<cr>'
nnoremap <expr> <c-pagedown> PageKeysForDiffs() ? ':normal ]czz<cr>' : ':tabnext<cr>'

function! FindFirstDiff(line1, line2) abort
    " Inner helper function to advance to next character that "*Matters*"
    " (when ignoring white, this is anything but a whitespace)
    function! s:FFAdv(i, l, ignore) abort
        let rv = a:i + 1
        if a:ignore
            while a:l[l:rv] =~ '\s'
                let rv = l:rv + 1
            endwhile
        endif
        return l:rv
    endfunction

    let ignore_ws = &diffopt =~ 'iwhite\|iwhiteall'
    let min_len = min([len(a:line1), len(a:line2)])
    let diff_pos = -1

    " Compare character by character
    let i1 = 0
    let i2 = 0
    while l:i1 < l:min_len && l:i2 < l:min_len
        if a:line1[l:i1] != a:line2[l:i2]
            let l:diff_pos = l:i1
            break
        endif

        let i1 = s:FFAdv(l:i1, a:line1, l:ignore_ws)
        let i2 = s:FFAdv(l:i2, a:line2, l:ignore_ws)
    endwhile

    " If no difference found in common length, check if lengths differ
    if l:diff_pos == -1 && len(a:line1) != len(a:line2)
        let l:diff_pos = l:min_len
    endif

    return l:diff_pos
endfunction

function! JumpToFirstCharDiff()
    " Check if we're in diff mode
    if !&diff
        echo "Not in diff mode"
        return
    endif

    " Get current line number and content
    let l:current_line_num = line('.')
    let l:current_line = getline(l:current_line_num)

    " Find the other diff buffer
    let l:current_bufnr = bufnr('%')
    let l:current_winnr = winnr()
    let l:other_bufnr = -1
    let l:other_winnr = -1

    " Look through all windows to find another diff buffer
    for l:winnr in range(1, winnr('$'))
        let l:bufnr = winbufnr(l:winnr)
        if l:bufnr != l:current_bufnr && getwinvar(l:winnr, '&diff')
            let l:other_winnr = l:winnr
            let l:other_bufnr = l:bufnr
            break
        endif
    endfor

    if l:other_bufnr == -1
        echo "No other diff buffer found"
        return
    endif

    " Find the corresponding line in the other buffer using diff mapping
    " We need to switch to the other window temporarily to get the correct line
    execute l:other_winnr . 'wincmd w'
    "execute 'syncbind'
    let l:other_line_num = line('.')
    let l:other_line_content = getline(l:other_line_num)

    " Switch back to original window
    execute l:current_winnr . 'wincmd w'

    " Find first different character
    let l:diff_pos = FindFirstDiff(l:current_line, l:other_line_content)

    " Move cursor to the differing position
    if l:diff_pos >= 0
        " Move to column (add 1 because Vim columns are 1-indexed)
        call cursor(l:current_line_num, l:diff_pos + 1)
        echo "Jumped to first difference at column " . (l:diff_pos + 1)
    else
        echo "No difference found on this line"
    endif
endfunction

" Create a command to call the function
command! FirstCharDiff call JumpToFirstCharDiff()
nnoremap <leader>d0 <cmd>FirstCharDiff<cr>

""
"" These mappings are for "normalizing" text so LOGS may compare easier
""
"
" They are NON-expression based mappings:  b/c they MUST call a user command, and I'm not sure
" how to do that while staying in normal mode, so... just drop into command mode right away.
"
" The user-command MUST exist to consume the initial COUNT typed by the user before activating the mapping
"
" That COUNT becomes the PID or TID suffix, so 1\dnp... will convert the PID under the cursor to PID1 in the text under the motion.
" (w/o the user command, that COUNT *became* the motion, and the motion-pending destination was ENTIRELY IGNORED)
" (so the user-command must be "consuming" that COUNT, then the motion-pending destination is honored)
"
nnoremap <leader>dn   <nop>
nnoremap <leader>dni  :<c-u>NormalizeTimes<cr>g@
xnoremap <leader>dni  :<c-u>NormalizeTimes<cr>g@
nnoremap <leader>dnii :<c-u>NormalizeTimes<cr>g@_
nnoremap <leader>dnp  :<c-u>NormalizePIDs<cr>g@
xnoremap <leader>dnp  :<c-u>NormalizePIDs<cr>g@
nnoremap <leader>dnpp :<c-u>NormalizePIDs<cr>g@_
nnoremap <leader>dnt  :<c-u>NormalizeTIDs<cr>g@
xnoremap <leader>dnt  :<c-u>NormalizeTIDs<cr>g@
nnoremap <leader>dntt :<c-u>NormalizeTIDs<cr>g@_
nnoremap <leader>dnn  :<c-u>NormalizeLineNums<cr>g@
xnoremap <leader>dnn  :<c-u>NormalizeLineNums<cr>g@
nnoremap <leader>dnnn :<c-u>NormalizeLineNums<cr>g@_
nnoremap <leader>dnc  :<c-u>NormalizeChannelIDs<cr>g@
xnoremap <leader>dnc  :<c-u>NormalizeChannelIDs<cr>g@
nnoremap <leader>dncc :<c-u>NormalizeChannelIDs<cr>g@_
nnoremap <leader>dnr  :<c-u>NormalizeResponseIDs<cr>g@
xnoremap <leader>dnr  :<c-u>NormalizeResponseIDs<cr>g@
nnoremap <leader>dnrr :<c-u>NormalizeResponseIDs<cr>g@_

" Moved the old \fs mapping to be a "normalizing" mapping using the motion:
" ( NOTE:  this does NOT work if I use '<Cmd' instead of ':<c-u>' )
xnoremap <leader>fs   :<c-u>NormalizeDelete<cr>g@
xnoremap <leader>fv   :<c-u>NormalizeKeep<cr>g@

nnoremap <leader>dnl  :<c-u>NormalizeColorCodes<cr>g@
xnoremap <leader>dnl  :<c-u>NormalizeColorCodes<cr>g@
nnoremap <leader>dnll :<c-u>NormalizeColorCodes<cr>g@_
nnoremap <leader>dne  :<c-u>NormalizeEscapeCodes<cr>g@
xnoremap <leader>dne  :<c-u>NormalizeEscapeCodes<cr>g@
nnoremap <leader>dnee :<c-u>NormalizeEscapeCodes<cr>g@_
nnoremap <leader>dnm  :<c-u>NormalizeManCodes<cr>g@
xnoremap <leader>dnm  :<c-u>NormalizeManCodes<cr>g@
nnoremap <leader>dnmm :<c-u>NormalizeManCodes<cr>g@_

nnoremap <leader>dns  :<c-u>NormalizeSpaces<cr>g@
xnoremap <leader>dns  :<c-u>NormalizeSpaces<cr>g@
nnoremap <leader>dnss :<c-u>NormalizeSpaces<cr>g@_
nnoremap <leader>dnu  :<c-u>NormalizeUserName<cr>g@
xnoremap <leader>dnu  :<c-u>NormalizeUserName<cr>g@
nnoremap <leader>dnuu :<c-u>NormalizeUserName<cr>g@_
nnoremap <leader>dnh  :<c-u>NormalizeHostName<cr>g@
xnoremap <leader>dnh  :<c-u>NormalizeHostName<cr>g@
nnoremap <leader>dnhh :<c-u>NormalizeHostName<cr>g@_

"
" Quick TIP:  Here's a macro in the @q register to normalize with an automatically incrementing COUNT:
"             (works on thread values with the "t" normalize)
"
"     let @i = 0
"     let @q = ":exe 'norm '.@i.'\\dnt#'\n:let @i = @i + 1\nnzz"
"

"
" Here is the User command whose SOLE purpose is to CONSUME the count, so the g@'s above work
"
command! -count NormalizeTimes       call NormalizeMotionSetup(v:count, 'i')
command! -count NormalizePIDs        call NormalizeMotionSetup(v:count, 'p')
command! -count NormalizeTIDs        call NormalizeMotionSetup(v:count, 't')
command! -count NormalizeLineNums    call NormalizeMotionSetup(v:count, 'n')
command! -count NormalizeDelete      call NormalizeMotionSetup(v:count, 'd')
command! -count NormalizeKeep        call NormalizeMotionSetup(v:count, 'k')
command! -count NormalizeChannelIDs  call NormalizeMotionSetup(v:count, 'c')
command! -count NormalizeResponseIDs call NormalizeMotionSetup(v:count, 'r')
command! -count NormalizeColorCodes  call NormalizeMotionSetup(v:count, 'l')
command! -count NormalizeEscapeCodes call NormalizeMotionSetup(v:count, 'e')
command! -count NormalizeManCodes    call NormalizeMotionSetup(v:count, 'm')
command! -count NormalizeSpaces      call NormalizeMotionSetup(v:count, 's')
command! -count NormalizeUserName    call NormalizeMotionSetup(v:count, 'u')
command! -count NormalizeHostName    call NormalizeMotionSetup(v:count, 'h')


"
" Here are the functions that do the motion-pending normalize
"
function! NormalizeMotionSetup(count, type) abort
    let s:save_cursor = getcurpos()
    let str_cnt = printf("%02d", a:count)
    if a:type == 'i'
        let s:normalize_cmd = 's/\v%([-/0-9]{10}|\d{4}.[a-z]{3}.\d\d)[- ]\d\d:\d\d:\d\d\.\d+/TIME/'
    elseif a:type == 'p'
        let s:normalize_cmd = 's/\v(])( |\t)' . expand('<cword>') . '\2(:)/\1\2P_' . l:str_cnt . '\2\3/'
    elseif a:type == 't'
        let s:normalize_cmd = 's/\v(:)(%( |\t )?)' . expand('<cword>') . '\2([:\]])/\1\2T_' . l:str_cnt . '\2\3/'
    elseif a:type == 'n'
        let s:normalize_cmd = 's/\v(:)(%( |\t )?)([^:]{-})\(\d+\)\2([:\]])/\1\2\3(##)\2\4/'
    elseif a:type == 'd'
        let s:normalize_cmd = 'g/\v' . VimRxEscape(VisualSelection()) . '/d'
    elseif a:type == 'k'
        let s:normalize_cmd = 'v/\v' . VimRxEscape(VisualSelection()) . '/d'
    elseif a:type == 'c'
        let s:normalize_cmd = 'g/\v%( channel \{)@<=[^}]+%(})@=/call NormalizeGuidFromCurrentLine("channel", "CHANID")'
    elseif a:type == 'r'
        let s:normalize_cmd = 'g/\v%( response \{)@<=[^}]+%(})@=/call NormalizeGuidFromCurrentLine("response", "RESPID")'
    elseif a:type == 'l'
        let s:normalize_cmd = 's/\v(|\^\[)\[[0-9;]*m//g'
    elseif a:type == 'e'
        let s:normalize_cmd = 's/\v\^\[(\[\d+m)/\1/g'
    elseif a:type == 'm'
        let s:normalize_cmd = 's/\v_%x08|%x08.//g'
    elseif a:type == 's'
        let s:normalize_cmd = 's/\v[ \t]+$//'
    elseif a:type == 'u'
        let s:normalize_cmd = 's/\v<' . trim(system('whoami')) . '>/user/g'
    elseif a:type == 'h'
        let s:normalize_cmd = 's/\v<' . substitute(trim(system('hostname')), '\.local$', '', '') . '>/Host/g'
    else
        echoerr "Unknown type: [" . a:type . "]"
        call interrupt()
    endif
    let &opfunc = 'NormalizeMotion'
endfunction

function! NormalizeMotion(type) abort
    let b:normalize_cmd = s:normalize_cmd
    exe "'[,']" . s:normalize_cmd
    PopSearch
    call setpos('.', s:save_cursor)
endfunction

function! NormalizeGuidFromCurrentLine(expr, repl) abort
    let guid = tolower(substitute(getline('.'), '\v^.*' . a:expr . ' \{(.{36})\}.*$', '\1', ''))
    exe '% s/' . l:guid . '/' . a:repl . '/g'
endfunction
" "}}}

" Transposing text "{{{
""
"" These mappings came from here:
""     https://vim.fandom.com/wiki/Swapping_characters,_words_and_lines
""  which lead to here, where I copied them and switched the commenting to enable the simple versions
""     https://github.com/LucHermitte/lh-misc/blob/master/plugin/vim-tip-swap-word.vim
""
"" Creating the following mappings:  'gw', 'gW', 'gl', gr', 'gs', 'gS'
"" which over-ride built-ins that I will never use.
""
" NOTE:  `PopSearch()` however, came from a different repository from Luc Hermite.
"        here:  https://github.com/LucHermitte/lh-vim-lib/blob/master/plugin/lhvl.vim
command! PopSearch :call histdel('search', -1)| let @/=histget('search',-1)

" This mapping is in the "spirit" of Unimpaired, using '[' to mean previous
" (though there is no ']' equivalent)
nnoremap <leader>[/ :PopSearch<cr>

"" # " Swap the current word with the next, without changing cursor position
"" # nnoremap <silent> gw "_yiw:silent s/\(\%#\w\+\)\(\W\+\)\(\w\+\)/\3\2\1/<cr>:PopSearch<cr><c-o>
"" # " "left" would respect the old behaviour, but let's use "follow" instead!
"" # "nnoremap <silent> gw :call <sid>SwapWithNext('follow', 'w')<cr>

"" # nnoremap <silent> gW "_yiw:silent s/\(\w\+\)\(\W\+\)\(\%#\w\+\)/\3\2\1/<cr>:PopSearch<cr><c-o>
"" # "nnoremap <silent> gW :call <sid>SwapWithPrev('follow', 'w')<cr>

"" # " Swap the current word with the previous, keeping cursor on current word:
"" # " (This feels like "pushing" the word to the left.)
"" # nnoremap <silent> gl "_yiw?\w\+\_W\+\%#<CR>:PopSearch<cr>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>:PopSearch<cr><c-o><c-l>
"" # "nnoremap <silent> gl :call <sid>SwapWithPrev('left', 'w')<cr>

"" # " Swap the current word with the next, keeping cursor on current word: (This
"" # " feels like "pushing" the word to the right.) (See note.)
"" # nnoremap <silent> gr "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>:PopSearch<cr><c-o>/\w\+\_W\+<CR>:PopSearch<cr>
"" # "nnoremap <silent> gr :call <sid>SwapWithNext('right', 'w')<cr>

"" # " the same, but with keywords
"" # nnoremap <silent> gs "_yiw:silent s/\(\%#\k\+\)\(.\{-}\)\(\k\+\)/\3\2\1/<cr>:PopSearch<cr><c-o>
"" # nmap     <silent> gS "_yiw?\k?<cr>gs
"" # "nnoremap <silent> gs :call <sid>SwapWithNext('follow', 'k')<cr>
"" # "nnoremap <silent> gS :call <sid>SwapWithPrev('follow', 'k')<cr>
" "}}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Plugin section for vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-plug section    >>>  PLUGINs are in here  <<<    "{{{
function! AutoFetchVimPlug() abort
    let vim_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
    let plugvim = vim_dir . '/autoload/plug.vim'
    if empty(glob(plugvim))
        silent execute '!curl -fLo '.plugvim.' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
endfunction
call AutoFetchVimPlug()

" vim-plug Mappings: "{{{
"" # " `PlugInstall [name ...] [#threads]`  | Install plugins
nnoremap        <leader><leader>p         <nop>
nnoremap        <leader><leader>pi        <nop>
nnoremap <expr> <leader><leader>pii       ':PlugInstall<cr>'
nnoremap <expr> <leader><leader>pi<space> ':PlugInstall '
"" # " `PlugUpdate [name ...] [#threads]`   | Install or update plugins
nnoremap        <leader><leader>pu        <nop>
nnoremap <expr> <leader><leader>puu       ':PlugUpdate<cr>'
nnoremap <expr> <leader><leader>pu<space> ':PlugUpdate '
"" # " `PlugSnapshot[!] [output path]`      | Generate script for restoring the current snapshot of the plugins
nnoremap        <leader><leader>pn        <nop>
nnoremap <expr> <leader><leader>pnn       ':PlugSnapshot<cr>'
nnoremap <expr> <leader><leader>pn<space> ':PlugSnapshot '
"" # " `PlugClean[!]`                       | Remove unlisted plugins (bang version will clean without prompt)
nnoremap        <leader><leader>pc        :PlugClean<cr>
"" # " `PlugUpgrade`                        | Upgrade vim-plug itself
nnoremap        <leader><leader>pg        :PlugUpgrade<cr>
"" # " `PlugStatus`                         | Check the status of plugins
nnoremap        <leader><leader>ps        :PlugStatus<cr>
"" # " `PlugDiff`                           | Examine changes from the previous update and the pending changes
nnoremap        <leader><leader>pd        :PlugDiff<cr>

"" # " Set up the command line to manually load an unloaded plugin
nnoremap        <leader><Leader>pl        <nop>
nnoremap <expr> <leader><Leader>pl<space> ':call plug#load('
" }}}

call plug#begin()
" List your plugins here

"" I found this while searching around about Tmux mappings - and I'm gonna try it :)
""    Found here:  https://vimawesome.com/plugin/vim-tmux-navigator
""    Great writeup here:  https://gist.github.com/mislav/5189704
if has('macunix')
    "" Right now, I only use tmux on my MacOS dev box
    Plug 'christoomey/vim-tmux-navigator'
endif

" TPope plugins: "{{{
"" From vim-plug example
Plug 'tpope/vim-sensible'
"" Found through this question:  "how to convert html escape codes"
"" http://stackoverflow.com/questions/5733660/is-there-an-html-escape-paste-mode-for-vim
""   my fork of 'tpope/unimpaired'
Plug 'nebbish/vim-unimpaired', {'branch': 'neb-dev'}
"" Another helpful one:  adds shell commands with caps, e.g. :Rename (handles buffers too)
Plug 'tpope/vim-eunuch'
"" Much later I found this:  <-- don't use so much
Plug 'tpope/vim-abolish'
"" One of my favorites for helping with code editing!
Plug 'tpope/vim-surround'
"" Found this when I wanted to repeat my own mappings - surprised I didn't already have it
Plug 'tpope/vim-repeat'
"" Amazing assistance for working with Git repositories
Plug 'tpope/vim-fugitive'
"" Another one from tpope - that helps manage scripts (helps a developer of scripts)
Plug 'tpope/vim-scriptease'
"" Another one from tpope - that helps launch sub-programs
Plug 'tpope/vim-dispatch'
" "}}}

" Editor enhancing plugins: "{{{
"" Adds indent level (i) to vim motions (inner-indent, outer indent, ...)
"" Really good for languages like Python (which rely on indent level) !
Plug 'michaeljsmith/vim-indent-object'
"" Adds wildcard versions of :edit :split :tabedit....
Plug 'arp242/globedit.vim'
" "" Here are some 'object types' that work with the noun/verb command structure :D
" "" Found here:  https://blog.carbonfive.com/vim-text-objects-the-definitive-guide/
" ""      argument (a)       good for all languages
" Plug 'nebbish/argtextobj.vim', {'branch': 'neb-dev'}
"" When researching how text objects should work, I stumbled upon this COMPREHENSIVE plugin
Plug 'wellle/targets.vim'
"" I was looking for a way to pad lines to align a character in a column
"" This S.O. answer listed some options: https://superuser.com/a/771152/659417
"" I'm going with the vim-easy-align, because I like the inerface:
"" https://github.com/junegunn/vim-easy-align#tldr---one-minute-guide
Plug 'junegunn/vim-easy-align'
"" Found this when searching for a good way to swap words
""     see:  https://vim.fandom.com/wiki/Swapping_characters,_words_and_lines
"" There are other options -- I am trying this one for now :)
Plug 'kurkale6ka/vim-swap'
"" A bit simply than above, useful for small things with mappings defined below
Plug 'godlygeek/tabular'
Plug 'preservim/nerdcommenter'
"" Found this when looking up help for "nroff" for the '[[' and ']]' commands
Plug 'nebbish/jumpy.vim', {'branch': 'neb-dev'}
"" This adds manuall marking of many different matches each with their own color
Plug 'inkarkat/vim-mark'
"" The above needs the vim-ingo-library to work
Plug 'inkarkat/vim-ingo-library'
"" Found this when I learned that Gvim fonts are adjustable, handy for screensharing
Plug 'drmikehenry/vim-fontsize'
"" I wish I could make the built-in functionality meed the needs, but this
"" seems like a solid plugin -- if it all works
Plug 'wesQ3/vim-windowswap'
" Emoji assistance for Vim
Plug 'junegunn/vim-emoji'
" "}}}

" IDE feature plugins: "{{{
" CoC is an LSP for a ton of languages
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" This one provides a UnitTest framework
Plug 'junegunn/vader.vim'
" This one is really just a UT "launch helper", understanding many UT frameworks,
" providing commands to launch: nearest UT, first UT, whole suite, whole file...
Plug 'vim-test/vim-test'
" Markdown editing functionality
" NOTE:  if the 'godlygeek/tabular' plugin is also used it MUST be included
"        first. (i do use it, and it is included above)
Plug 'preservim/vim-markdown'
" NOTE:  this one requires a follow up command to finish the install
"        (or a fancier entry right here, so Plugged does it automatically)
"  CMD:  call mkdp#util#install()
Plug 'iamcco/markdown-preview.nvim'
" "}}}

" AI related plugins: "{{{
"" NOTE:  this was formerly:  Exafunction/codeium !!
Plug 'Exafunction/windsurf.vim', { 'branch': 'main' }
"Plug 'github/copilot.vim'
"Plug 'augmentcode/augment.vim'
" "}}}

" HTML editing plugins: "{{{
Plug 'nebbish/emmet-vim', {'branch': 'neb-dev'}
Plug 'alvan/vim-closetag'
Plug 'AndrewRadev/tagalong.vim'
" "}}}

" Utility adding plugins (dir tree, call tree, status bar, ..) "{{{
"" Co-worker pointed me towards this guy...  (I like it, and even forked it for an update of my own)
Plug 'nebbish/nerdtree', {'branch': 'neb-dev'}
Plug 'vim-airline/vim-airline'
"" Stumbled upon this while exploring peoples write-up comparison of CtrlP and CommandT
Plug 'jlanzarotta/bufexplorer'
"" I stumbled upon this handy page while searching for a built-in way to treat the current line as if an :Ex command and run it
""     https://www.hillelwayne.com/post/intermediate-vim/
"" On that page of great advice, was this little gem of a plugin:
Plug 'mbbill/undotree'
"" Here's something for comparing folders (I forked 'will133/vim-dirdiff')
Plug 'nebbish/vim-dirdiff', {'branch': 'neb-dev'}
" The Asciitable plugin creates the following mappings:
"    <leader>a8  - ascii table in octal
"    <leader>a10 - ascii table in decimal
"    <leader>a16 - ascii table in hex
Plug 'nebbish/Asciitable.vim'
" "}}}

"" Found these, trying to help use VIM for pure writing
" plugins for enhancing 'focus' (eliminating distractions) "{{{
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
" "}}}

" plugins for text colors and syntax highlighting "{{{
"" Found this when trying to fix ONE highlighting
"Plug 'coldfix/hexHighlight'
"Plug 'guns/xterm-color-table.vim'
Plug 'powerman/vim-plugin-AnsiEsc'
"" Found this when looking for better c++ highlighting
Plug 'octol/vim-cpp-enhanced-highlight'
"" Better Javascript syntax than the built in (handles flow JS)
Plug 'yuezk/vim-js'
"" Augments the syntax for JSX files to be More than just a symlink to JS syntax ;)
Plug 'maxmellon/vim-jsx-pretty'
" "}}}

" Color plugins: "{{{
"" Colors suggested by a good Vimcast: http://vimcasts.org/episodes/fugitive-vim-working-with-the-git-index/
Plug 'lifepillar/vim-solarized8'
"" More colorschemes, from:  https://vimcolorschemes.com/
Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'
Plug 'joshdick/onedark.vim'
"Plug 'sainnhe/sonokai'
"Plug 'kaicataldo/material.vim'
"Plug 'sonph/onehalf'
"Plug 'vigoux/oak'
Plug 'cocopon/iceberg.vim'
Plug 'rakr/vim-one'
Plug 'NLKNguyen/papercolor-theme'
Plug 'altercation/vim-colors-solarized'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'preservim/vim-colors-pencil'
Plug 'junegunn/seoul256.vim'
" "}}}

" Disabled plugins: "{{{
"" # " "" YCM:  Completions and tool tips.
"" # " ""  NOTE:  needs more work to be enabled - more installed, and more locally built dependencies :(
"" # " "Plug 'ycm-core/YouCompleteMe'
"" # " "" Current Matchit options:
"" # " ""   Original (I think):  https://github.com/chrisbra/matchit
"" # " ""   The one I used to include here: https://github.com/geoffharcourt/vim-matchit
"" # " ""   Enhanced:  https://github.com/andymass/vim-matchup
"" # " Plug 'chrisbra/matchit'
"" # " "" Found this one at: https://github.com/tmhedberg/SimpylFold
"" # " "" It is about proper folding of PY code
"" # " Plug 'tmhedberg/SimpylFold'
"" # " "" Found this one at: https://thoughtbot.com/blog/replacing-nerdtree-with-ctrl-p
"" # " Plug 'ctrlpvim/ctrlp.vim'
"" # " "" Found this one here:
"" # " Plug 'majutsushi/tagbar'
"" # " "" Found this from:  https://ricostacruz.com/til/navigate-code-with-ctags
"" # " Plug 'craigemery/vim-autotag'
"" # " "" Found this just by searching for something like it.   there are LOTS of forks that tweak it one way or another
"" # " ""    my fork of 'masaakif/nerdtree-useful-plugins'
"" # " Plug 'nebbish/nerdtree-useful-plugins', {'branch': 'neb-dev'}
"" # " "" This is meant to work with `ag` which I just installed
"" # " if !has('win32')
"" # "     Plug 'rking/ag.vim'
"" # " endif
"" # " "Plug 'Chun-Yang/vim-action-ag'
"" # " "" Found while looking for an easy way to jump b/w decl & defn   -- not that easy, even with CTags & CtrlP
"" # " ""Plug 'LucHermitte/lh-tags'     I'm not sure if I want this one - but I did not want to forget knowing about it ;)
"" # " "" A Git log browser that depends on fugitive - not that useful
"" # " "Plug 'junegunn/gv.vim'
"" # " "" This was something I found looking for "vim as a merge tool"
"" # " Plug 'sjl/splice.vim'
"" # " "" Here is another plugin for "generically" helping with conflict markers
"" # " "" (does not have any SCM specifics, just open a file with markers, and start it)
"" # " Plug 'samoshkin/vim-mergetool'
"" # " "" Stumbled across this while searching for something else...    but
"" # " "" considering my own VIM use case...   this is PERFECT for me :)  (if it works)
"" # " "Plug 'unblevable/quick-scope'
"" # " "" Found this while searching for a way to run the debugger from VIM.
"" # " ""    For `gdb`, there is a built-in feature:  `termdebug`
"" # " "" However, I now use a Mac - so I want to run LLDB also :)
"" # " ""   NOTE:  currently not working -- this VIM binary seg-faults when importing 'lldb'.
"" # " ""          See: https://www.mail-archive.com/lldb-dev@lists.llvm.org/msg07787.html
"" # " ""          also: https://reviews.llvm.org/D70252 update to docs to explain this
"" # " ""   If I use /usr/bin/vim - (came with Catalina) it works.   grrrrrrrrrrrr
"" # " "Plug 'gilligan/vim-lldb'
"" # " "" Found this looking for a way to transpose arond a comma, here:
"" # " ""     https://stackoverflow.com/a/14741301/5844631
"" # " Plug 'PeterRincker/vim-argumentative'
"" # " "" I discovered this when looking up ".editconfig" which is a CROSS-IDE config file!!
"" # " "" Apparently VS and IntelliJ, and Pycharm, and others all honor this tab-settings file
"" # " "" For VIM, though -- this plugin adds mappings for <tab> and <cr> to handle something
"" # " "" I'm calling "smart alignment", where tabs are used for the indent, but spaces are
"" # " "" used to align wrapped lines
"" # " "Plug 'Thyrum/vim-stabs'   NOTE:   Disbaled b/c of the 'o' and 'O' mappings
"" # " "" Kotlin syntax
"" # " Plug 'udalov/kotlin-vim'
"" # " "" This is "like" Boost for Vim -- what will be in the next version
"" # " "" (currently 2 years newer than what is on my MacOS, with changes I want)
"" # " "Plug 'tpope/vim-markdown'
"" # " Plug 'mzlogin/vim-markdown-toc'
"" # " Plug 'google/vim-searchindex'
"" # "
"" # " "Plug 'OmniSharp/omnisharp-vim'
" "}}}


call plug#end()
" "}}}


"" # " """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" # " "" This is for Vundle,  hosted on github here:  https://github.com/nebbish/Vundle.vim
"" # " "" Vundle is a 'plugin manager' (but really a 'runtimepath' manager) I forked that
"" # " "" helps with vim plugins:  installing/uninstalling/updating/...
"" # " """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" # " " Vundle section    >>>  PLUGINs are in here  <<<    "{{{
"" # " ""
"" # " "" It is based on pathogen, and supercedes it with ease of use - but requires 'git'
"" # " "" and will perform 'git clone' actions for each configured repository
"" # " ""
"" # " "" Brief Vundle help
"" # " "" :PluginList       - lists configured plugins
"" # " "" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
"" # " "" :PluginSearch foo - searches for foo; append `!` to refresh local cache
"" # " "" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"" # " ""
"" # " "" see :h vundle for more details or wiki for FAQ
"" # " ""
"" # " filetype off			"" required for Vundle to load, will be re-enabled below
"" # "
"" # " ""
"" # " "" NOTE:  Got this recipe for how to "bootstrap" a Vundle setup from a fresh
"" # " ""        system with only 'git' available.
"" # " ""  see:  https://gist.github.com/klaernie/db37962e955c82254fed
"" # " ""
"" # " "" I have modified it in the following ways:
"" # " ""    * to work on multiple platforms
"" # " ""    * to use :exe instead of :! so that no windows pop up
"" # " ""    * to activate my work branch from my Vundle fork
"" # " ""
"" # " set runtimepath+=~/.vim/bundle/Vundle.vim
"" # " let s:bootstrap = 0
"" # " let s:vundlerepo = 'https://github.com/nebbish/Vundle.vim.git'
"" # " let s:vundlehome = expand('~/.vim/bundle/Vundle.vim') " expand(...) also makes it OS specific
"" # " let s:bundledir = fnamemodify(s:vundlehome, ':h')
"" # " try
"" # " 	"
"" # " 	" NOTE:  I *want* to use shellescape() below for the path arguments, but since I need to run
"" # " 	"        this on BOTH Windows & *nix/Mac -- I need to manually surround with double quotes.
"" # " 	"
"" # " 	"           * On Windows  shellescape() surrounds with double quotes
"" # " 	"           * On *nix/mac shellescape() surrounds with single quotes
"" # " 	"
"" # " 	"        However, in both situations, this needs to work within:  exe "... system('... <here> ...') ..."
"" # " 	"
"" # "     exe "silent call system('cd \"" . s:vundlehome . "\" && git checkout neb-dev')"
"" # "     call vundle#begin()		"" can pass in a path for alternate plugin location
"" # " catch /\vE117:|E282:/
"" # "     let s:bootstrap = 1
"" # "     if has('win32')
"" # "         exe "silent call system('mkdir \"" . s:bundledir . "\"')"
"" # "         exe "silent call system('set GIT_DIR= && git clone " . s:vundlerepo . " \"" . s:vundlehome . "\"')"
"" # "     else
"" # "         exe "silent call system('mkdir -p \"" . s:bundledir . "\"')"
"" # "         exe "silent call system('unset GIT_DIR && git clone " . s:vundlerepo . " \"" . s:vundlehome . "\"')"
"" # "     endif
"" # "     let s:ocwd = getcwd()
"" # "     try
"" # "         exe 'cd ' . s:vundlehome
"" # "         exe "call system('git checkout neb-dev')"
"" # "     finally
"" # "         exe 'cd ' . s:ocwd
"" # "     endtry
"" # "     redraw!
"" # "     call vundle#begin()
"" # " endtry
"" # " ""   my fork of 'VundleVim/Vundle.vim'
"" # " Plugin 'nebbish/Vundle.vim', {'revision': 'neb-dev'} "" let Vundle manage Vundle, REQUIRED
"" # " ""
"" # " "" Other plugins here...
"" # " ""
"" # "
"" # "
"" # "
"" # " call vundle#end()			"" required
"" # "
"" # " if s:bootstrap
"" # "     silent PluginInstall
"" # "     quit
"" # " end
"" # "
"" # " filetype plugin indent on	"" required (the 'indent' clause is fine absent or present)
"}}}


" Settings related to 'keywordprog' "{{{

"" This is a filter for popup_create()
function! LookupFilter(winid, key) abort
    " NOTE:  return TRUE to indicate we handled the key
    "        when we do not, it goes to next popup, or VIM

    ""
    "" Reasons to close...
    ""
    " Close on ESC
    if a:key == "\<Esc>"
        call popup_close(a:winid)
        return 1
    endif
    " Close on any motion keys
    if match(a:key, '\v^(<Up>|<Down>|<Left>|<Right>|<PageUp>|<PageDown>|<Home>|<End>|[ hjklwbeftn\$\^0G])$') >= 0
        call popup_close(a:winid)
        return 1
    endif
    " Close on mouse click anywhere (including outside)
    if a:key =~ '\v^<(LeftMouse|RightMouse|MiddleMouse)'
        call popup_close(a:winid)
        return 1
    endif

    "" For any other key, close the popup (makes it very aggressive)
    "call popup_close(a:winid)
    "return 1
endfunction

"" This is a callback for popup_create()
function! LookupCallback(winid, result) abort
    " This gets called when popup closes, you can add cleanup here if needed
endfunction

""
"" NOTE: this has to be a custom command (below) that calls a function
""
""       do NOT set 'kp' to :call something
""       instead create a command that calls something
""       and set 'kp' to that command
""
function! LookupBibleReference(ref) abort
    let url = "https://bible-api.com/" . a:ref . "?translation=kjv"
    let cmd = "http GET '" . l:url . "' | jsontool"
    let res = json_decode(trim(system(l:cmd)))

    try
        let title = printf("  %s - %s %d  ", l:res['translation_name'],
                                           \ l:res['verses'][0]['book_name'],
                                           \ l:res['verses'][0]['chapter'])
        let lines = map(copy(l:res['verses']), 'trim(v:val["verse"] . ". " . tr(v:val["text"],"\n"," "))')
    catch
        let title = printf("  %s  ", a:ref)
        let lines = [l:res['error']]
    endtry

    " Also set the text into the quick un-named register
    let @" = join([trim(l:title), ''] + l:lines, "\n")

    "" The join & re-split is to account for verses with embedded line breaks
    "" and by doing this, we join it all up as we "would" want it,
    "" but then give it to the function the way it expects.
    call popup_create(split(join(l:lines, "\n"), "\n"), #{
                \ title: l:title,
                \ line: 'cursor+1',
                \ col: 'cursor+1',
                \ padding: [1,1,1,1],
                \ border: [],
                \ filter: 'LookupFilter',
                \ callback: 'LookupCallback',
            \ })
endfunction
command! -nargs=* -complete=command LookupBibleReference call LookupBibleReference(<f-args>)

function! ReadToken(path)
    "" Opens `a:path` and reads each line, ignoring comment lines, until
    "" the first non-comment line, which is returned in whole (trimmed)
    if !filereadable(a:path)
        echoerr "Token file not found: " . a:path
        return ''
    endif

    for line in readfile(a:path)
        let line = trim(line)
        if line != '' && line[0] != '#'
            return line
        endif
    endfor

    echoerr "No token found in " . a:path
    return ''
endfunction

let s:rapidapi_token = ''
function! LookupDefinition(ref) abort
    if s:rapidapi_token == ''
        let s:rapidapi_token = ReadToken(expand('~/.rapidapi'))
    endif

    let defurl = "https://wordsapiv1.p.rapidapi.com/words/" . a:ref . "/definitions"
    let headers = [
                \ 'x-rapidapi-host:wordsapiv1.p.rapidapi.com',
                \ 'x-rapidapi-key:' . s:rapidapi_token,
                \ ]

    let cmd = "http GET " . l:defurl . " " . join(l:headers, " ")
    let defres = json_decode(trim(system(l:cmd)))

    let msg = get(l:defres, 'message', '')
    if l:msg != ''
        let title = printf("  %s : Error  ", a:ref)
        let lines = [l:msg]
    else
        let title = printf("  %s  ", l:defres['word'])
        let lines = map(copy(l:defres['definitions']), '(v:key+1).". (".v:val["partOfSpeech"].") ".v:val["definition"]')

        let synurl = "https://wordsapiv1.p.rapidapi.com/words/" . a:ref . "/synonyms"
        let cmd = "http GET " . l:synurl . " " . join(l:headers, " ")
        let synres = json_decode(trim(system(l:cmd)))
        call extend(l:lines, ['', 'synonyms:', '  ' . join(l:synres['synonyms'], ', ')])
    endif

    " Also set the text into the quick un-named register
    let @" = join([trim(l:title), ''] + l:lines, "\n")

    "" The join & re-split is to account for verses with embedded line breaks
    "" and by doing this, we join it all up as we "would" want it,
    "" but then give it to the function the way it expects.
    call popup_create(split(join(l:lines, "\n"), "\n"), #{
                \ title: l:title,
                \ line: 'cursor+1',
                \ col: 'cursor+1',
                \ padding: [1,1,1,1],
                \ border: [],
                \ filter: 'LookupFilter',
                \ callback: 'LookupCallback',
            \ })
endfunction
command! -nargs=* -complete=command LookupDefinition call LookupDefinition(<f-args>)

function! LookupPydoc(ref) abort
    let cmd = "pydoc " . a:ref
    let msg = trim(system(l:cmd))

    " Also set the text into the quick un-named register
    let @" = l:msg

    call popup_create(split(l:msg, "\n"), #{
                \ title: 'pydoc',
                \ line: 'cursor+1',
                \ col: 'cursor+1',
                \ padding: [1,1,1,1],
                \ border: [],
                \ filter: 'LookupFilter',
                \ callback: 'LookupCallback',
            \ })
endfunction
command! -nargs=* -complete=command LookupPydoc call LookupPydoc(<f-args>)

nnoremap        <leader>kp        <nop>
nnoremap        <leader>kp?       :set keywordprg?<cr>
nnoremap        <leader>kp&       :set keywordprg&<cr>
nnoremap <expr> <leader>kp<space> ':set keywordprg='
nnoremap        <leader>kpb       :set keywordprg=:LookupBibleReference<cr>
nnoremap        <leader>kpd       :set keywordprg=:LookupDefinition<cr>
nnoremap        <leader>kpp       :set keywordprg=:LookupPydoc<cr>
"}}}


" Settings related to vim-test "{{{
nnoremap <leader><leader>u   <nop>
nnoremap <leader><leader>ut  <nop>
nnoremap <leader><leader>uts :TestSuite<cr>
nnoremap <leader><leader>utf :TestFile<cr>
nnoremap <leader><leader>utn :TestNearest<cr>
nnoremap <leader><leader>utl :TestLast<cr>
nnoremap <leader><leader>utv :TestVisit<cr>
"}}}


" Settings related to emmet-vim "{{{
let g:user_emmet_install_global = 0
let g:user_emmet_leader_key = ','
augroup VimEmmet
    autocmd!
    "autocmd FileType html,css EmmetInstall
augroup end
nnoremap        <leader><leader>e  <nop>
nnoremap        <leader><leader>ei :EmmetInstall<cr>
nnoremap <expr> <leader><leader>ee ':Emmet '
"}}}

" Settings related to vim-closetag "{{{
""
"" NOTE:   '\\c...' is 99% for CoC plugin, but \\ct was available at the moment
""
nnoremap <leader><leader>ct :CloseTagToggleBuffer<cr>
"}}}

" Settings related to tagalong.vim "{{{
" Default types:  ['eco', 'eelixir', 'ejs', 'eruby', 'html', 'htmldjango', 'javascriptreact', 'jsx', 'php', 'typescriptreact', 'xml']
let g:tagalong_filetypes = []
let g:tagalong_additional_filetypes = []
nnoremap <leader><leader>ti :call tagalong#Init()<cr>
"}}}


" Mappings for the Claude Code when launched within VIM (i.e. in VIM 'term') "{{{
nnoremap <expr> <leader><leader>ac    <nop>
nnoremap        <leader><leader>acm   <nop>
nnoremap        <leader><leader>acm?  :echo printf("Claude Model:  %s", $ANTHROPIC_MODEL)<cr>
nnoremap        <leader><leader>acmh  <nop>
nnoremap        <leader><leader>acmh4 :let $ANTHROPIC_MODEL = 'claude-haiku-4-5-latest'<cr>
nnoremap        <leader><leader>acmh3 :let $ANTHROPIC_MODEL = 'claude-3-5-haiku-latest'<cr>
nnoremap        <leader><leader>acms  <nop>
nnoremap        <leader><leader>acms4 :let $ANTHROPIC_MODEL = 'claude-sonnet-4-latest'<cr>
nnoremap        <leader><leader>acms5 :let $ANTHROPIC_MODEL = 'claude-sonnet-4-5-latest'<cr>
nnoremap        <leader><leader>acmo  <nop>
nnoremap        <leader><leader>acmo4 :let $ANTHROPIC_MODEL = 'claude-opus-4-latest'<cr>
nnoremap        <leader><leader>acmo1 :let $ANTHROPIC_MODEL = 'claude-opus-4-1-latest'<cr>
nnoremap        <leader><leader>acmo5 :let $ANTHROPIC_MODEL = 'claude-opus-4-5-latest'<cr>
"}}}


" Mappings for the various installed "copilot"-like AI engines "{{{
""
"" First, the dictionary of "copilot"-like AI engines:
""

let s:EngProto = {}
function! s:EngProto.plug_exists() dict
    return exists('g:plugs["' . self.name . '"]') > 0
endfunction

function! s:EngProto.loaded() dict
    if !self.plug_exists()
        return v:false
    endif
    return self.exists()
endfunction

function! s:EngProto.enabled() dict
    if self.loaded()
        return self.loaded_enabled()
    endif
    return self.flag_enabled()
endfunction

function! s:EngProto.enable(value) dict
    if self.loaded()
        return self.loaded_enable(a:value)
    endif
    return self.flag_enable(a:value)
endfunction

function! s:EngProto.status() dict
    if self.loaded()
        let msg = join(s:RedirExec(self.status_cmd()), "\n")
    else
        let msg = printf("%s is not loaded", self.name)
    endif
    echo l:msg
endfunction

let g:engine_inits = {
  \   'w' : {
  \     'name': 'windsurf.vim',
  \     'exists': {-> exists(':Codeium')},
  \     'loaded_enabled': {-> codeium#Enabled()},
  \     'loaded_enable': {v -> execute('Codeium ' . (v ? 'Enable' : 'Disable'))},
  \     'flag_enabled': {-> get(g:, 'codeium_enabled', v:false)},
  \     'flag_enable': {v -> extend(g:, {'codeium_enabled': v})},
  \     'status_cmd': {-> printf("echo 'Codeium is %s'", codeium#Enabled() ?  'Enabled' : 'Disabled')},
  \     'do_tab': {-> codeium#Accept()},
  \     'disable_maps': {-> extend(g:, {'codeium_no_map_tab':v:true,'codeium_disable_bindings':v:true})},
  \     'cancel': {-> codeium#Clear()},
  \     'show': {-> codeium#Complete()},
  \     'next': {-> codeium#CycleCompletions(1)},
  \     'prev': {-> codeium#CycleCompletions(-1)},
  \     'acceptword': {-> codeium#AcceptNextWord()},
  \     'acceptline': {-> codeium#AcceptNextLine()},
  \   },
  \   'g': {
  \     'name': 'copilot.vim',
  \     'exists': {-> exists(':Copilot')},
  \     'loaded_enabled': {-> copilot#Enabled()},
  \     'loaded_enable': {v -> execute('Copilot ' . (v ? 'enable' : 'disable'))},
  \     'flag_enabled': {-> get(g:, 'copilot_enabled', v:false)},
  \     'flag_enable': {v -> extend(g:, {'copilot_enabled': v})},
  \     'status_cmd': {-> 'Copilot status'},
  \     'do_tab': {-> copilot#Accept()},
  \     'disable_maps': {-> extend(g:, {'copilot_no_tab_map': v:true})},
  \     'cancel': {-> copilot#Dismiss()},
  \     'show': {-> copilot#Suggest()},
  \     'next': {-> copilot#Next()},
  \     'prev': {-> copilot#Previous()},
  \     'acceptword': {-> copilot#AcceptWord()},
  \     'acceptline': {-> copilot#AcceptLine()},
  \   },
  \   'u': {
  \     'name': 'augment.vim',
  \     'exists': {-> exists(':Augment')},
  \     'loaded_enabled': {-> !get(g:, 'augment_disable_completions', v:true)},
  \     'loaded_enable': {v -> extend(g:, {'augment_disable_completions': !v})},
  \     'flag_enabled': {-> !get(g:, 'augment_disable_completions', v:true)},
  \     'flag_enable': {v -> extend(g:, {'augment_disable_completions': !v})},
  \     'status_cmd': {-> 'Augment status'},
  \     'do_tab': {-> (call('feedkeys', ["\<Cmd>call augment#Accept('\<Tab>')\<CR>", 'n']) ?? '')},
  \     'disable_maps': {-> extend(g:, {'augment_disable_tab_mapping': v:true})},
  \     'cancel': {-> augment#suggestion#Clear()},
  \     'show': {-> augment#suggestion#Show()},
  \     'next': {-> 0},
  \     'prev': {-> 0},
  \     'acceptword': {-> augment#Accept()},
  \     'acceptline': {-> augment#Accept()},
  \   },
  \ }

  "\   'c': {
  "\     'name': 'coc.nvim',
  "\     'exists': {-> exists(':CocEnable')},
  "\     'loaded_enabled': {-> get(g:, 'coc_enabled', 0)},
  "\     'loaded_enable': {v -> execute('Coc'.(v?'En':'Dis').'able')},
  "\     'flag_enabled': {-> get(g:, 'coc_enabled', v:false)},
  "\     'flag_enable': {v -> extend(g:, {'coc_enabled': v})},
  "\     'cmd': {'exists':'CocEnable'},
  "\     'status_cmd': {-> 'echo ' . g:coc_status},
  "\     'do_tab': {-> "\<tab>"},
  "\     'disable_maps': {-> 0},
  "\     'cancel': {-> coc#pum#cancel()},
  "\   },

""
"" Then a "constructor" that builds the AI engines using the above data
"" and the "prototype" defined above the data.
""
""     NOTE:  should run just once, see below
""
function! s:InitAI()
    let g:engines = {}
    for [key, eng_init] in items(g:engine_inits)
        let new_eng = copy(s:EngProto)
        call extend(l:new_eng, eng_init)
        let g:engines[key] = l:new_eng

        call l:new_eng.disable_maps()
        " NOTE: the user's VIMRC executes BEFORE the plugins themselves.
        "       so our way of "enabling/disabling" is done via g:... flags
        "       the :... commands do not exist yet.
        " This logic lives within the `.enable(...)` method
        call l:new_eng.enable(v:false)
    endfor

    " NOTE: below there is an ActivateAI method to be used by mappings
    "       (it has error checking and display output)
    " Here, after *knowing* we just created & disabled ALL of them, do not
    " need all that...   just enable the "default" one:  Windsurf
    call g:engines['w'].enable(v:true)
endfunction

""
"" Invoke the AI engine constructor
""
if ! exists("s:ai_default_has_been_set")
    let s:ai_default_has_been_set = 1
    call s:InitAI()
endif

function! s:DumpAIState(header, count) abort
    echo a:header
    echo items(g:engines)->map({_,v -> printf('%s plug_exists: %d', v[1].name, v[1].plug_exists())})->join(', ')
    echo items(g:engines)->map({_,v -> printf('%s exists: %d', v[1].name, v[1].exists())})->join(', ')
    echo items(g:engines)->map({_,v -> printf('%s loaded: %d', v[1].name, v[1].loaded())})->join(', ')
    echo items(g:engines)->map({_,v -> printf('%s enabled: %d', v[1].name, v[1].enabled())})->join(', ')
    echo printf(repeat('=', 50))
    " NOTE: the Augment plugin output STOMPS on and ERASES whatever output
    "       comes before it. and somehow its output is always last, even
    "       if not called last.
    " SO: we force 'u' to be last
    " AND: our engine prototype method for `.status()` includes a JOIN
    "      believe it or not this matters.
    "      if s:RedirExec is adjusted to NOT split before returning, and the
    "      JOIN in `.status()` is removed...  the STOMPING commences.
    " BUT: if we leave s:RedirExec alone, and leave the JOIN in place, it works
    for [key, engine] in items(g:engines)
        if key != 'u'
            call engine.status()
        endif
    endfor
    call g:engines['u'].status()
endfunction

function! s:GetCurAI() abort
    let engs = keys(g:engines)->filter({_,k->g:engines[k].enabled()})
    if len(l:engs) > 1
       throw 'Found more than one enabled AI engine! : ' . scriptease#dump(l:engs)
    endif
    return get(l:engs, 0, '')
endfunction

function! s:ActivateAI(eng) abort
    let cur = s:GetCurAI()
    for [key, engine] in items(g:engines)
        if key != a:eng
            call engine.enable(v:false)
        endif
    endfor
    call g:engines[a:eng].enable(v:true)
    let s:ai_eng = a:eng
    echo printf((l:cur==a:eng?'Re-a':'A').'ctivated %s', g:engines[a:eng].name)
endfunction


""
"" Then helpers to simplify access to AI engines for the mappings below
""
function! s:AiDo(task, default) abort
    let cur = s:GetCurAI()
    let rv = 0
    if l:cur != ''
        if type(a:task) == v:t_func
            let rv = a:task(g:engines[l:cur])
        endif
        let rv = g:engines[l:cur][a:task]()
    endif
    return l:rv ?? a:default
endfunction

""
"" Then the <Tab> handler
""
""
"" NOTE: Here is how 3 AI plugin providers create their TAB mappings:
""       Please NOTE that Augment uses a <cmd> mapping!!
""
""    codeium:  imap <script><silent><nowait><expr> <Tab> codeium#Accept()
""    copilot:  imap <script><silent><nowait><expr> <Tab> empty(get(g:, 'copilot_no_tab_map')) ? copilot#Accept() : "\t"
""    augment:  inoremap <tab> <cmd>call augment#Accept("\<tab>")<cr>
""
"" Therefore, my own mappings must be <expr> and possibly return something.
"" And for augment it needs to do two things, the 2nd being returning blank
"" (i.e. returning nothing)
""
imap <script><silent><nowait><expr> <Tab> <sid>AiDo('do_tab', "\<Tab>")


""
"" NOTE: do not interfere with the CoC plugin bindings:
""
""   i  <PageUp>    * coc#pum#visible() ? coc#pum#scroll(0) : "\<PageUp>"
""   i  <PageDown>  * coc#pum#visible() ? coc#pum#scroll(1) : "\<PageDown>"
""   i  <C-Y>       * coc#pum#visible() ? coc#pum#confirm() : "\<C-Y>"
""   i  <C-E>       * coc#pum#visible() ? coc#pum#cancel() : "\<C-E>"
""   i  <Up>        * coc#pum#visible() ? coc#pum#prev(0) : "\<Up>"
""   i  <Down>      * coc#pum#visible() ? coc#pum#next(0) : "\<Down>"
""   i  <C-P>       * coc#pum#visible() ? coc#pum#prev(1) : "\<C-P>"
""   i  <C-N>       * coc#pum#visible() ? coc#pum#next(1) : "\<C-N>"
""   i  <C-@>       * coc#refresh()
""


function! s:ClearAll(...) abort
    " The passed in arg is returned
    for [key, engine] in items(g:engines)
        if engine.loaded()
            call engine.cancel()
        endif
    endfor
    return a:0 >= 1 ? a:1 : ''
endfunction
inoremap <script><silent><nowait><expr> <c-z> <sid>ClearAll("\<c-z>")
inoremap <script><silent><nowait><expr> <c-a> <sid>AiDo('show', "\<c-a>")

inoremap <script><silent><nowait><expr> <c-e> <sid>AiDo('cancel', "\<c-e>")
inoremap <script><silent><nowait><expr> <C-]> <sid>AiDo('cancel', "\<C-]>")
inoremap <script><silent><nowait><expr> <C-f> <sid>AiDo('acceptword', "\<C-f>")
inoremap <script><silent><nowait><expr> <C-l> <sid>AiDo('acceptline', "\<C-l>")

" The plugin attempt to map "Alt-[" and "Alt-]" but on MacOS that never works,
" so I fix it with maps using the 'fancy' MacOS-only 'option' characters
if ! has('macunix')
    inoremap <script><silent><nowait><expr> <M-]>      <sid>AiDo('next', "\<M-]>")
    inoremap <script><silent><nowait><expr> <M-[>      <sid>AiDo('prev', "\<M-[>")
    inoremap <script><silent><nowait><expr> <M-Bslash> <sid>AiDo('show', "\<M-Bslash>")
else
    inoremap <script><silent><nowait><expr> ‘          <sid>AiDo('next', "‘")
    inoremap <script><silent><nowait><expr> “          <sid>AiDo('prev', "“")
    inoremap <script><silent><nowait><expr> «          <sid>AiDo('show', "«")
endif

inoremap <c-s><c-i> <nop>
inoremap <c-s><c-i>c <Plug>(codeium-dismiss)
inoremap <c-s><c-i>n <Plug>(codeium-next-or-complete)
inoremap <c-s><c-i>p <Plug>(codeium-previous)
inoremap <c-s><c-i>s <Plug>(codeium-complete)

nnoremap <leader><leader>a   <nop>
nnoremap <leader><leader>aa  <nop>
nnoremap <leader><leader>aai <cmd>call <sid>InitAI()<cr>
nnoremap <leader><leader>aac <cmd>call <sid>ActivateAI('c')<cr>
nnoremap <leader><leader>aag <cmd>call <sid>ActivateAI('g')<cr>
nnoremap <leader><leader>aaw <cmd>call <sid>ActivateAI('w')<cr>
nnoremap <leader><leader>aau <cmd>call <sid>ActivateAI('u')<cr>
nnoremap <leader><leader>aaz <cmd>call <sid>DumpAIState('On demand:', v:count)<cr>
nnoremap <leader><leader>a?  <cmd>call <sid>DumpAIState('On demand:', v:count)<cr>

" Settings related to Windsurf (Codeium) "{{{
nnoremap        <leader><leader>aw        <nop>
nnoremap <expr> <leader><leader>aw<space> ':Codeium '
nnoremap        <leader><leader>awd       :Codeium Disable<cr>
nmap            <leader><leader>awe       \\aaw
nnoremap        <leader><leader>awc       :Codeium Chat<cr>
nnoremap        <leader><leader>aws       :echo (codeium#Enabled() ? 'Codeium is enabled' : 'Codeium is disabled')<cr>
" "}}}

" Settings related to Github Copilot "{{{
nnoremap        <leader><leader>ag        <nop>
nnoremap <expr> <leader><leader>ag<space> ':Copilot '
nnoremap        <leader><leader>agd       :Copilot disable<cr>
nmap            <leader><leader>age       \\aag
nnoremap        <leader><leader>ags       :Copilot status<cr>
" "}}}

" Mappings for Augment specialized AI "{{{
nnoremap        <leader><leader>au          <nop>
nnoremap <expr> <leader><leader>au<space>   ':Augment '
nnoremap        <leader><leader>aud         :Augment disable<cr>
nnoremap        <leader><leader>aue         \\aau
nnoremap        <leader><leader>aus         :Augment status<cr>
nnoremap        <leader><leader>aui         :Augment signin<cr>
nnoremap        <leader><leader>auo         :Augment signout<cr>
nnoremap        <leader><leader>aul         :Augment log<cr>
nnoremap        <leader><leader>auc         <nop>
nnoremap <expr> <leader><leader>auc<space>  ':Augment chat '
xnoremap <expr> <leader><leader>aucv        ':Augment chat ' . VisualSelection()
nnoremap <expr> <leader><leader>aucn        <nop>
nnoremap <expr> <leader><leader>aucn<space> ':Augment chat-new '
xnoremap <expr> <leader><leader>aucnv       ':Augment chat-new ' . VisualSelection()
nnoremap        <leader><leader>auct        :Augment chat-toggle<cr>

let g:augment_debug = v:true

" Use enter to accept a suggestion, falling back to a newline if no suggestion
" is available
"NOTE: disabling Augment's <Tab> is above, where we set our own <Tab> "mapping
let g:augment_workspace_folders = []
nnoremap <expr> <leader><leader>auw ':let g:augment_workspace_folders = ['

" MAYBE!
" inoremap <cr> <cmd>call augment#Accept("\n")<cr>

""
"" NOTE!!   ::   Augment offers an IGNORE mechanism:
""
""  You just create an .augmentignore file just like a .gitignore file
""

"}}}

" "}}}


" Settings related to vim-mark "{{{

" let g:mwDefaultHighlightingPalette = 'original'   DEFAULT value
"let g:mwDefaultHighlightingPalette = 'extended'
let g:mwDefaultHighlightingPalette = 'maximum'

 map <leader>k          <nop>
 map <leader><leader>k  <nop>

nmap <leader><leader>kl :Marks<cr>
nmap <leader><leader>km <Plug>MarkSet
xmap <leader><leader>km <Plug>MarkSet
nmap <leader><leader>kr <Plug>MarkRegex
xmap <leader><leader>kr <Plug>MarkRegex
" This is like disable
nmap <leader><leader>kc <Plug>MarkClear
" This is more like WIPE
nmap <leader><leader>kw :MarkClear<cr>
nmap <leader><leader>ky :MarkYankDefinitions "<cr>

nmap <leader><leader>k* <Plug>MarkSearchCurrentNext
nmap <leader><leader>k# <Plug>MarkSearchCurrentPrev
nmap <leader><leader>kn <Plug>MarkSearchAnyNext
nmap <leader><leader>kN <Plug>MarkSearchAnyPrev

" From docs:  when on a mark: "re-do" the last executed one of the above
"             when not:       do vim default
if '/vim-mark/' =~ &runtimepath
    nmap * <Plug>MarkSearchNext
    nmap # <Plug>MarkSearchPrev
endif

"}}}

" Settings related to AnsiEsc plugin "{{{
nnoremap <leader>xl :AnsiEsc<cr>

nnoremap <leader><leader>o  <nop>
nnoremap <leader><leader>oo :AnsiEsc<cr>
nnoremap <leader><leader>o? :echo '"' . <SID>CurColorCode() . '"'<cr>
nnoremap <leader><leader>oz :call <SID>DumpAnsiCode()<cr>
nnoremap <leader><leader>oy :call <SID>SetAnsiStyle()<cr>
nnoremap <leader><leader>of :call <SID>SetAnsiFore()<cr>
nnoremap <leader><leader>ob :call <SID>SetAnsiBack()<cr>
nnoremap <leader><leader>ol :call <SID>ClearAnsiCode()<cr>

" NOTE:  `map!` is for mode-C and mode-I
"noremap! <expr> <c-s><c-l>c  '¯\_(ツ)_/¯'

noremap!        <c-s><c-l>  <nop>
" Adjust current code
noremap!        <c-s><c-l>? <c-o>:call <SID>DumpAnsiCode()<bar>echo ''<cr>
noremap!        <c-s><c-l>y <c-o>:call <SID>SetAnsiStyle()<cr>
noremap!        <c-s><c-l>f <c-o>:call <SID>SetAnsiFore()<cr>
noremap!        <c-s><c-l>b <c-o>:call <SID>SetAnsiBack()<cr>
noremap!        <c-s><c-l>l <c-o>:call <SID>ClearAnsiCode()<bar>echo ''<cr>
" Insert start & end codes
noremap! <expr> <c-s><c-l>s <SID>CurColorCode()
noremap! <expr> <c-s><c-l>e "\<c-v>\<esc>[m"

nnoremap        <leader><leader>oa  <nop>
nnoremap <expr> <leader><leader>oap "\"='" . <SID>CurColorCode() . "'<cr>p"
nnoremap <expr> <leader><leader>oaP "\"='" . <SID>CurColorCode() . "'<cr>P"
nnoremap        <leader><leader>oe  <nop>
nnoremap <expr> <leader><leader>oep "\"='" . "\<c-v>\<esc>[m" . "'<cr>p"
nnoremap <expr> <leader><leader>oeP "\"='" . "\<c-v>\<esc>[m" . "'<cr>P"

let s:current_style = ''
let s:current_foreground = ''
let s:current_background = ''
function! s:DumpAnsiCode()
    echo 'style: "' . s:current_style . '", fore: "' . s:current_foreground . '", back: "' . s:current_background . '", code: "' . <SID>CurColorCode() . '"'
endfunction
function! s:CurColorCode()
    let parts = []
    if s:current_style != ''
        call add(parts, s:current_style)
    endif
    if s:current_foreground != ''
        call add(parts, s:current_foreground)
    endif
    if s:current_background != ''
        call add(parts, s:current_background)
    endif
    let code = join(l:parts, ';')
    return "\<c-v>\<esc>[" . (len(l:code) ? l:code : '0') . "m"
endfunction
function! s:ClearAnsiCode()
    let s:current_style = ''
    let s:current_foreground = ''
    let s:current_background = ''
    call <SID>DumpAnsiCode()
endfunction

function! s:GetUserStyle()
    echohl Question
    echo "ANSI Style: (z)ero (b)old in(v)erse (u)nderline"
    echohl None
    let styles = { 'z':'0', 'b':'1', 'v':'2', 'u':'4' }
    return get(l:styles, nr2char(getchar()), '')
endfunction
function! s:GetUserColor(isback)
    echohl Question
    echo "ANSI Color: blac(k) (r)ed (g)reen (y)ellow (b)lue (m)agenta (c)yan (w)hite. (cap for intense:  BLAC(K) (R)ED ..."
    echohl None
    " This works because the intense foregrounds are 60 above the regular foregrounds
    " and the same with the backgrounds, the intense ones are 60 above the regular ones
    let colors = { 'k':0, 'r':1, 'g':2, 'y':3, 'b':4, 'm':5, 'c':6, 'w':7,
                 \ 'K':60, 'R':61, 'G':62, 'Y':63, 'B':64, 'M':65, 'C':66, 'W':67 }
    let color = get(l:colors,nr2char(getchar()), -1)
    if l:color == -1
        return ''
    endif
    return printf('%d', (a:isback ? 40 : 30) + l:color)
endfunction
function! s:SetAnsiStyle()
    let s:current_style = <SID>GetUserStyle()
    call <SID>DumpAnsiCode()
endfunction
function! s:SetAnsiFore()
    let s:current_foreground = <SID>GetUserColor(v:false)
    call <SID>DumpAnsiCode()
endfunction
function! s:SetAnsiBack()
    let s:current_background = <SID>GetUserColor(v:true)
    call <SID>DumpAnsiCode()
endfunction

"noremap! <expr> <c-s><c-o><c-o> '[m'
"noremap! <expr> <c-s><c-o>b     '[30m'
"noremap! <expr> <c-s><c-o>r     '[31m'
"noremap! <expr> <c-s><c-o>g     '[32m'
"noremap! <expr> <c-s><c-o>y     '[33m'
"noremap! <expr> <c-s><c-o>b     '[34m'
"noremap! <expr> <c-s><c-o>m     '[35m'
"noremap! <expr> <c-s><c-o>c     '[36m'
"noremap! <expr> <c-s><c-o>w     '[37m'

"}}}

" Settings related to Coc "{{{

"" # On my windows dev box, I used other node versions, and this one for Vim
if filereadable('C:\ProgramData\nvm\v18.16.0\node.exe')
    let g:coc_node_path = 'C:\ProgramData\nvm\v18.16.0\node.exe'
endif

let s:coc_plug_exists = exists('g:plugs["coc.nvim"]')

"" # "wget -P %userprofile%\AppData\Local\coc\manually-installed-extensions\kotlin\server\lib https://repo1.maven.org/maven2/org/slf4j/slf4j-nop/2.0.3/slf4j-nop-2.0.3.jar
"" # "wget -P %userprofile%\AppData\Local\coc\manually-installed-extensions\kotlin\server\lib https://repo1.maven.org/maven2/org/slf4j/slf4j-nop/1.7.25/slf4j-nop-1.7.25.jar

"" #
"" # NOTE: coc-java, if installed via :Coc... cmd, requires Java 17 or newer (as of now) and therefore
"" #       the coc-settings.json file needs to have an entry that points directly to the newer JDK so
"" #       that the system's JAVA_HOME value will not be used.
"" #           see: https://github.com/neoclide/coc-java/issues/226
"" #
"" # These are my related entries in the coc-settings.json file:
"" #     "java.home" : "C:\\Users\\Administrator\\.jabba\\manually-setup\\jdk-17.0.5+8",
"" #     "java.configuration.runtimes": [
"" #       {
"" #         "name" : "JavaSE-17",
"" #         "path" : "C:\\Users\\Administrator\\.jabba\\manually-setup\\jdk-17.0.5+8",
"" #         "default" : true
"" #       }
"" #     ]
"" #
"" # Coc-json produces a warning on the "java.home" value, saying:
"" #     coc-settings.json|9 col 3-14 warning| [json] Configuration property may not work as folder configuration [W]
"" #     don't worry, it works fine :)
"" #

let g:coc_config_home = '~/.vim/vimfiles'

"" ag --depth 50 --hidden --ignore tags "server\.zip" -U %USERPROFILE%\Documents


"" # ################################################################################
"" # Items from main readme (here: https://github.com/neoclide/coc.vim)
"" # ################################################################################

set updatetime=300
"" # "nnoremap <leader>set signcolumn=yes

augroup FixingJsonCommentHighlight
    autocmd!
    autocmd FileType json syntax match Comment +\/\/.\+$+
augroup end

"" # Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nnoremap <expr> <leader><leader>c         <nop>
nnoremap        <leader><leader>cr        :CocRestart<cr>
nnoremap        <leader><leader>cd        :CocDisable<cr>
nnoremap        <leader><leader>ce        :CocEnable<cr>
nnoremap        <leader><leader>cs        <cmd>echo get(g:, 'coc_status', '<n/a>')<cr>
nnoremap <expr> <leader><leader>cq        ':CocDiagnostics<cr>'

nnoremap        <leader><leader>co        <nop>
nnoremap <expr> <leader><leader>coc       ':<c-u>' . ( v:count == 1 ? 'vnew ' : 'new' ) . '<bar>CocConfig<cr>'
nnoremap <expr> <leader><leader>col       ':<c-u>' . ( v:count == 1 ? 'vnew ' : 'new' ) . '<bar>CocOpenLog<cr>'
nnoremap        <leader><leader>coo       :CocOutline<cr>

"" CocInstall section
nnoremap        <leader><leader>ci        <nop>
nnoremap <expr> <leader><leader>ci<space> ':CocInstall '
nnoremap        <leader><leader>cim       :CocInstall coc-marketplace<cr>

"" CocCommand section
nnoremap        <leader><leader>cc        <nop>
nnoremap <expr> <leader><leader>cc<space> ':CocCommand '
nnoremap        <leader><leader>ccd       <nop>
nnoremap        <leader><leader>ccdi      <nop>
nnoremap        <leader><leader>ccdiw     :CocCommand deno.initializeWorkspace<cr>

"" CocList section
nnoremap        <leader><leader>cl        <nop>
nnoremap <expr> <leader><leader>cl<space> ':CocList '
nnoremap        <leader><leader>clm       :CocList marketplace<cr>
nnoremap        <leader><leader>clo       :CocList outline<cr>
nnoremap        <leader><leader>cls       :CocList -I symbols<cr>

"" CocAction section  (with a couple other things...)

" Pneumonic:  'q' for QuickFix   (i.e. fill Quickfix with CoC messages)
nnoremap        <leader><leader>cf        <Plug>(coc-fix-current)
nnoremap        <leader><leader>cg        <nop>
nnoremap        <leader><leader>cgq       <Plug>(coc-format-selected)

nnoremap        <leader><leader>ca        <nop>
nnoremap <expr> <leader><leader>ca<space> ':call CocActionAsync("'
nnoremap        <leader><leader>cac       <nop>
nnoremap        <leader><leader>caca      <Plug>(coc-codeaction-selected)
nnoremap        <leader><leader>cacr      <Plug>(coc-codeaction-refactor-selected)
nnoremap        <leader><leader>cacrr     <Plug>(coc-codeaction-refactor)
nnoremap        <leader><leader>cacl      <Plug>(coc-codelens-action)
nnoremap        <leader><leader>car       <nop>
nnoremap        <leader><leader>carf      <Plug>(coc-refactor)
nnoremap        <leader><leader>carn      <Plug>(coc-rename)
nnoremap        <leader><leader>cal       <Plug>(coc-openlink)

nnoremap        <leader><leader>cas       <nop>
nnoremap        <leader><leader>casi      :call CocActionAsync("showIncomingCalls")<cr>
nnoremap        <leader><leader>caso      :call CocActionAsync("showOutgoingCalls")<cr>

nnoremap        <leader><leader>caz       <nop>
nnoremap        <leader><leader>cazo      :call CocActionAsync("hideOutline")<cr>


function! CopyCocDiagnostic()
    let info = get(b:, 'coc_diagnostic_info', '')
    if empty(info)
        echo "No diagnostics available for current buffer"
        return
    endif
    let curline = line('.')

    for diag in CocAction('diagnosticList')
        if diag.lnum == curline
            let @+ = printf("%s:%d:%d\t%s\n%s", Expand('g'), diag.lnum, diag.col, getline('.'), diag.message)
            echo "Copied: " . strpart(diag.message, 0, 50) . "..."
            return
        endif
    endfor

    echo "No diagnostic on current line"
endfunction

" Map to leader key
nnoremap        <leader><leader>cy  :call CopyCocDiagnostic()<CR>


"" #
"" # Use tab for trigger completion with characters ahead and navigate.
"" # NOTE: There's always complete item selected by default, you may want to enable
"" # no select by `"suggest.noselect": true` in your configuration file.
"" # NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
"" # other plugin before putting this into your config.
"" #
if s:coc_plug_exists
	"function! CocTabHook()
	"    if coc#pum#visible()
	"        echom "moving to next..."
	"        call coc#pum#next(1)
	"    elseif CheckBackspace()
	"        echom "actually inserting tab..."
	"        call feedkeys("\<Tab>", 'in')
	"    else
	"        echom "refreshing completion list..."
	"        call coc#refresh()
	"    endif
	"endfunction
	"inoremap <silent><expr> <TAB> CocTabHook()
	"inoremap <silent><expr> <TAB>
	"      \ coc#pum#visible() ? coc#pum#next(1) :
	"      \ CheckBackspace() ? "\<Tab>" :
	"      \ coc#refresh()
	"inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
	"inoremap <c-x><c-c> <cmd>call coc#refresh()<cr>
endif

"" # "" #
"" # "" # Make <CR> to accept selected completion item or notify coc.nvim to format
"" # "" # <C-g>u breaks current undo, please make your own choice.
"" # "" #
"" # inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
"" #                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !l:col || l:col == (col('$') - 1) || getline('.')[l:col - 1]  =~# '\s'
endfunction

"" #
"" # Use <c-space> to trigger completion.
"" #
if s:coc_plug_exists
"if exists('*coc#refresh')
    if has('nvim')
        inoremap <silent><expr> <c-space> coc#refresh()
    else
        inoremap <silent><expr> <c-@> coc#refresh()
    endif
endif


"" #
"" # Navigate diagnostics
"" #  (use `:CocDiagnostics` to get current buffers diagnostics into location list)
"" #
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

"" #
"" # GoTo code navigation.
"" #
nmap <silent> gc <Plug>(coc-float-jump)
nmap <silent> gh <Plug>(coc-declaration)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> gs :CocCommand clangd.switchSourceHeader<cr>

"" #
"" # Use K to show documentation in preview window
"" #
if s:coc_plug_exists
"if exists('*CocAction')
    nnoremap <silent> K :call ShowDocumentation()<cr>
    nnoremap <silent> U :call coc#float#close_all(1)<cr>
endif

function! ShowDocumentation()
    " NOTE:  this "hook" BREAKS the 'K' command for vim script and doc files
    "        adding a condition to block those types from even trying Coc
    if index(['vim','help'], &filetype) == -1 && CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction

"" # "" #
"" # "" # NOTE:  the above "hook" for the 'K' command (:h K), is INTERFERING
"" # "" #        with looking up VIM functions while editing my VIMRC file
"" # "" #        So I looked around and found a coc.nvim issue with advice on
"" # "" #        how to "disable" the plugin for specific file types
"" # "" #          https://github.com/neoclide/coc.nvim/issues/349
"" # "" #
"" # function! s:disable_coc_for_type()
"" #     let coc_filetypes_disable = ["vim"]
"" #     if index(l:coc_filetypes_disable, &filetype) != -1
"" #         "echo 'Disabling coc for filetype (' . bufname("%") . ')'
"" #         ":silent! let b:coc_enabled = 0
"" #         :silent! CocDisable
"" #         ":CocDisable
"" #     else
"" #         :silent! CocEnable
"" #         ":CocEnable
"" #     endif
"" # endfunction

augroup CocDisableGroup
    autocmd!
    "autocmd BufNew,BufEnter,BufAdd,BufCreate * call s:disable_coc_for_type()
augroup end

"" # "" #
"" # "" # Highlight the symbol and its references when holding the cursor.
"" # "" #
"" # augroup CocCursor
"" #     au!
"" #     if s:coc_plug_exists
"" #     "if exists('*CocActionAsync')
"" #         au CursorHold * silent call CocActionAsync('highlight')
"" #     endif
"" # augroup END

"" # "" #
"" # "" # Remap <C-f> and <C-b> for scroll float windows/popups.
"" # "" #
"" # if s:coc_plug_exists
"" # "if exists('*coc#float#has_scroll')
"" #     if has('nvim-0.4.0') || has('patch-8.2.0750')
"" #         nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"" #         nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"" #         inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"" #         inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"" #         vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"" #         vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"" #     endif
"" # endif

"" #
"" # Spacebar mappings:
"" #
if s:coc_plug_exists
    " There are <space> mappings higher up in this file, for easy execution of
    " macros stored in one of the lowercase letter registers.
    "
    " Here we create 2<space> mappings for CoC commands
    nnoremap        <silent><nowait> <space><space><space> <nop>
    xnoremap        <silent><nowait> <space><space><space> <nop>

    nnoremap        <silent><nowait> <space><space>a  :<C-u>CocList diagnostics<cr>
    nnoremap        <silent><nowait> <space><space>e  :<C-u>CocList extensions<cr>
    nnoremap        <silent><nowait> <space><space>c  :<C-u>CocList commands<cr>
    nnoremap        <silent><nowait> <space><space>o  :<C-u>CocList outline<cr>
    nnoremap        <silent><nowait> <space><space>s  :<C-u>CocList -I symbols<cr>
    nnoremap        <silent><nowait> <space><space>j  :<C-u>CocNext<CR>
    nnoremap        <silent><nowait> <space><space>k  :<C-u>CocPrev<CR>
    nnoremap        <silent><nowait> <space><space>p  :<C-u>CocListResume<CR>
endif

"}}}


" Settings related to OmniSharp "{{{

"let g:OmniSharp_server_stdio = ONLY if necessary

augroup omnisharp_commands
    autocmd!

    " Show type information automatically when the cursor stops moving.
    " Note that the type is echoed to the Vim command line, and will overwrite
    " any other messages in this space including e.g. ALE linting messages.
    "" # autocmd CursorHold *.cs OmniSharpTypeLookup

    " The following commands are contextual, based on the cursor position.
    autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
    autocmd FileType cs nmap <silent> <buffer> <leader><leader>osfu <Plug>(omnisharp_find_usages)
    autocmd FileType cs nmap <silent> <buffer> <leader><leader>osfi <Plug>(omnisharp_find_implementations)
    autocmd FileType cs nmap <silent> <buffer> <leader><leader>ospd <Plug>(omnisharp_preview_definition)
    autocmd FileType cs nmap <silent> <buffer> <leader><leader>ospi <Plug>(omnisharp_preview_implementations)
    autocmd FileType cs nmap <silent> <buffer> <leader><leader>ost <Plug>(omnisharp_type_lookup)
    autocmd FileType cs nmap <silent> <buffer> <leader><leader>osd <Plug>(omnisharp_documentation)
    autocmd FileType cs nmap <silent> <buffer> <leader><leader>osfs <Plug>(omnisharp_find_symbol)
    autocmd FileType cs nmap <silent> <buffer> <leader><leader>osfx <Plug>(omnisharp_fix_usings)
    autocmd FileType cs nmap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
    autocmd FileType cs imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)

    " Navigate up and down by method/property/field
    autocmd FileType cs nmap <silent> <buffer> [[ <Plug>(omnisharp_navigate_up)
    autocmd FileType cs nmap <silent> <buffer> ]] <Plug>(omnisharp_navigate_down)
    " Find all code errors/warnings for the current solution and populate the quickfix window
    autocmd FileType cs nmap <silent> <buffer> <leader><leader>osgcc <Plug>(omnisharp_global_code_check)
    " Contextual code actions (uses fzf, vim-clap, CtrlP or unite.vim selector when available)
    autocmd FileType cs nmap <silent> <buffer> <leader><leader>osca <Plug>(omnisharp_code_actions)
    autocmd FileType cs xmap <silent> <buffer> <leader><leader>osca <Plug>(omnisharp_code_actions)
    " Repeat the last code action performed (does not use a selector)
    autocmd FileType cs nmap <silent> <buffer> <leader><leader>os. <Plug>(omnisharp_code_action_repeat)
    autocmd FileType cs xmap <silent> <buffer> <leader><leader>os. <Plug>(omnisharp_code_action_repeat)

    autocmd FileType cs nmap <silent> <buffer> <leader><leader>os= <Plug>(omnisharp_code_format)

    autocmd FileType cs nmap <silent> <buffer> <leader><leader>osnm <Plug>(omnisharp_rename)

    autocmd FileType cs nmap <silent> <buffer> <leader><leader>osre <Plug>(omnisharp_restart_server)
    autocmd FileType cs nmap <silent> <buffer> <leader><leader>osst <Plug>(omnisharp_start_server)
    autocmd FileType cs nmap <silent> <buffer> <leader><leader>ossp <Plug>(omnisharp_stop_server)
augroup END

"}}}


" Goyo/Limelight mappings and settings "{{{
nnoremap <leader><leader>g  <nop>
nnoremap <leader><leader>ga :Goyo<cr>
nnoremap <leader><leader>go :Goyo!<cr>

"" # " For limelight, my current pneumonic is:  "spotlight"
nnoremap <leader><leader>s  <nop>
nnoremap <leader><leader>sa :Limelight<cr>
nnoremap <leader><leader>so :Limelight!<cr>
"}}}


" Markdown-related mappings and settings "{{{
"" # "
"" # " These settings are from the built-in functionality
"" # " (either from the installed VIM, or tpope/vim-markdown)
"" # " (--OR-- the more functional preservim/vim-markdown)
"" # "
"" # " Above, I have chosen to use preservim's plugin.
"" # " Therefore, all the global variables have the vim_ prefix
"" # " (which is not there in tpope's version)
"" # "

" Preservim Markdown automatic key mappings, disabled via a global:
"    call <sid>MapNotHasmapto(']]', 'Markdown_MoveToNextHeader')
"    call <sid>MapNotHasmapto('[[', 'Markdown_MoveToPreviousHeader')
"    call <sid>MapNotHasmapto('][', 'Markdown_MoveToNextSiblingHeader')
"    call <sid>MapNotHasmapto('[]', 'Markdown_MoveToPreviousSiblingHeader')
"    call <sid>MapNotHasmapto(']u', 'Markdown_MoveToParentHeader')
"    call <sid>MapNotHasmapto(']h', 'Markdown_MoveToCurHeader')
"    call <sid>MapNotHasmapto('gx', 'Markdown_OpenUrlUnderCursor')
"    call <sid>MapNotHasmapto('ge', 'Markdown_EditUrlUnderCursor')
"let g:vim_markdown_no_default_key_mappings=1
"let g:vim_markdown_borderless_table=1

""
"" This prevents the bullets and indenting that I usually don't want
""
"let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0

"" # If you want to enable fenced code block syntax highlighting in your markdown
"" # documents you can enable it in your `.vimrc` like so:
"let g:vim_markdown_fenced_languages = ['html', 'python', 'bash=sh']

"" #
"" # This setting, g:markdown_minlines, is ONLY used in Tim Pope's markdown plugin
"" # which is currently commented out above in favor of preservim's version
"" #
"" # " Syntax highlight is synchronized in 50 lines. It may cause collapsed
"" # " highlighting at large fenced code block.
"" # " In the case, please set larger value in your vimrc:
"" # nnoremap        <leader><leader>ml? :echo g:markdown_minlines<cr>
"" # nnoremap <expr> <leader><leader>mll ':<c-u>let g:markdown_minlines = ' . v:count . '<cr>'
"" # let g:markdown_minlines = 10
"" #

nnoremap <leader><leader>mf  <nop>
nnoremap <leader><leader>mf? :echo 'Markdown folding is: ' . (get(g:, 'vim_markdown_folding_disabled', 0) ? 'disabled' : 'enabled')<cr>
nnoremap <leader><leader>mfe :unlet g:vim_markdown_folding_disabled<cr>:norm \\mf?<cr>
nnoremap <leader><leader>mfd :let g:vim_markdown_folding_disabled = 1<cr>:norm \\mf?<cr>
let g:vim_markdown_folding_disabled = 1
" This option prevents the plugin from customizing the greyed out text *on top of* the folded line
"let g:vim_markdown_override_foldtext = 0

function! IndentionMotionSetup(direction) abort
    let s:indention_direction = a:direction
    let &opfunc = 'IndentionMotion'
    return 'g@'
endfunction

function! IndentionMotion(type) abort
    let save_cursor = getcurpos()
    if s:indention_direction == '>'
        '[,'] HeaderIncrease
    else
        '[,'] HeaderDecrease
    endif
    call setpos('.', save_cursor)
endfunction

nnoremap <expr> <leader>>h IndentionMotionSetup('>')
xnoremap <expr> <leader>>h IndentionMotionSetup('>')
nnoremap <expr> <leader>>hh IndentionMotionSetup('>') . '_'
nnoremap <expr> <leader><h IndentionMotionSetup('<')
xnoremap <expr> <leader><h IndentionMotionSetup('<')
nnoremap <expr> <leader><hh IndentionMotionSetup('<') . '_'

"" # "
"" # " find /Applications/MacVim.app/Contents/Resources/vim -iname '*markdown*'
"" # "
"" # " /Applications/MacVim.app/Contents/Resources/vim/runtime/ftplugin/markdown.vim
"" # " /Applications/MacVim.app/Contents/Resources/vim/runtime/syntax/markdown.vim
"" # "
"" # " /Applications/MacVim.app/Contents/Resources/vim/runtime
"" # " /Applications/MacVim.app/Contents/Resources/vim/vimfiles
"" # " /Applications/MacVim.app/Contents/Resources/vim/vimfiles/after
"" # " /Users/jasonsinger/.vim
"" # " /Users/jasonsinger/.vim/after
"" # "

" To disable markdown syntax concealing add the following to your vimrc:
"let g:vim_markdown_conceal = 0
nnoremap <silent> <leader>om  <nop>
nnoremap <silent> <leader>oms :let g:vim_markdown_conceal = 0<cr>
nnoremap <silent> <leader>zm  <nop>
nnoremap <silent> <leader>zms :let g:vim_markdown_conceal = 1<cr>

nnoremap        <leader>hl  <nop>
nnoremap        <leader>hl? :set conceallevel?<cr>
nnoremap        <leader>hl& :set conceallevel&<cr>
nnoremap <expr> <leader>hll ':<c-u>set conceallevel=' . v:count . '<cr>'
" Start out at 2:
"   Concealed text is completely hidden unless it has a
"   custom replacement character defined (see :syn-cchar).
set conceallevel=2

""
"" This controls which "modes" it is OK to conceal text on the cursor line itself
"" (values can be 'n', 'v', 'i', and 'c' - obvious mode first letters)
""
nnoremap <leader>hc        <nop>
nnoremap <leader>hc?       :set concealcursor?<cr>
nnoremap <leader>hc&       :set concealcursor&<cr>
nnoremap <leader>hc<space> :set concealcursor=
"}}}


" Settings related to the MarkdownPreview "{{{
nnoremap <leader><leader>mp  <nop>
nnoremap <leader><leader>mpa :MarkdownPreview<cr>
nnoremap <leader><leader>mpo :MarkdownPreviewStop<cr>

"" NOTE:  this stylesheet did not solve my problems, which were from my bad syntax.
""        I'm not sure yet IF this is helpful to me.
" From markdown PREVIEW plugin, this makes it look like Github style
" (copied from: https://github.com/sindresorhus/github-markdown-css)
"let g:mkdp_markdown_css = '~/.vim/vimfiles/github-markdown.css'
"}}}


" Settings related to the vim-unimpaired "{{{
" NOTE:  this option, 'unimpaired_recenter_after_jump', relies on my own
"        edit to the unimpaired plugin - it is harmless if the edit is
"        missing.  To edit the unimpaired here, just replace the first 3 lines
"        of the function 'MapNextFamily' with these 5 lines:
"              if !exists('g:unimpaired_recenter_after_jump') | let g:unimpaired_recenter_after_jump = 0 | en
"              let sfx = g:unimpaired_recenter_after_jump ? 'zz' : ''
"              let map = '<Plug>unimpaired'.toupper(a:map)
"              let cmd = '".(v:count ? v:count : "")."'.a:cmd
"              let end = '"<CR>'.(a:cmd ==# 'l' || a:cmd ==# 'c' ? 'zv'.a:sfx : '')
"        The key is the addition of the 'sfx' local value, and its use
let g:unimpaired_recenter_after_jump=1


"
" Unimpaired does not handle encoding or decoding Unicode -- I would like to add it
" In the meantime, here is a "whole-line" way of getting it done...
" (inspired by:  https://stackoverflow.com/a/21076866/5844631)
"
nnoremap [t :s#\v\\u([0-9a-f]{4})#\=nr2char(str2nr(submatch(1),16))#g<cr>:nohl<cr>
nnoremap ]t :s#.#\=printf("\\u%04x", char2nr(submatch(0)))#g<cr>:nohl<cr>

"" # When on windows:
"" #   NOTE:  the below Python only works if the Python DLL can be located.
"" #    AND:  vim automatically looks for 3.11
"" #    BUT:  my current work env needs <= 3.9.13, and I have commands to downgrade
"" #     SO:  I need to tell VIM about the 3.9 version if I downgraded here.
"" #
if has('win32')
    if filereadable('C:\Python39\python39.dll')
        set pythonthreedll=C:\Python39\python39.dll
    endif
endif

"
" unimpaired also does not support base64 encoding/decoding
" In the meantime, here are some home made "motion-based mappings" for getting
" it done. I copied a bit from Unimpaired, and studied a lot so I could add
" something minimal here in my own .vimrc file for Base64 encoding
"
" (inspired by: " https://stackoverflow.com/questions/7845671/how-to-execute-base64-decode-on-selected-text-in-vim)
"
if has('python3')
    python3 << trim endpython3
    #
    # TODO:  refactor this section to have common "arg" conversion helpers
    #        and return value "cleaning" helpers (such as stripping the appended newline)
    #
    import binascii
    def uudecode(encoded_ascii_value):
        if encoded_ascii_value is bytes:
            encoded_ascii_value = encoded_ascii_value.decode('utf-8')
        return binascii.a2b_uu(encoded_ascii_value)
    def uuencode(original_value):
        if type(original_value) is str:
            original_value = original_value.encode('utf-8')
        return binascii.b2a_uu(original_value)
    def base64decode(encoded_ascii_value):
        if encoded_ascii_value is bytes:
            encoded_ascii_value = encoded_ascii_value.decode('utf-8')
        return binascii.a2b_base64(encoded_ascii_value)
    def base64encode(original_value):
        if type(original_value) is str:
            original_value = original_value.encode('utf-8')
        return binascii.b2a_base64(original_value)
    def pyformat(original_value):
        import ast
        from pprint import pformat
        return pformat(ast.literal_eval(original_value))
    endpython3

    function! s:PyUuDecode(val) abort
        return py3eval("uudecode('" .. a:val .. "')")
    endfunction
    function! s:PyUuEncode(val) abort
        " NOTE:  not sure if the last character is always an extra appended newline
        "        but all of my testing it was, and stripping it here is easier than
        "        dealing with it during the VIM paste operation
        return py3eval("uuencode('" .. a:val .. "')[:-1]")
    endfunction

    function! s:PyBase64Decode(str) abort
        return py3eval("base64decode('" .. a:str .. "')")
    endfunction
    function! s:PyBase64Encode(str) abort
        " NOTE:  not sure if the last character is always an extra appended newline
        "        but all of my testing it was, and stripping it here is easier than
        "        dealing with it during the VIM paste operation
        return py3eval("base64encode('" .. a:str .. "')[:-1]")
    endfunction

    function! s:PyQueryStringDecode(str) abort
        return py3eval("qs_decode('" .. a:str .. "')")
    endfunction
    function! s:PyQueryStringEncode(str) abort
        " NOTE:  not sure if the last character is always an extra appended newline
        "        but all of my testing it was, and stripping it here is easier than
        "        dealing with it during the VIM paste operation
        return py3eval("qs_encode('" .. a:str .. "')[:-1]")
    endfunction

    function! s:VimToPyString(str) abort
        let l:str = a:str

        " These 3 changes convert the text into something that works in a .py file
        " HOWEVER: that does not work when passing into 'eval'
        let l:str = escape(l:str, "\\")
        let l:str = substitute(l:str, 'v:true', 'True', 'g')
        let l:str = substitute(l:str, 'v:false', 'False', 'g')

        " For eval we need one more escape of slashes - then wrap in single quotes
        let l:str = escape(l:str, "'\\")
        return "'" .. l:str .. "'"
    endfunction
    function! s:TidyPython(str) abort
        return py3eval("pyformat(" .. s:VimToPyString(a:str) .. ")")
    endfunction
endif

function! s:Base64Decode(str) abort
    return system('base64 -d', a:str)
endfunction
function! s:Base64Encode(str) abort
    " '-w 0' turns off wrapping of the output
    " otherwise the default wrapping is at column 76
    return system('base64 -w 0', a:str)
endfunction

"" # https://api.html-tidy.org/tidy/tidylib_api_5.4.0/tidy_quickref.html
nnoremap <expr> <leader>tc  <nop>
nnoremap <expr> <leader>tc? ':echo "Tidy Column: "' . (exists('g:TidyColumn') ? g:TidyColumn . '" (var)"' : winwidth(0) . '" (win)"') . '<cr>'
nnoremap <expr> <leader>tc& ':unlet g:TidyColumn<cr>'
nnoremap <expr> <leader>tcc ':<c-u>let g:TidyColumn = ' . v:count . '<cr>'
function! s:TidyOpts()
    if s:vcount == 0
        if ! exists('g:TidyColumn')
            let tidycol = winwidth(0)
        else
            let tidycol = g:TidyColumn
        endif
    elseif s:vcount == 1
        let tidycol = '0'
    else
        let tidycol = v:count
    endif
    let opts = '-q -i -w ' . l:tidycol . ' --break-before-br yes'
    " NOTE: this script-scoped variable is set to the value of `v:count` by `TransformMotionSetup` below
    if s:vcount == 2
        let opts = l:opts . ' --indent-attributes yes --wrap-attributes yes'
    endif
    echom "Opts: " . l:opts
    return l:opts
endfunction

function! s:TidyXml(str) abort
    return system('tidy -xml ' . s:TidyOpts(), a:str)
endfunction
function! s:TidyHtml(str) abort
    return system('tidy ' . s:TidyOpts(), a:str)
endfunction

function! s:TidyJson(str) abort
    " TODO:  optionally incorporate my new `jsontool` option:  "--no-sort" somehow
    let opts = ''
    if s:vcount == 1
        let opts = l:opts . ' --no-sort'
    elseif s:vcount == 2
        let opts = l:opts . ' --minify'
    endif
    return system('jsontool' . l:opts, a:str)
endfunction

function! s:TidyJavascript(str) abort
    return system('deno fmt -', a:str)
endfunction

function! s:TransposeMatrix(str) abort
    let l:rows = split(a:str, '\n', 1)
    let l:max_col = max(map(copy(l:rows), 'len(split(v:val))'))
    let l:lines = map(range(1, l:max_col), '[]')
    for l:row in l:rows
        let l:cols = split(l:row)
        for l:col in range(l:max_col)
            call add(l:lines[l:col], get(l:cols, l:col, ''))
        endfor
    endfor
    return join(map(l:lines, 'join(v:val)'), "\n")
endfunction

function! s:TransposeCSV(str) abort
    let l:rows = split(a:str, '\n', 1)
    let l:splitpat = '\v%("%(\\"|.)*"[ \t]*)?\zs,'
    let l:splitpat = ','
    let l:max_col = max(map(copy(l:rows), 'len(split(v:val, l:splitpat))'))
    let l:lines = map(range(1, l:max_col), '[]')
    for l:row in l:rows
        let l:cols = split(l:row, l:splitpat)
        for l:col in range(l:max_col)
            call add(l:lines[l:col], trim(get(l:cols, l:col, '')))
        endfor
    endfor
    return join(map(l:lines, 'join(v:val, ",")'), "\n")
endfunction

function! s:Demangle(str) abort
    "return system('llvm-cxxfilt', a:str)
    return trim(system('c++filt', a:str))
endfunction

function! s:Emojify(str) abort
    return substitute(a:str, ':\([-+_0-9a-z]\+\):', '\=emoji#for(submatch(1), submatch(0))', 'g')
endfunction

"" Ugly hack, so the script works PRE-8.0
""  (would prefer the new function arg default values)
function! TransformMotionSetupD(algorithm) abort
    let s:vcount = v:count
    let s:transform_algorithm = a:algorithm
    let s:transform_dbgecho = 1
    let &opfunc = 'TransformMotion'
    return 'g@'
endfunction
function! TransformMotionSetup(algorithm) abort
    let s:vcount = v:count
    let s:transform_algorithm = a:algorithm
    let s:transform_dbgecho = 0
    let &opfunc = 'TransformMotion'
    return 'g@'
endfunction

function! TransformMotion(type) abort
    " This was modified from 's:Transform' within Unimpaired
    let sel_save = &selection
    let cb_save = &clipboard
    set selection=inclusive clipboard-=unnamed clipboard-=unnamedplus
    let reg_save = exists('*getreginfo') ? getreginfo('@') : getreg('@')
    if a:type ==# 'line'
        silent exe "normal! '[V']y"
        let @@ = substitute(@@, "\n$", '', '')
    elseif a:type ==# 'block'
        silent exe "normal! `[\<C-V>`]y"
    else
        silent exe "normal! `[v`]y"
    endif
    if s:transform_dbgecho
        echom 'Pretransform:  "' . @@ . '"'
    endif
    let @@ = {s:transform_algorithm}(@@)
    if s:transform_dbgecho
        echom 'Postransform:  "' . @@ . '"'
    endif
    " NOTE:  there are some ISSUES regarding newlines.
    "        if the python transformation adds a final newline, then the
    "        'paste' operation becomes LINEWISEE, and adds a PRECEDING newline
    norm! gvp
    call setreg('@', reg_save)
    let &selection = sel_save
    let &clipboard = cb_save
endfunction

" NOTE:  these expression mappings cannot use "s:" prefixed functions :(
nnoremap <expr> <leader>] <nop>
nnoremap <expr> <leader>[ <nop>

"" #
"" # NOTE:  the use of the BLACK HOLE register as a macro in the below
"" #        mappings serves the purpose of:  EXhausting the COUNT value
"" #
"" #        this enables transformations to "use" v:count to control
"" #        transformation behavior WITHOUT affecting which lines of
"" #        the buffer get transformed.
"" #
if exists('*s:PyUuDecode')
    nnoremap <expr> <leader>]u "@_" . TransformMotionSetup('s:PyUuDecode')
    xnoremap <expr> <leader>]u "@_" . TransformMotionSetup('s:PyUuDecode')
    nnoremap <expr> <leader>]uu "@_" . TransformMotionSetup('s:PyUuDecode') . '_'
endif
if exists('*s:PyUuEncode')
    nnoremap <expr> <leader>[u "@_" . TransformMotionSetup('s:PyUuEncode')
    xnoremap <expr> <leader>[u "@_" . TransformMotionSetup('s:PyUuEncode')
    nnoremap <expr> <leader>[uu "@_" . TransformMotionSetup('s:PyUuEncode') . '_'
endif

if exists('*s:PyBase64Decode')
    nnoremap <expr> <leader>]p "@_" . TransformMotionSetupD('s:PyBase64Decode')
    xnoremap <expr> <leader>]p "@_" . TransformMotionSetupD('s:PyBase64Decode')
    nnoremap <expr> <leader>]pp "@_" . TransformMotionSetupD('s:PyBase64Decode') . '_'
endif
if exists('*s:PyBase64Encode')
    nnoremap <expr> <leader>[p "@_" . TransformMotionSetupD('s:PyBase64Encode')
    xnoremap <expr> <leader>[p "@_" . TransformMotionSetupD('s:PyBase64Encode')
    nnoremap <expr> <leader>[pp "@_" . TransformMotionSetupD('s:PyBase64Encode') . '_'
endif

if exists('*s:PyQueryStringDecode')
    nnoremap <expr> <leader>]r "@_" . TransformMotionSetup('s:PyQueryStringDecode')
    xnoremap <expr> <leader>]r "@_" . TransformMotionSetup('s:PyQueryStringDecode')
    nnoremap <expr> <leader>]rr "@_" . TransformMotionSetup('s:PyQueryStringDecode') . '_'
endif
if exists('*s:PyQueryStringEncode')
    nnoremap <expr> <leader>[r "@_" . TransformMotionSetup('s:PyQueryStringEncode')
    xnoremap <expr> <leader>[r "@_" . TransformMotionSetup('s:PyQueryStringEncode')
    nnoremap <expr> <leader>[rr "@_" . TransformMotionSetup('s:PyQueryStringEncode') . '_'
endif

nnoremap <expr> <leader>]b "@_" . TransformMotionSetup('s:Base64Decode')
xnoremap <expr> <leader>]b "@_" . TransformMotionSetup('s:Base64Decode')
nnoremap <expr> <leader>]bb "@_" . TransformMotionSetup('s:Base64Decode') . '_'
nnoremap <expr> <leader>[b "@_" . TransformMotionSetup('s:Base64Encode')
xnoremap <expr> <leader>[b "@_" . TransformMotionSetup('s:Base64Encode')
nnoremap <expr> <leader>[bb "@_" . TransformMotionSetup('s:Base64Encode') . '_'

nnoremap <expr> <leader>tx "@_" . TransformMotionSetup('s:TidyXml')
xnoremap <expr> <leader>tx "@_" . TransformMotionSetup('s:TidyXml')
nnoremap <expr> <leader>txx "@_" . TransformMotionSetup('s:TidyXml') . '_'

nnoremap <expr> <leader>th "@_" . TransformMotionSetup('s:TidyHtml')
xnoremap <expr> <leader>th "@_" . TransformMotionSetup('s:TidyHtml')
nnoremap <expr> <leader>thh "@_" . TransformMotionSetup('s:TidyHtml') . '_'

nnoremap <expr> <leader>tj "@_" . TransformMotionSetup('s:TidyJson')
xnoremap <expr> <leader>tj "@_" . TransformMotionSetup('s:TidyJson')
nnoremap <expr> <leader>tjj "@_" . TransformMotionSetup('s:TidyJson') . '_'

if exists('*s:TidyPython')
    nnoremap <expr> <leader>tp "@_" . TransformMotionSetup('s:TidyPython')
    xnoremap <expr> <leader>tp "@_" . TransformMotionSetup('s:TidyPython')
    nnoremap <expr> <leader>tpp "@_" . TransformMotionSetup('s:TidyPython') . '_'
endif

nnoremap <expr> <leader>tv "@_" . TransformMotionSetup('s:TidyJavascript')
xnoremap <expr> <leader>tv "@_" . TransformMotionSetup('s:TidyJavascript')
nnoremap <expr> <leader>tvv "@_" . TransformMotionSetup('s:TidyJavascript') . '_'

nnoremap <expr> <leader>tm "@_" . TransformMotionSetup('s:TransposeMatrix')
xnoremap <expr> <leader>tm "@_" . TransformMotionSetup('s:TransposeMatrix')
nnoremap <expr> <leader>tmm "@_" . TransformMotionSetup('s:TransposeMatrix') . '_'

nnoremap <expr> <leader>tc "@_" . TransformMotionSetup('s:TransposeCSV')
xnoremap <expr> <leader>tc "@_" . TransformMotionSetup('s:TransposeCSV')
nnoremap <expr> <leader>tcc "@_" . TransformMotionSetup('s:TransposeCSV') . '_'

nnoremap <expr> <leader>tg "@_" . TransformMotionSetup('s:Demangle')
xnoremap <expr> <leader>tg "@_" . TransformMotionSetup('s:Demangle')
nnoremap <expr> <leader>tgg "@_" . TransformMotionSetup('s:Demangle') . '_'

nnoremap <expr> <leader>to "@_" . TransformMotionSetup('s:Emojify')
xnoremap <expr> <leader>to "@_" . TransformMotionSetup('s:Emojify')
nnoremap <expr> <leader>too "@_" . TransformMotionSetup('s:Emojify') . '_'


" Adding a new function exploring interactions b/w Vim & Python.   Not used yet.
function! PyPrint() range
	let startline = line("'<")
	let endline = line("'>")
	python <<EOF
		import vim
		cb = vim.current.buffer
		start = vim.eval("startline")
		endl = vim.eval("endline")
		res = eval('\n'.join(cb[(start - 1) : endl]))
		vim.command("let vimres = '{}'".format(pprint.pformat(res)))
EOF
endfunction
"}}}


" Settings for editing JavaScript files "{{{

""
"" Simple re-format for minified Javascript
"" (from: https://coderwall.com/p/lxajqq/vim-function-to-unminify-javascript)
""
command! UnMinify call UnMinify()
function! UnMinify()
    %s/{\ze[^\r\n]/{\r/g
    %s/){/) {/g
    %s/};\?\ze[^\r\n]/\0\r/g
    %s/;\ze[^\r\n]/;\r/g
    %s/[^\s]\zs[=&|]\+\ze[^\s]/ \0 /g
    normal ggVG=
endfunction

"}}}


" Undotree mappings and settings "{{{
nnoremap <leader>ut :UndotreeToggle<cr>
let g:undotree_SetFocusWhenToggle = 1 " default 0

"" The plugin docs also have this example:
""
""		if has("persistent_undo")
""			let target_path = expand('~/.undodir')
""
""			" create the directory and any parent directories
""			" if the location does not exist.
""			if !isdirectory(target_path)
""				call mkdir(target_path, "p", 0700)
""			endif
""
""			let &undodir=target_path
""			set undofile
""		endif
""
"}}}


" DirDiff mappings and settings "{{{
"" NOTE:  this setting depends on my local edits to the plugin, I have not
""        yet asked to be pulled into the official author's repo
let g:DirDiffRecursive=1
let g:DirDiffIgnoreLineEndings=0
let g:DirDiffExcludes = "_.sw?,.*.sw?,*.pyc,*.a,*.o,*.so,*.dylib,.git"
"}}}


" BufExplorer mappings and settings "{{{
let g:bufExplorerShowNoName=1        " Show "No Name" buffers.
"}}}


" Mappings & settings for fugitive "{{{
nnoremap <leader>i <nop>
"  NOTE: the trailing space on some of these, leaving a "ready" command line
nnoremap <expr> <leader>i<space> ':<c-u>' . ( v:count == 1 ? 'vert ' : '' ) . 'G '
nnoremap <expr> <leader>ii (v:count == '0' ? ':<c-u>G<cr>' : (v:count == '1' ? ':<c-u>vert G<cr>' : ':<c-u>0G<cr>'))
"nnoremap <expr> <leader>it ':<c-u>echo ' . v:count . '<cr>'

nnoremap        <leader>io        <nop>
nnoremap        <leader>ior       :G config --get remote.origin.url<cr>

nnoremap        <leader>id        <nop>
nnoremap        <leader>idd       :Gdiffsplit!<cr>
nnoremap <expr> <leader>idb       ':Gdiffsplit! ' . system('git merge-base master HEAD')->trim() . '<cr>'
nnoremap        <leader>idv       :Gvdiffsplit!<cr>
nnoremap        <leader>idh       <nop>
nnoremap        <leader>idhh      :Ghdiffsplit!<cr>
nnoremap <expr> <leader>idhb      ':Ghdiffsplit! ' . system('git merge-base master HEAD')->trim() . '<cr>'
nnoremap <expr> <leader>id<space> ':Gdiffsplit! '

"nnoremap <expr> <leader>idp       ':<c-u>G diff origin/master...origin/pull/' . v:count . '<cr>'
nnoremap <expr> <leader>ib         <nop>
nnoremap <expr> <leader>ibd        <nop>
nnoremap <expr> <leader>ibdd       ':<c-u>vert G diff origin<cr>'
nnoremap <expr> <leader>ibdm       ':<c-u>vert G diff origin/master<cr>'
nnoremap <expr> <leader>ibdb       ':<c-u>vert G diff ' . system('git merge-base master HEAD')->trim() . '<cr>'
nnoremap <expr> <leader>ibdp       ':<c-u>vert G diff origin/master...origin/pull/' . v:count . '<cr>'
nnoremap <expr> <leader>ibd<space> ':<c-u>vert G diff '

nnoremap        <leader>io  :e cmds.md<cr>:G<cr>:copen<cr>:hide<cr>:hide<cr>

""NOTE:  this is *OFTEN* not defined when I think it should be, so I'm adding my own mapping for it
nnoremap <leader>dq :<c-u>call fugitive#DiffClose()<cr>

nnoremap <leader>ig <nop>
nnoremap <expr> <leader>igl ':Glgrep! '
nnoremap <expr> <leader>igc ':Ggrep! '

nnoremap <leader>ib  <nop>
nnoremap <leader>ibl :G blame<cr>
nnoremap <leader>ibr :G branch --list -a<cr>

nnoremap <expr> <leader>if ':<c-u>G fetch ' . (v:count == '0' ? '' : (v:count == '1' ? '--all --prune' : '')) . '<cr>'
nnoremap        <leader>iu  <nop>
nnoremap <expr> <leader>iuu ':<c-u>G push '          . (v:count == '2' ? '-u origin' : '') . '<cr>'
nnoremap <expr> <leader>iuf ':<c-u>G push --force '  . (v:count == '2' ? '-u origin' : '')
nnoremap <expr> <leader>iuw ':<c-u>G ' . (v:count == '1' ? 'forcefrom ' : 'pushfrom ') . expand("<cword>") . '<cr>'
xnoremap <expr> <leader>iuu ':<c-u>G pushfrom '      . VisualSelection() . '<cr>'
xnoremap <expr> <leader>iuf ':<c-u>G forcefrom '     . VisualSelection()
nnoremap        <leader>ip  <nop>
nnoremap <expr> <leader>ipp ':<c-u>G pull --ff-only<cr>'
nnoremap <expr> <leader>ipr ':<c-u>G pull --rebase<cr>'

nnoremap <expr> <leader>ir         <nop>
nnoremap <expr> <leader>ir<space>  ':G rebase -i '
nnoremap <expr> <leader>irw        ':G rebase -i ' . expand("<cword>")
nnoremap <expr> <leader>irr        ':G rebase -i ' . expand("<cword>") . '~<cr>'
xnoremap <expr> <leader>irr        ':G rebase -i ' . VisualSelection() . '~<cr>'

nnoremap        <leader>ic         <nop>
nnoremap        <leader>ica        :G commit --amend<cr>

" For the next one, pneumonic:  [C]urrent [W]ork
nnoremap        <leader>icw        :G diff origin/master --name-only<cr>

nnoremap        <leader>icz        <nop>
nnoremap <expr> <leader>icz<space> ':G stash '
nnoremap        <leader>iczl       :G stash list<cr>

nnoremap        <leader>iczu        <nop>
nnoremap <expr> <leader>iczu<space> ':G stash push -m '
nnoremap        <leader>iczuu       :G stash push -m current<cr>
nnoremap        <leader>iczs        <nop>
nnoremap <expr> <leader>iczs<space> ':G stash push --keep-index --staged -m '
nnoremap        <leader>iczss       :G stash push --keep-index --staged -m current_staged<cr>
nnoremap        <leader>iczg        <nop>
nnoremap <expr> <leader>iczg<space> ':G stash push --staged -m '
nnoremap        <leader>iczgg       :G stash push --staged -m current_staged<cr>

nnoremap <expr> <leader>icza       ':<c-u>G stash apply stash@{' . v:count . '}<cr>'
nnoremap <expr> <leader>iczp       ':<c-u>G stash pop stash@{' . v:count . '}<cr>'
nnoremap <expr> <leader>iczd       ':<c-u>G stash drop stash@{' . v:count . '}<cr>'
nnoremap <expr> <leader>iczw       ':<c-u>vert G stash show -p stash@{' . v:count . '}<cr>'
nnoremap        <leader>icc        <nop>
nnoremap <expr> <leader>icc<space> ':G checkout '
nnoremap        <leader>icm        <nop>
nnoremap <expr> <leader>icm<space> ':G merge '

"" #
"" # Not yet working
"" #
"" # function! GitDo(cmd) abort
"" #     if v:count == '0'
"" #         "" # Normal mode, just do what the plugin would do
"" #         let pfx = ''
"" #     elseif v:count == '1'
"" #         " # Requesting vertical mode
"" #         let pfx = 'vert '
"" #     else
"" #         "" # Any higher number requests "in same window" mode, prefix with "0"
"" #         let pfx = '0'
"" #     endif
"" #     exe ':<c-u>' . l:pfx . a:cmd
"" # endfunction
"" #
"" # Example mapping to use the above:
"" #
"" # nnoremap <leader>ilo :call GitDo('G hlog')<cr>
"" # nnoremap <leader>ila :call GitDo('G hlag')<cr>
"" #

function! Gpfx(count) abort
    if a:count == '0'
        return 'G '
    elseif a:count == '1'
        return 'vert G '
    endif
    return '0G '
endfunction

nnoremap <leader>il <nop>
nnoremap <expr> <leader>ilf        <nop>
nnoremap <expr> <leader>ilf<space> ':<c-u>' . Gpfx(v:count) . 'log --date=human --decorate -p --follow -- '
nnoremap <expr> <leader>ilff       ':<c-u>' . Gpfx(v:count) . 'log --date=human --decorate -p --follow -- ' . Expand('g') . '<cr>'
nnoremap <expr> <leader>ilo ':<c-u>' . Gpfx(v:count) . 'hlog<cr>'
nnoremap <expr> <leader>ila ':<c-u>' . Gpfx(v:count) . 'hlag<cr>'
" These next two mappings will populate the "local" and "quickfix" lists respectively
" NOTE: this involves an 'efm' within the Fugitive plugin that does NOT work with '--graph' or my '--pretty' formats
"       (i.e.  if I add --graph, then the quickfix window does not find the commits to jump to)
nnoremap <expr> <leader>ill ':Gllog! --date=human --decorate -- '
nnoremap <expr> <leader>ilc ':Gclog! --date=human --decorate -- '

"" #
"" # Notes on the different "grep" options:
"" #
"" # --grep=<pattern>
"" #
"" #     Limit the commits output to ones with a log message that matches the
"" #     specified pattern (regular expression). With more than one
"" #     --grep=<pattern>, commits whose message matches any of the given patterns
"" #     are chosen (but see --all-match).
"" #
"" #     When --notes is in effect, the message from the notes is matched as if it
"" #     were part of the log message.
"" #
"" #
"" #
"" # -S<string>
"" #
"" #     Look for differences that change the number of occurrences of the specified
"" #     string (i.e. addition/deletion) in a file. Intended for the scripter’s use.
"" #
"" #     It is useful when you’re looking for an exact block of code (like a
"" #     struct), and want to know the history of that block since it first came
"" #     into being: use the feature iteratively to feed the interesting block in
"" #     the preimage back into -S, and keep going until you get the very first
"" #     version of the block.
"" #
"" #     Binary files are searched as well.
"" #
"" #
"" #
"" # -G<regex>
"" #
"" #     Look for differences whose patch text contains added/removed lines that
"" #     match <regex>.
"" #
"" #     To illustrate the difference between -S<regex> --pickaxe-regex and
"" #     -G<regex>, consider a commit with the following diff in the same file:
"" #
"" #     +    return frotz(nitfol, two->ptr, 1, 0); ...
"" #     -    hit = frotz(nitfol, mf2.ptr, 1, 0);
"" #
"" #     While git log -G"frotz\(nitfol" will show this commit, git log
"" #     -S"frotz\(nitfol" --pickaxe-regex will not (because the number of
"" #     occurrences of that string did not change).
"" #
"" #     Unless --text is supplied patches of binary files without a textconv filter
"" #     will be ignored.
"" #
"" #     See the pickaxe entry in gitdiffcore[7] for more information.

nnoremap        <leader>ilg  <nop>
nnoremap <expr> <leader>ilgl ':Gllog! --date=human --decorate --all -G '
nnoremap <expr> <leader>ilgc ':Gclog! --date=human --decorate --all -G '
nnoremap        <leader>ils  <nop>
nnoremap <expr> <leader>ilsl ':Gllog! --date=human --decorate --all -S '
nnoremap <expr> <leader>ilsc ':Gclog! --date=human --decorate --all -S '
nnoremap        <leader>ilp  <nop>
nnoremap <expr> <leader>ilpl ':Gllog! --date=human --decorate --all --grep '
nnoremap <expr> <leader>ilpc ':Gclog! --date=human --decorate --all --grep '

nnoremap <leader>iw :Gwrite<cr>

"
" Mneumonic:    resolve merge
"
nnoremap <leader>rm  <nop>
" The {7} repeats below USED to be {4,} repeats. There may be a time 7 fails
nnoremap <leader>rmb gg/\v^[<=>]{7}(\ [A-Z0-9a-z]{1,}\|$)<cr>zz
"
" These two macros will not work on the first line (the 'k' will halt execution when it cannot go up a line)
" TODO:  add functions to handle this, also enabling period-repitition
"
" Here I create two "<Plug>" mappings that also incorporate Unimpaired's 'repeat' feature

"nnoremap <silent> <Plug>ResolvePickLeft  ddkndnddknzz
"nnoremap <silent> <Plug>ResolvePickRight dnddknddknzz
nnoremap <silent> <Plug>ResolvePickLeft  ddkndnddknzz:silent! call repeat#set("\<Plug>ResolvePickLeft", v:count)<cr>
nnoremap <silent> <Plug>ResolvePickRight dnddknddknzz:silent! call repeat#set("\<Plug>ResolvePickRight", v:count)<cr>

"" below i just call the new '<Plug>'-defined mapping - but unfortunately I cannot provide a {count}.
nmap <leader>rm, <Plug>ResolvePickLeft
nmap <leader>rm. <Plug>ResolvePickRight


"
" Adding some similar maps for P4-based merges which are different in the
" differences layout (P4 does not use unified diffs markers)
"
" TODO:  put this key sequence into a function that can automatically detect when the leading extra "dn" needs to be there
"        (which is the only difference b/w these mappings and the above)
"
nnoremap <silent> <Plug>P4ResolvePickLeft  dnddkndnddknzz:silent! call repeat#set("\<Plug>P4ResolvePickLeft", v:count)<cr>
nnoremap <silent> <Plug>P4ResolvePickRight dndnddknddknzz:silent! call repeat#set("\<Plug>P4ResolvePickRight", v:count)<cr>
"" below i just call the new '<Plug>'-defined mapping - but unfortunately I cannot provide a {count}.
nmap <leader>rp, <Plug>P4ResolvePickLeft
nmap <leader>rp. <Plug>P4ResolvePickRight

"
"       Debugging problems with fugitive
" I copied the below function from here:  https://stackoverflow.com/a/23318693/5844631
" and was gonna use it to help debug some stuff.  I never got around to trying
" it.   Instead...   I used the technique of running plugin functions by hand
" and with the '{count}verbose ' prefix.
"
" First you have to see what the function is, and I dump out the current
" mappings to help me figure this out (use:  \gm to get current mappings)
" Then I ran the function by hand using the following recipe:
"    :redir @s
"    :12verbose execute <SNR>###_StageDiff('Gdiffsplit')
"    :redir END
"  (the '###' part is different every time you load VIM - so you have to find it)
"
" Then I pasted the contents of the 's' register into a new buffer to analyze
"
function! ToJson(input)
	let json = ''
	if type(a:input) == type({})
		let parts = copy(a:input)
		call map(parts, '"\"" . escape(v:key, "\"") . "\":" . ToJson(v:val)')
		let json .= "{" . join(values(parts), ",") . "}"
	elseif type(a:input) == type([])
		let parts = map(copy(a:input), 'ToJson(v:val)')
		let json .= "[" . join(parts, ",") . "]"
	else
		let json .= '"'.escape(a:input, '"').'"'
	endif
	return json
endfunction
"}}}


" Dispatch mappings and settings "{{{

nnoremap `; :AbortDispatch<cr>

""
"" Basic mappings to focus dispatch using the current line ( and maybe also the 'b' register, 'b' for 'build' :) )
""
nnoremap        <leader>fd        <nop>
nnoremap <expr> <leader>fd<space> ':FocusDispatch '
nnoremap        <leader>fdl       :FocusDispatch <c-r><c-l><cr>
nnoremap        <leader>fdr       <nop>
nnoremap        <leader>fdrl      :FocusDispatch <c-r>b <c-r><c-l><cr>

""
"" Next are mappings (& helper function) specifically for MSBuild
""
function! SetMSBuildDispatch(count, cmd)
    ""
    "" NOTE:  this adjusts the JAVA_HOME environment variable within VIM
    ""        generally when launching MSBuild, this is what I want.
    ""        this will only become trouble if I find myself interleaving my MSBuild launching
    ""        with some other Java work for which I want a different JAVA_HOME
    ""
    call SetJavaHomeToToolsArea()

    ""
    "" MSBuild options: /m /nodeReuse:False
    ""                  /t:Rebuild
    ""                  /verbosity:detailed
    ""                  levels: q[uiet], m[inimal], n[ormal] (default), d[etailed], and diag[nostic].
    ""                  /p:Configuration=Release
    ""                  /p:Platform=x86
    ""                  /p:CM_ConfigToUse=.\Windows\Build\CM\config-dev.conf
    ""
    let mainargs = '/m /nr:False /p:GenerateFullPaths=true /verbosity:normal'
    if exists("g:msbuild_dispatch_args")
        let mainargs = l:mainargs + g:msbuild_dispatch_args
    endif

    let logargs = [
                \ '/flp1:logfile=' . getcwd() . '_build-logs\msbuild-minimal.log;verbosity=minimal',
                \ '/flp2:logfile=' . getcwd() . '_build-logs\msbuild-normal.log;verbosity=normal',
                \ '/flp3:logfile=' . getcwd() . '_build-logs\msbuild-detailed.log;verbosity=detailed',
                \ '/flp4:logfile=' . getcwd() . '_build-logs\msbuild-diagnostic.log;verbosity=diag',
                \ ]

    if a:count == 0
        let allargs = [a:cmd, l:mainargs, join(l:logargs)]
    elseif a:count == 1
        let allargs = [a:cmd, l:mainargs]
    else
        let allargs = [a:cmd]
    endif
    exe 'FocusDispatch ' . join(l:allargs) . ' ' . getline('.')
endfunc

nnoremap <leader>fdm    <nop>
nnoremap <leader>fdms   :<c-u>call SetMSBuildDispatch(v:count, 'msbuild')<cr>
nnoremap <leader>fd1    <nop>
nnoremap <leader>fd17   <nop>
nnoremap <leader>fd17b  :<c-u>call SetMSBuildDispatch(v:count, 'ms2017bt')<cr>
nnoremap <leader>fd17p  :<c-u>call SetMSBuildDispatch(v:count, 'ms2017pro')<cr>
nnoremap <leader>fd19   <nop>
nnoremap <leader>fd19b  :<c-u>call SetMSBuildDispatch(v:count, 'ms2019bt')<cr>
nnoremap <leader>fd19p  :<c-u>call SetMSBuildDispatch(v:count, 'ms2019pro')<cr>
nnoremap <leader>fd2    <nop>
nnoremap <leader>fd22   <nop>
nnoremap <leader>fd22b  :<c-u>call SetMSBuildDispatch(v:count, 'ms2022bt')<cr>
nnoremap <leader>fd22p  :<c-u>call SetMSBuildDispatch(v:count, 'ms2022pro')<cr>
nnoremap <leader>fdd    <nop>
nnoremap <leader>fddn   :<c-u>call SetMSBuildDispatch(v:count, 'dotnet publish')<cr>
nnoremap <leader>fd19d  <nop>
nnoremap <leader>fd19dn :<c-u>call SetMSBuildDispatch(v:count, 'dn2019bt publish')<cr>

nnoremap <leader>fdq     <nop>
nnoremap <leader>fdqm    <nop>
nnoremap <leader>fdqms   :FocusDispatch msbuild <c-r><c-l><cr>
nnoremap <leader>fdq1    <nop>
nnoremap <leader>fdq17   <nop>
nnoremap <leader>fdq17b  :FocusDispatch ms2017bt <c-r><c-l><cr>
nnoremap <leader>fdq17p  :FocusDispatch ms2017pro <c-r><c-l><cr>
nnoremap <leader>fdq19   <nop>
nnoremap <leader>fdq19b  :FocusDispatch ms2019pro <c-r><c-l><cr>
nnoremap <leader>fdq19p  :FocusDispatch ms2019pro <c-r><c-l><cr>
nnoremap <leader>fdqd    <nop>
nnoremap <leader>fdqdn   :FocusDispatch dotnet publish <c-r><c-l><cr>
nnoremap <leader>fdq19d  <nop>
nnoremap <leader>fdq19dn :FocusDispatch dn2019bt publish <c-r><c-l><cr>

""
"" Next are mappings (& helper function) specifically for Gradle
""
function! SetGradleDispatch(count, ...) abort range
    ""
    "" NOTE:  this adjusts the JAVA_HOME environment variable within VIM
    ""        generally when launching gradle, this is what I want.
    ""        this will only become trouble if I find myself interleaving my Gradle launching
    ""        with some other Java work for which I want a different JAVA_HOME
    ""
    if a:count == 0
        call SetJavaHomeToToolsArea()
    endif

    "" #
    "" # Set up the right "wrapper" to invoke
    "" #
    let projdir = matchstr(getline('.'), '\v--project-dir \zs\S+\ze')
    if len(l:projdir) > 0
        "" # Try from text on current line
        let gradleTool = l:projdir . '\gradlew'
    endif
    if !filereadable("l:gradleTool")
        "" # Try a default location
        let gradleTool = '.\gradlew'
    endif
    if !filereadable(l:gradleTool)
        "" # Just fall back onto the System wide install
        echom "WARNING:  cannot find a gradle wrapper to set up, defaulting to 'gradle' on path"
        let gradleTool = 'gradle'
    endif

    let mainargs = [l:gradleTool,
                \ '--stacktrace',
                \ ]
    if exists("g:gradle_dispatch_args")
        let mainargs = l:mainargs + g:gradle_dispatch_args
    endif

    exe 'FocusDispatch ' . join(l:mainargs + a:000) . ' ' . getline('.')
endfunc

nnoremap <leader>fdg    <nop>
nnoremap <leader>fdgr   :<c-u>call SetGradleDispatch(v:count, '--no-daemon')<cr>
nnoremap <leader>fdgd   :<c-u>call SetGradleDispatch(v:count)<cr>

" Mapping to copy the current :FocusDispatch value to the clipboard register
nnoremap <leader>fdc    <nop>
nnoremap <silent> <leader>fdcp :let @+='<c-r>=substitute(dispatch#focus()[0], ':Dispatch ', '', '')<cr>'<cr>
nnoremap <expr> <leader>fdch ':FocusDispatch ' . substitute(dispatch#focus()[0], ':Dispatch ', '', '')
"}}}


" Alignment/Tabular options & settings "{{{
" NOTE:  the 'nore' version of the mapping commands (nnoremap,...)
"        DO NOT work when calling a '<Plug>' mapping.
"
"        A non-recusive mapping requires normal mode and '<cr>'
"                nnoremap <leader>ll :EasyAlign<cr>
"
nmap <leader><leader>l <Plug>(EasyAlign)
xmap <leader><leader>l <Plug>(EasyAlign)


nnoremap        <leader><leader>t        <nop>
nnoremap <expr> <leader><leader>tt       ':Tabular /'
nnoremap <expr> <leader><leader>t<space> ':Tabular / <cr>'
nnoremap <expr> <leader><leader>t=       ':Tabular /=<cr>'
nnoremap <expr> <leader><leader>t:       ':Tabular /:<cr>'
nnoremap <expr> <leader><leader>t,       ':Tabular /,<cr>'

"" # "
"" # " This is (pneumonic:) 'TaBle Numbers'
"" # "    it aligns number columns on the decimal point.
"" # "
nnoremap        <leader>tb <nop>
nnoremap        <leader>tbn :<c-u>g/\v(\\|) *%([-$][- $]*)?[,0-9]+\.\d\d *\1/ s/\v(\\|) *(%([-$][- $]*)?[,0-9]+\.\d\d) *\1@=/\=printf('%s %'. (len(submatch(0))-3) .'s ', submatch(1), submatch(2))/g<cr>

"" # "
"" # " From:  https://gist.github.com/tpope/287147
"" # "
" A function that can be used to "auto align" as-you-type:
function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

" Then a mapping to call that function
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
"}}}


" AutoTag: options & settings "{{{
" Enable this to have auto recentering after jumping
" There is a new issue I experienced after upgrading.   I found this to
" explain it:
"       https://github.com/craigemery/vim-autotag/issues/34
" Right now, I'm only seeing it on my Mac.
if has('macunix')
	let g:autotagStartMethod='fork'
endif
"}}}


" YouCompleteMe:   options & settings "{{{
nnoremap <leader>yfw <Plug>(YCMFindSymbolInWorkspace)
nnoremap <leader>yfd <Plug>(YCMFindSymbolInDocument)

nnoremap <leader>y5 :YcmForceCompileAndDiagnostics<cr>:YcmDiags<cr>
nnoremap <leader>yl :YcmToggleLogs<cr>
nnoremap <leader>yr :YcmRestartServer<cr>
nmap <leader>yt <plug>(YCMHover)

"set completeopt=popup,menuone
""
"" These are the defaults copied from the help, here to be reminders of what is possible
""
"let g:ycm_min_num_of_chars_for_completion = 2
"let g:ycm_min_num_identifier_candidate_chars = 0
"let g:ycm_max_num_candidates = 50
"let g:ycm_max_num_candidates_to_detail = 0
"let g:ycm_max_num_identifier_candidates = 10
"let g:ycm_auto_trigger = 1
"" NOTE:  this is how to turn on completion when no file type is known
"let g:ycm_filetype_whitelist = {'*': 1, 'ycm_nofiletype': 1}
"let g:ycm_filetype_blacklist = { ... }
"let g:ycm_filetype_specific_completion_to_disable = {
"let g:ycm_filepath_blacklist = { 'html':1, 'jsx':1, 'xml':1 }
"let g:ycm_show_diagnostics_ui = 1
let g:ycm_error_symbol = 'E>' " default: '>>'
let g:ycm_warning_symbol = 'W>' " default: '>>'
"let g:ycm_enable_diagnostic_signs = 1
"let g:ycm_enable_diagnostic_highlighting = 1
"let g:ycm_echo_current_diagnostic = 1
let g:ycm_auto_hover = '' " default: 'CursorHold'
"let g:ycm_filter_diagnostics = {
"let g:ycm_always_populate_location_list = 1 " default: 0
"let g:ycm_open_loclist_on_ycm_diags = 1
let g:ycm_complete_in_comments = 1 " default: 0
"let g:ycm_complete_in_strings = 1
"let g:ycm_collect_identifiers_from_comments_and_strings = 0
"let g:ycm_collect_identifiers_from_tags_files = 0
"let g:ycm_seed_identifiers_with_syntax = 0
"let g:ycm_extra_conf_vim_data = []
"let g:ycm_server_python_interpreter = ''
"let g:ycm_keep_logfiles = 0
"let g:ycm_log_level = 'info'
"let g:ycm_auto_start_csharp_server = 1
"let g:ycm_auto_stop_csharp_server = 1
"let g:ycm_csharp_server_port = 0
"let g:ycm_csharp_insert_namespace_expr = ''
"let g:ycm_add_preview_to_completeopt = 0
"let g:ycm_autoclose_preview_window_after_completion = 0
"let g:ycm_autoclose_preview_window_after_insertion = 0
"let g:ycm_max_diagnostics_to_display = 30
"let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
"let g:ycm_key_list_previous_completion = ['<S-TAB>', '<Up>']
"let g:ycm_key_list_stop_completion = ['<C-y>']
"let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_key_detailed_diagnostics = '<leader>yd'
"let g:ycm_global_ycm_extra_conf = '~/.vim/global_ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0 " default: 1
"let g:ycm_extra_conf_globlist = ['~/dev/*','!~/*']
"let g:ycm_extra_conf_globlist = []
"let g:ycm_filepath_completion_use_working_dir = 0
"let g:ycm_semantic_triggers =  {
"let g:ycm_cache_omnifunc = 1
"let g:ycm_use_ultisnips_completer = 1
"let g:ycm_goto_buffer_command = 'same-buffer'
"let g:ycm_disable_for_files_larger_than_kb = 1000
"let g:ycm_use_clangd = 1
"let g:ycm_clangd_binary_path = ''
"let g:ycm_clangd_args = []
"let g:ycm_clangd_uses_ycmd_caching = 1
"let g:ycm_language_server = []
"let g:ycm_disable_signature_help = 1
"let g:ycm_gopls_args = []
"}}}


" quick-scope:   options & settings "{{{
let g:qs_highlight_on_keys = ['f','F','t','T']
nnoremap <leader>qs :QuickScopeToggle<cr>
augroup qs_colors
	au!
	au ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
	au ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
augroup END
"}}}


" Folding related mappings & settings - helps unleash SimpylFold plugin "{{{
set foldenable			" turn folding on
"set foldmethod=marker	" fold on the marker
set foldmethod=syntax	" fold based on syntax
set foldlevel=100		" don't autofold anything (but I can still fold manually)

set foldopen=block,hor,tag    " what movements open folds
set foldopen+=percent,mark
set foldopen+=quickfix

nnoremap <leader>fm? :set foldmethod?<cr>
nnoremap <leader>fm= :set foldmethod=
nnoremap <leader>fmm :set foldmethod=marker<cr>
nnoremap <leader>fmu :set foldmethod=manual<cr>
nnoremap <leader>fms :set foldmethod=syntax<cr>
nnoremap <leader>fme :set foldmethod=expr<cr>
nnoremap <leader>fmd :set foldmethod=diff<cr>
nnoremap <leader>fmi :set foldmethod=indent<cr>
nnoremap        <leader>fl  <nop>
nnoremap        <leader>fl? :set foldlevel?<cr>
nnoremap        <leader>fl& :set foldlevel&<cr>
nnoremap <expr> <leader>fll ":<c-u>set foldlevel=" . v:count . "<cr>"
nnoremap        <leader>fc  <nop>
nnoremap        <leader>fc? :set foldcolumn?<cr>
nnoremap        <leader>fc& :set foldcolumn&<cr>
nnoremap <expr> <leader>fcc ":<c-u>set foldcolumn=" . v:count . "<cr>"
"}}}


" NERDTree mappings and settings "{{{
nnoremap <leader>nt :NERDTreeToggle<cr>
nnoremap <leader>nf :NERDTreeFind<cr>
nnoremap <leader>ng :NERDTreeFocus<cr>
"" Found here: https://superuser.com/questions/1050256/how-can-i-set-relative-line-numbers-upon-entering-nerdtree-on-vim
let g:NERDTreeShowLineNumbers=1
" Turns out this part appears not necessary -- they are relative without this
" (perhaps because my main settings are to have relative enabled?)
"autocmd BufEnter NERD_* setlocal rnu

"" THe help shows how to adjust the mappings, and I am **trying**
"" to normalize the mappings for split/vert-split so that the 'vert'
"" mapping will somehow be a more vertical character
"" Here I am swapping the built-in 'i' and 's' because 'i' is more up-n-down looking
let g:NERDTreeMapOpenSplit='s'
let g:NERDTreeMapPreviewSplit='gs'
let g:NERDTreeMapOpenVSplit='i'
let g:NERDTreeMapPreviewVSplit='gi'

" Default ignore list:  ['\~$']
let g:NERDTreeIgnore=['\~$', '\.tmh$', '\.1\.tlog$']

" Adding my own key mapping to NERDTree to yank the path
"   found:  https://stackoverflow.com/a/16378375/5844631
if exists('NERDTreeAddKeyMap')
    autocmd VimEnter * call NERDTreeAddKeyMap({
            \ 'key': 'yy',
            \ 'callback': 'NERDTreeYankCurrentNode',
            \ 'quickhelpText': 'put full path of current node into the default register' })
endif

function! NERDTreeYankCurrentNode()
	let n = g:NERDTreeFileNode.GetSelected()
	if n != {}
		call setreg('"', n.path.str())
		if has('clipboard')
			call setreg('+', n.path.str())
		endif
	endif
endfunction

" This value is only from my own NERDTree customizations.  It was born from
" frustration that `NERDTreeFind` kept erroring for files that are opened via
" a symlink, that actually reside on a network share.
let g:NERDTreeFindWithResolve=0
"}}}


" CtrlP (& tags related) mappings and settings "{{{
" This is a technique to get VIM to search upwards for CTags 'tags' files
"  see:   ':h file-searching'
"  from:  https://stackoverflow.com/a/5019111/5844631
set tags=./tags;~
nnoremap <leader>gt :tj <c-r>=expand("<cword>")<cr><cr>

"
" These CTRL-P_CTRL_X mappings are for every mode
"
" NOTE: I am using the special <cmd> to avoid changing to command mode
"       This keeps any visual selection active, so CtrlP can use it
"
noremap        <c-p>      <nop>
noremap <expr> <c-p><c-c> '<cmd>CtrlP ' . Expand('~') . '\.conan\data<cr>'
noremap        <c-p><c-p> <cmd>CtrlP<cr>
noremap        <c-p><c-d> <cmd>CtrlPCurWD<cr>
noremap        <c-p><c-t> <cmd>CtrlPTag<cr>
noremap        <c-p><c-f> <cmd>CtrlPBufTag<cr>
noremap        <c-p><c-m> <cmd>CtrlPMRUFiles<cr>
noremap        <c-p><c-b> <cmd>CtrlPBuffer<cr>


" I got this idea from here:  https://thoughtbot.com/blog/faster-grepping-in-vim
if executable('ag')
	" Currently I do not manage to have 'ag' in all my various environments
	let g:ctrlp_max_files=0
    " TODO:  set this up to have directories I want CtrlP to ignore
	let g:ctrlp_user_command = 'ag %s -U -a -l --depth 50 --nocolor -g ""'
	" When using 'ag' to search based on file names -- it is so fast CtrlP does not need to cache enything
	" (we'll see about that claim ;)
	"let g:ctrlp_use_caching = 0
endif
let g:ctrlp_show_hidden = 1

nnoremap <expr> <c-p><c-g> ':let g:ctrlp_user_command = ''' . g:ctrlp_user_command . ''''

if has('win32')
    " NOTE:  the default behavior is "smart" case sentivity, which is normally just what I want
    "        but... I find myself copying existing file names as pasting them in the search
    "        so I want this on all the time when on windows :)
    "
    "  :<  this is NOT working
    "
    let g:ctrlp_mruf_case_sensitive = 0
endif

"" Use this to customize the mappings inside CtrlP's prompt to your liking. You
"" only need to keep the lines that you've changed the values (inside []): >
let g:ctrlp_prompt_mappings = {
    \ 'PrtInsert()':          ['<c-\>', '<c-g>'],
    \ 'PrtExit()':            ['<esc>', '<c-c>'],
    \ }
"}}}


" Tagbar mappings and settings "{{{
nnoremap <leader>tg :TagbarOpen fjc<cr>
nnoremap <leader>tt :TagbarToggle<cr>
let g:tagbar_autofocus=0
nnoremap <silent> <F9> :TagbarToggle<cr>
let g:tagbar_show_linenumbers=2
let g:tagbar_autoclose=0
let g:tagbar_autoshowtag=1
let g:tagbar_compact=1
let g:tagbar_show_visibility=1
let g:tagbar_sort=0
"}}}


" Settings for jumpy.vim "{{{
" Enable this to have auto recentering after jumping
"let g:jumpy_after = 'zz'

"nnoremap [[ ?\v(^\s*)@<=\{\|\{(\s*$)@=<cr>w99[{
"nnoremap ][ /\v^(\s*)@<=\}\|\}(\s*$)@=<cr>b99]}
"nnoremap ]] j0[[%/\v^(\s*)@<=\{\|\{(\s*$)@=<cr>
"nnoremap [] k$][%?\v^(\s*)@<=\}\|\}(\s*$)@=<cr>
"}}}


" My own "jump" related settings "{{{
"" #
"" # I am often interested in jumping to the START of the next paragraph,
"" # which requires the following motion sequence:  '}', '}', '{'
"" # (end of current, end of next, back to start of next)
"" #
"" # With the below, that will be just 'g}'
"" #
nnoremap g{ :call search('\v(\S[ \t]*\n)@<=^\s*$', 'bW')<cr>
nnoremap g} :call search('\v^\s*$(\n.{-}\S)@=', 'W')<cr>
"}}}


" Settings for vim-fontsize "{{{
"" With this plugin (and my knowledge so far) I finally abosorbed the difference
"" between 'timeoutlen' and 'ttimeoutlen' (extra 't' in front)
"" (for the 'ttime...' value, think of how '^[[1;3D' alltogether is just <alt+left>)
let g:fontsize#timeoutlen=3000
"}}}


" Settings for xterm-color-table "{{{
"   https://github.com/guns/xterm-color-table.vim
let g:XtermColorTableDefaultOpen = 'vsplit'
"}}}


" Settings for hexHighlight "{{{
"   https://brcm-isg-ims-nis-ses.slack.com/archives/C01P13BH5C6/p1614197420024600
nmap <leader><leader>hh <Plug>ToggleHexHighlight
nmap <leader><leader>hs <Plug>ToggleSchemeHighlight
"}}}


" Color settings - incl. line hightlight "{{{

""""""" The plugin 'vim-cpp-enhanced-highlight'
""" Highlighting of class scope is disabled by default. To enable set
"let g:cpp_class_scope_highlight = 1

""" Highlighting of member variables is disabled by default. To enable set
let g:cpp_member_variable_highlight = 1

""" Highlighting of class names in declarations is disabled by default. To enable set
"let g:cpp_class_decl_highlight = 1

""" Highlighting of POSIX functions is disabled by default. To enable set
let g:cpp_posix_standard = 1

""" There are two ways to highlight template functions. Either
let g:cpp_experimental_simple_template_highlight = 1
""" which works in most cases, but can be a little slow on large files. Alternatively set
"let g:cpp_experimental_template_highlight = 1
""" which is a faster implementation but has some corner cases where it doesn't work.
""" Note: C++ template syntax is notoriously difficult to parse, so don't expect this feature to be perfect.


""" Highlighting of library concepts is enabled by
"let g:cpp_concepts_highlight = 1
""" This will highlight the keywords concept and requires as well as all named requirements (like DefaultConstructible) in the standard library.

""" Highlighting of user defined functions can be disabled by
"let g:cpp_no_function_highlight = 1

"" More color schemes, from a forum discussion, half way down:
""    https://developers.slashdot.org/story/08/07/03/1249246/best-color-scheme-for-coding-easiest-on-the-eyes
"" The color scheme is NOT a plugin, and needs to be manually retrieved.
"" NOTE:  zenburn is ONLY dark
""
""     "" A quick macro to more easily run the following commands
""     "" (since they're all in the middle of a comment)
""     let @r = "0wv$h\\evr"
""
""     "" For Linux
""     mkdir ~/.vim/colors
""     cd ~/.vim/colors && wget https://raw.githubusercontent.com/jnurmine/Zenburn/master/colors/zenburn.vim
""     cd ~/.vim/colors && wget https://raw.githubusercontent.com/vim-scripts/moria/master/colors/moria.vim
""
""     "" For Windows
""     mklink /d %VIMRUNTIME%\..\vimfiles %USERPROFILE%\.vim\vimfiles
""     mkdir %USERPROFILE%\.vim\vimfiles\colors
""     cd %USERPROFILE%\.vim\vimfiles\colors && wget https://raw.githubusercontent.com/jnurmine/Zenburn/master/colors/zenburn.vim
""     cd %USERPROFILE%\.vim\vimfiles\colors && wget https://raw.githubusercontent.com/vim-scripts/moria/master/colors/moria.vim
""

" I found the following web pages helpful for setting these values
"
"      Color reference:   https://jonasjacek.github.io/colors/
"                         (with pics & names)
"
"      Some wierd table I have yet to figure out:
"             https://siatwe.wordpress.com/2018/03/23/vim-ctermfg-and-ctermbg-color-values/
"
"      Skeleton i borrowed:    https://vi.stackexchange.com/questions/23066/change-cursorline-style

" I'm now used to using 'yox' from Unimpaired to highlight both line & column
"nnoremap <leader>h :set cursorline! cursorcolumn!<cr>
"augroup cursorline
"	au!
"	""
"	"" NOTE:  The '!' is requried because the CursorLine item has default values
"	""        (for more info, see:  https://stackoverflow.com/a/31146436/5844631)
"	""
"	au ColorScheme * hi clear CursorLine | hi! link CursorLine CursorColumn
"augroup END


" This is me experimenting with manually choosing when to link the highlight styles
nnoremap <leader>ll :hi clear CursorLine<cr>:hi! link CursorLine CursorColumn<cr>

nnoremap <leader>l   <Nop>
nnoremap <leader>l?  :colorscheme<bar>set background?<cr>
nnoremap <leader>la  <Nop>
nnoremap <leader>lb :colorscheme blue<cr>
nnoremap <leader>lc  <Nop>
nnoremap <leader>ld  <Nop>
nnoremap <leader>ldb :colorscheme darkblue<cr>
nnoremap <leader>ldf :colorscheme default<cr>
nnoremap <leader>ldl :colorscheme delek<cr>
nnoremap <leader>lds :colorscheme desert<cr>
nnoremap <leader>le  <Nop>
nnoremap <leader>lel :colorscheme elflord<cr>
nnoremap <leader>len :colorscheme evening<cr>
nnoremap <leader>lf  <Nop>
nnoremap <leader>lg  <Nop>
nnoremap <leader>lgb :colorscheme gruvbox<cr>
nnoremap <leader>lh  <Nop>
nnoremap <leader>li  <Nop>
nnoremap <leader>lib :colorscheme iceberg<cr>
nnoremap <leader>liy :colorscheme industry<cr>
nnoremap <leader>lj  <Nop>
nnoremap <leader>lk :colorscheme koehler<cr>
nnoremap <leader>ll  <Nop>
nnoremap <leader>lm  <Nop>
nnoremap <leader>lma :colorscheme moria<cr>
nnoremap <leader>lmv :colorscheme macvim<cr>
nnoremap <leader>lmn :colorscheme morning<cr>
nnoremap <leader>lmy :colorscheme murphy<cr>
nnoremap <leader>ln :colorscheme nord<cr>
nnoremap <leader>lo  <Nop>`
nnoremap <leader>lod :colorscheme onedark<cr>
nnoremap <leader>loh  <Nop>
nnoremap <leader>lohl :colorscheme onehalflight<cr>
nnoremap <leader>lohd :colorscheme onehalfdark<cr>
nnoremap <leader>lon :colorscheme one<cr>
nnoremap <leader>lop :colorscheme one<cr>:colorscheme PaperColor<cr>
nnoremap <leader>lp  <Nop>
nnoremap <leader>lpb :colorscheme pablo<cr>
nnoremap <leader>lpc :colorscheme PaperColor<cr>
nnoremap <leader>lpe :colorscheme pencil<cr>
nnoremap <leader>lpp :colorscheme peachpuff<cr>
nnoremap <leader>lq  <Nop>
nnoremap <leader>lr :colorscheme ron<cr>
nnoremap <leader>ls  <Nop>
nnoremap <leader>lse  <Nop>
nnoremap <leader>lsel :colorscheme seoul256-light<cr>
nnoremap <leader>lsed :colorscheme seoul256<cr>
nnoremap <leader>lsn :colorscheme shine<cr>
nnoremap <leader>lst :colorscheme slate<cr>
nnoremap <leader>lso :colorscheme solarized<cr>
nnoremap <leader>ls8 :colorscheme solarized8<cr>
nnoremap <leader>lsf :colorscheme solarized8_flat<cr>
nnoremap <leader>lsh :colorscheme solarized8_high<cr>
nnoremap <leader>lsl :colorscheme solarized8_low<cr>
nnoremap <leader>lt :colorscheme torte<cr>
nnoremap <leader>lu  <Nop>
nnoremap <leader>lv  <Nop>
nnoremap <leader>lw  <Nop>
nnoremap <leader>lx  <Nop>
nnoremap <leader>ly  <Nop>
nnoremap <leader>lz  <Nop>
nnoremap <leader>lzb :colorscheme zenburn<cr>
nnoremap <leader>lzn :colorscheme zellner<cr>

let g:pencil_higher_contrast_ui = 0   " 0=low (def), 1=high  (just background of code blocks)
let g:pencil_neutral_headings = 0   " 0=blue (def), 1=normal (normal == all-greyscale)
let g:pencil_terminal_italics = 0

" NOTE:  activating "one" *before* "papercolor" sets the colors of the file
"        heading bar (which is otherwise ignored by papercolor)
function! SetBackground() abort
    let init_background = ((strftime("%H") < 7) || (strftime("%H")) > 17) ? "dark" : "light"
    " I used to disable the setting of colors when opened with argument
    " I think this was to prevent fanciness that sometimes breaks when the
    " editor is launched automatically by GIT, Docker, or other application in
    " response to the user issuing some "edit" command.
    if 1 " 0 == len(argv())
        " NOTE:  I really use Papercolor almost everywhere   ... BUT ...
        "        that one does NOT properly handle the window status line
        "        SO I always find myself setting 'One' and then 'Papercolor'
        "        to get the status lines right.
        if has('macunix')
            let macos_cmd = 'osascript -e ''tell app "System Events" to tell appearance preferences to get dark mode'''
            let l:init_background = "false" == trim(system(l:macos_cmd)) ? "light" : "dark"
            "colorscheme solarized8_high
            "colorscheme papercolor
        elseif has('win32')
            " Doing both one-right-after-the-other does NOT work here in VIMRC :(
            " (so I have commentd out the switch to papercolor)
                " colorscheme one
                " redrawstatus!
            colorscheme papercolor
        else " Linux?
            colorscheme solarized8
        endif
    endif
    let &background = l:init_background
endfunction
if ! exists("s:colorscheme_default_has_been_set")
    let s:colorscheme_default_has_been_set = 1
    call SetBackground()
endif
"}}}


" borrowed mappings & settings 'nickaigi' "{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" The following options came from:  https://github.com/nickaigi/config/blob/master/.vimrc#L12
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set splitbelow
set splitright
set wildmode=longest,list	" what <tab> displays (or does) default was 'full'
"set vb t_vb=				" turn off the beeps AND the flashes
""
"" Mappings to traverse buffer list
""  Not sure if '<silent>' is helpful here, I do not quite understand it.
""  However, see ":help map-silent" for more help on what it does.
""
"" See ":help [" for what the bracket characters normally do
""
nnoremap <leader>bb :b#<CR>
"" Disabling items that come with the 'Unimpaired' plugin
"" nnoremap <silent> [b :bprevious<CR>
"" nnoremap <silent> ]b :bnext<CR>
"" nnoremap <silent> [B :bfirst<CR>
"" nnoremap <silent> ]B :blast<CR>
"" This is a way to delete the buffer but not the window
command! Bd b#<bar>bd#		"" close the current buffer, but not the window
nnoremap <leader>bd :b#<bar>bd#<cr>
nnoremap <leader>bq :b#<bar>bd!#<cr>
nnoremap <leader>bw :b#<bar>bw#<cr>
nnoremap <leader>bk :b#<bar>bw!#<cr>

" Command & mapping that take a {count} and reverse lines
command! -bar -range=% Reverse <line1>,<line2>g/^/m<line1>-1|nohl
nnoremap <leader>re :Reverse<CR>
xnoremap <leader>re :Reverse<CR>

""
"" Easy expansion of the active file directory
""
function! Expand(flags) abort
    "" TODO:  straighten this out so more of the base modifiers are exposed
    ""        through my Expand() wrapper function
    ""        REQUIRES:  organizing the pneumonics to all fit

    ""
    "" Built-in modifiers:        see: :h filename-modifiers
    ""
    ""    :p           full path
    ""    :8           MS-Windows ONLY - convert to 8.3
    ""    :~           reduce to home-relative path
    ""    :.           reduce to CWD-relative path
    ""    :h           'head' of filename (last component)
    ""    :t           'tail' of filename (all but last component)
    ""    :r           'root' - with extension removed (can be repeated)
    ""    :e           'extension' -- just the extension
    ""    :S           escape special chars within filename (use as shell arg)
    ""
    "" Custom modifiers:
    ""
    ""    :d           same as 'h' ('head') but ensuring full path, i.e. '%:p:h'
    ""    :f           file name only (no extenstion)
    ""    :l           'link': current file name symbolic link target
    ""    :g           'git': git repo root relative for current file
    ""    :4           p4 depot path of current file
    ""
    "" Anything else:
    ""    ...          forwarded to expand('%:...') as flags on 'current file name'
    ""
    if     a:flags == 'd'
        let retval = expand('%:p:h')
    elseif a:flags == 'f'
        let retval = expand('%:t:r')
    elseif a:flags == 'l'
        let retval = expand('%')->resolve()
    elseif a:flags == 'g'
        let chdir = 'cd ' . expand('%:h')
        let gitcmd = 'git rev-parse --show-toplevel'
        let gitdir = trim(system(l:chdir . ' && ' . l:gitcmd))
        if len(l:gitdir) == 0
            return ''
        endif
        " from the full path, return everyting AFTER the full git repo dir
        let retval = Expand('p')[len(l:gitdir) + 1:]
    elseif a:flags == '4'
        let out = system('p4 where ' . shellescape(expand('%:p')))
        let retval = substitute(l:out, '\v^(//depot/.{-}) //.*', '\1', '')
    else
        let retval = expand('%:' . a:flags)
    endif
    let retval = substitute(l:retval, '\vfugitive:\\{3}', '', '')
    return l:retval
endfunction

function! CreateModifierMappings() abort
    cnoremap <expr> <c-s><c-e>  <nop>
    inoremap <expr> <c-s><c-e>  <nop>
    nnoremap <leader>gf  <nop>
    for ltr in "p8~.htreSdflg4"
        execute 'cnoremap <expr> %'.l:ltr.' getcmdtype() =~ ''[:=]'' ? Expand('''.l:ltr.''') : ''%'.l:ltr.''''
        execute 'cnoremap <expr> <c-s><c-e>'.l:ltr.' Expand('''.l:ltr.''')'
        execute 'inoremap <expr> <c-s><c-e>'.l:ltr.' Expand('''.l:ltr.''')'
        execute 'nnoremap <leader>gf'.l:ltr.' :let @"=''<c-r>=Expand('''.l:ltr.''')<cr>''<bar>let @+=@"<cr>'
    endfor
endfunction
call CreateModifierMappings()

function! GetLoc(flags, ...) abort
    ""
    "" Return a special location based on the passed in flags
    "" (like Expand() but totally unrelated to the current file's path)
    ""
    ""    +c           full path of conan data folder:  ~/.conan/data
    ""    +v           VisualSelection()
    ""    +x           VimRxEscape(VisualSelection())
    ""    +%           current directory
    ""
    let curloc = a:0 >= 1 ? a:1 : getcwd()
    if a:flags == 'c'
        let retval = expand('~') . '/.conan/data'
    elseif a:flags == 'p'
        let retval = expand('~') . '/.vim/plugged'
    elseif a:flags == 'v'
        let retval = VisualSelection()
    elseif a:flags == 'x'
        let retval = VimRxEscape(VisualSelection())
    elseif a:flags == 'd'
        let retval = expand('~') . '/Documents/devplay'
    elseif a:flags == 'g'
        let retval = trim(system('cd ' . l:curloc . ' && git rev-parse --show-toplevel'))
    elseif a:flags == '~'
        let retval = expand('~')
    elseif a:flags == '.'
        let retval = getcwd()
    else
        throw "Unknown GetLoc() flags: [".a:flags."]"
    endif
    return l:retval
endfunction

function! CreateLocMappings() abort
    cnoremap <expr> <c-s><c-g>  <nop>
    inoremap <expr> <c-s><c-g>  <nop>
    nnoremap <leader>gg  <nop>
    for ltr in "cpvxdg~."
        execute 'cnoremap <expr> ^'.l:ltr.' getcmdtype() =~ ''[:=]'' ? GetLoc('''.l:ltr.''') : ''^'.l:ltr.''''
        execute 'cnoremap <expr> <c-s><c-g>'.l:ltr.' GetLoc('''.l:ltr.''')'
        execute 'inoremap <expr> <c-s><c-g>'.l:ltr.' GetLoc('''.l:ltr.''')'
        execute 'nnoremap <leader>gg'.l:ltr.' :let @"=''<c-r>=GetLoc('''.l:ltr.''')<cr>''<bar>let @+=@"<cr>'
    endfor
endfunction
call CreateLocMappings()

""
"" Custom values...
""
cnoremap <expr> <c-s><c-o>  <nop>
cnoremap <expr> <c-s><c-o>a getcwd().'_build-logs\msbuild-diagnostic.log'
cnoremap <expr> <c-s><c-o>e getcwd().'_build-logs\msbuild-detailed.log'
cnoremap <expr> <c-s><c-o>n getcwd().'_build-logs\msbuild-normal.log'
cnoremap <expr> <c-s><c-o>m getcwd().'_build-logs\msbuild-minimal.log'

inoremap <expr> <c-s><c-o>  <nop>
inoremap <expr> <c-s><c-o>a getcwd().'_build-logs\msbuild-diagnostic.log'
inoremap <expr> <c-s><c-o>e getcwd().'_build-logs\msbuild-detailed.log'
inoremap <expr> <c-s><c-o>n getcwd().'_build-logs\msbuild-normal.log'
inoremap <expr> <c-s><c-o>m getcwd().'_build-logs\msbuild-minimal.log'

function! OutputLog(expr) abort
    let l:res = split(glob('.\Output\Logs\en-us**\' . a:expr), '\n')
    let l:res = l:res + split(glob('.\Windows**\' . a:expr), '\n')
    if len(l:res) <= 1
        let l:log = get(l:res, 0, '')
    else
        let prompt = copy(l:res)
        for idx in range(len(prompt))
           let l:prompt[l:idx] = l:idx . '. ' . l:prompt[l:idx]
        endfor
        echo 'The expression, ' . a:expr . ', had multiple matches:'
        let l:log = get(l:res, inputlist(l:prompt), '')
    endif
    if l:log == ''
        throw 'Unable to find output build log for [' . a:expr .']'
    endif
    return l:log
endfunction

cnoremap <expr> <c-s><c-o>r OutputLog('*Reporting*.txt')
cnoremap <expr> <c-s><c-o>o OutputLog('*OldServer*.txt')
cnoremap <expr> <c-s><c-o>b OutputLog('*Bootstrap*.txt')
cnoremap <expr> <c-s><c-o>w OutputLog('*NewServer.txt')
cnoremap <expr> <c-s><c-o>c OutputLog('*Cpp*.txt')
cnoremap <expr> <c-s><c-o>8 OutputLog('*-msbuild-x86-Release.log')
cnoremap <expr> <c-s><c-o>6 OutputLog('*-msbuild-x86_64-Release.log')
cnoremap <expr> <c-s><c-o>g OutputLog('*-msbuild-*.log')

inoremap <expr> <c-s><c-o>r OutputLog('*Reporting*.txt')
inoremap <expr> <c-s><c-o>o OutputLog('*OldServer*.txt')
inoremap <expr> <c-s><c-o>b OutputLog('*Bootstrap*.txt')
inoremap <expr> <c-s><c-o>w OutputLog('*NewServer.txt')
inoremap <expr> <c-s><c-o>c OutputLog('*Cpp*.txt')
inoremap <expr> <c-s><c-o>8 OutputLog('*-msbuild-x86-Release.log')
inoremap <expr> <c-s><c-o>6 OutputLog('*-msbuild-x86_64-Release.log')
inoremap <expr> <c-s><c-o>g OutputLog('*-msbuild-*.log')

""
"" Handy mapping that I should have created LOOOOng ago.
""    (though really, all of my Ex-mode '<c-o>...' mappings are new)
""
cnoremap <expr> <c-s><c-o>v  VisualSelection()


"" mapping to set the current directory from a specific buffer's file path
""  w/o a count: uses the current buffer's path
"" with a count: uses the path of that buffer
nnoremap        <leader>c    <nop>
nnoremap        <leader>cd   <nop>
nnoremap <expr> <leader>cdb  ":<c-u>cd <c-r>=expand('" . (v:count == '0' ? '%' : '#' . v:count) . ":p:h')<cr><cr>"
nnoremap <expr> <leader>cdg  ":<c-u>cd <c-r>=GetLoc('g', fnamemodify((v:count == '0' ? '%' : '#' . v:count), ':p:h'))<cr><cr>"
nnoremap        <leader>cd.  :cd ..<cr>
nnoremap        <leader>cd.. :cd ../..<cr>

"nnoremap <expr> <leader>xbcd ":<c-u>bufdo cd <c-r>=expand('" . (v:count == '0' ? '%' : '#' . v:count) . ":p:h')<cr><cr>"
"nnoremap <expr> <leader>xtcd ":<c-u>tabdo cd <c-r>=expand('" . (v:count == '0' ? '%' : '#' . v:count) . ":p:h')<cr><cr>"
"nnoremap <expr> <leader>xwcd ":<c-u>windo cd <c-r>=expand('" . (v:count == '0' ? '%' : '#' . v:count) . ":p:h')<cr><cr>"

"" NOTE:  the other \p... mappings are about P4
nnoremap <leader>p   <nop>
nnoremap <leader>pw  <nop>
nnoremap <leader>pwd :verbose pwd<cr>

""
"" Save a file that requires root permissions (see ":help :w_c" and ":help c_%")
""
cnoremap w!! w !sudo tee >/dev/null %
" "}}}


" settings related to environment variables (windows only)"{{{

if has('win32')
    function! GetRegValue(key, val)
        " If 'val' is blank, we query for the "(default)" value (i.e. the un-named value)
        if len(a:val) == 0
            let varg = '/ve'
        else
            let varg = '/v ' . a:val
        endif
        let res = systemlist('reg query "' . a:key . '" ' . l:varg)
        let errorline = match(l:res, '\v^ERROR: \S+')
        if l:errorline >= 0
            " NOTE:  this is often called with a value that may not be
            "        there, no need to print an error for each time
            "
            "        (eg.  each ENV VAR is attempted to be read from)
            "        (     both hives, and most only exist in one   )
            "
            "echoerr trim(l:res[l:errorline])
            return ''
        endif
        let dataline = match(l:res, '\v REG_\S+ ')
        if l:dataline == -1
            echoerr 'Failed to parse non-error output'
            return ''
        endif
        let data = trim(l:res[l:dataline])
        " Next we remove the first two words from that line
        return substitute(l:data, '\v^.{-}REG_\S+\s+', '', '')
    endfunction

    function! ExpandEnvVars(val)
        if len(a:val) == 0
            return ''
        endif
        let quotedval = trim(system('echo "' . a:val . '"'))
        return substitute(l:quotedval, '\v^"|"$', '', 'g')
    endfunction

    let s:syskey = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
    let s:usrkey = 'HKEY_CURRENT_USER\Environment'

    function! ReloadEnvVar(name)
        " Default to reloading 'PATH' if nothing was provided
        if len(a:name) == 0
            let vname = 'PATH'
        else
            let vname = a:name
        endif

        " Special handling for 'USERNAME' -- use OS command to retrieve
        if l:vname =~? 'username'
            " This returns the fully qualified user name:  domain\username
            let full = trim(system('whoami'))
            " This strips the domain, and capitalizes it
            let newval = substitute(l:full, '\v^.{-}\\(.+)$', '\u\1', '')
            " In the special circumstance where the username is just capitalized, convert to lower
            if l:newval =~# '\v[A-Z][^A-Z]+$'
                let newval = l:newval->tolower()
            endif
        else
            " For the rest -- we read the registry for the new value(s)
            let sysval = ExpandEnvVars(GetRegValue(s:syskey, l:vname))
            let usrval = ExpandEnvVars(GetRegValue(s:usrkey, l:vname))

            if len(l:sysval) == 0 && len(l:usrval) == 0
                " For VARs that are not set in either place, we do nothiing
                "   this could be a VIM var, or a dynamic OS var (like 'ComSpec')
                if l:vname =~? '^Path$'
                    echoerr 'Unexpected:  [' . l:vname . '] was not found in either hive'
                endif
                return
            endif

            if len(l:sysval) > 0 && len(l:usrval) > 0
                " For VARs that are set in BOTH locations -- we either combine, or just pick the User value
                if l:vname =~? '^Path$'
                    let newval = trim(l:sysval, ';', '2') . ';' . l:usrval
                else
                    let newval = l:usrval
                endif
            else
                let newval = len(l:sysval) ? l:sysval : l:usrval
            endif

            if l:vname =~? '^Path$'
                " Special handling for 'PATH' -- append the VIM runtime path (and capitalize)
                let vname = 'PATH'
                let newval = l:newval . ';' . $VIMRUNTIME
            elseif l:vname =~? '\v^te?mp$'
                " Special handling for 'TEMP' and 'TMP':
                "   *)  first shorten the name to the old 8.3 filenames
                "   *)  then check the current session ID and possibly append
                let newval = fnamemodify(l:newval, ':8')
                " Using 'query session' as advised from here:
                "    https://superuser.com/questions/303927/how-can-i-retrieve-the-session-id-from-command-line
                let sessID = split(trim(filter(systemlist('query session'), 'v:val =~ "^\>"')[0]))[2]
                if sessID > 1
                    " NOTE:  this whole function only exists on Windows (see ~93 lines above)
                    "        (no need to check `has('win32')` for which slash to use)
                    let newvalWithSess = l:newval . '\' . l:sessID
                    if !empty(glob(l:newvalWithSess))
                        let newval = l:newval . '\' . l:sessID
                    endif
                endif
            endif
        endif

        exe 'let $' . l:vname . '=''' . l:newval . ''''
    endfunction
    command! -nargs=? ReloadEnvVar call ReloadEnvVar(<q-args>)
    CommandAbbrev revar ReloadEnvVar

    function! ReloadAllEnvVars()
        let allvars = {}

        let varlist = filter(systemlist('reg query "' . s:syskey . '"'), 'v:val =~# " REG_"')
        "let sysvars = {}
        for varinfo in map(varlist, 'trim(v:val)')
            let name = matchstr(l:varinfo, '\v^\S+')
            "let type = matchstr(l:varinfo, '\v(^\S+\s+)@<=REG_\S+')
            "let value = matchstr(l:varinfo, '\v(^\S+\s+REG_\S+\s+)@<=(\S.*)')
            "let sysvars[l:name] = {'type':l:type, 'value':l:value}
            let allvars[l:name] = ''
        endfor

        let varlist = filter(systemlist('reg query "' . s:usrkey . '"'), 'v:val =~# " REG_"')
        "let usrvars = {}
        for varinfo in map(varlist, 'trim(v:val)')
            let name = matchstr(l:varinfo, '\v^\S+')
            "let type = matchstr(l:varinfo, '\v(^\S+\s+)@<=REG_\S+')
            "let value = matchstr(l:varinfo, '\v(^\S+\s+REG_\S+\s+)@<=(\S.*)')
            "let usrvars[l:name] = {'type':l:type, 'value':l:value}
            let allvars[l:name] = ''
        endfor

        "echo sysvars
        "echo usrvars
        "for var in filter(keys(l:sysvars), 'has_key(l:usrvars, v:val)')
        "    if l:usrvars[l:var]['value'] != l:sysvars[l:var]['value']
        "        echo 'Var [' . l:var . '] has different values b/w system & user hives'
        "        echo '   system: ' . l:sysvars[l:var]['value']
        "        echo '     user: ' . l:usrvars[l:var]['value']
        "    else
        "        echo 'Var [' . l:var . '] has the same values b/w system & user hives'
        "    endif
        "endfor

        for var in keys(l:allvars)
            call ReloadEnvVar(var)
        endfor
    endfunction

    nnoremap <leader>r  <nop>
    nnoremap <leader>rv <nop>
    nnoremap <leader>rvp :ReloadEnvVar<cr>
    nnoremap <leader>rva :call ReloadAllEnvVars()<cr>
endif

" "}}}


" My own personal status line enhancements CURRENTLY DISABLED in favor of 'vim-airline' plugin "{{{
""
"" This is a function that would be called to build the status line, layed out just after
""
"function! DiffStatus()
"	if &l:diff == 1 | return '[diff]' | else | return '' | endif
"endfunction

"set statusline=%<%f\          " custom statusline
"set stl+=[%{&ff}]             " show fileformat
"set stl+=%{DiffStatus()}
"set stl+=%y%m%r%=
"set stl+=%-14.(%l,%c%V%)\ %P
"" In my older environments, running ':echo $TERM<cr>'   displays:  'screen'
"" so setting this value is a fix for airline to get it right.
""  see: https://github.com/vim-airline/vim-airline/issues/847#issuecomment-169757085
set t_Co=256

let g:airline#extensions#tabline#tab_nr_type=1
let g:airline#extensions#branch#displayed_head_limit=20
" This setting shows buffers in the top bar when there is just one tab
"let g:airline#extensions#tabline#enabled=1
"}}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" These options are related to general source editing
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Source editing mappings & settings "{{{

"" This first 'simple' mapping just performs a ':s' command to delete trailing whitespace
"nnoremap <leader>tr :%s/[ \t]\+$//<cr>

"" This second version does the same thing but preserves the search history
nnoremap <leader>tr :%s/[ \t]\+$//<bar>PopSearch<cr>

"" This third version was my inspiration, from http://stackoverflow.com/a/21087108/5844631
"" However, I am not sure why there is a '<cr>==' in the middle.  I am not sure what that does
"nnoremap <leader>tr :let b:old = @/<bar>%s/[ \t]\+$//<cr>==:nohls<bar>call histdel('/',-1)<bar>let @/ = b:old<cr>

""
"" For easy file type conversion and cleanup of the extra ^M characters that appear when converting Dos->Unix
""
function! TrimCarriageReturns()
    let save_cursor = getcurpos()
    try
        try
            execute '%s/\v(\r|\^M)+$//'
        catch /\vE486:/
            echo "No line-end extra carraige returns found :)"
        endtry
        try
            execute '%s/\v\r(\n)@!/\r/g'
        catch /\vE486:/
            echo "No mid-line extra carraige returns found :)"
        endtry
    finally
        PopSearch
        call setpos('.', save_cursor)
    endtry
endfunction

nnoremap <leader>ftu :e ++ff=unix<cr>
nnoremap <leader>fto :e ++ff=dos<cr>
nnoremap <leader>ftm :call TrimCarriageReturns()<cr>
nnoremap <leader>ftd :filetype detect<cr>
nnoremap <leader>ft? :set filetype?<cr>
nnoremap <leader>ft= :set filetype=

nnoremap <leader>ftt :set ft=text<cr>
nnoremap <leader>fth :set ft=help<cr>


""
"" These options are related to C/C++ source editing
""
" These are for indenting/unindenting/formating blocks of code
" NOTE:  these are very nearly colliding with the mappings that come with the BufExplorer plugin
nmap <leader>bi /\{<cr>j0mskn%k0me's0<c-v>'e0I	\tr's0kk
nmap <leader>bu /\{<cr>j0mskn%k0me's0<c-v>'e0x's0kk
nmap <leader>bf 0ms/\{<cr>%me's!'eclang-format<cr>

function! s:ClangFormat() abort
    call PosDump()
    "pyf trim(system('where vim-clang-format.py'))
endfunction

if executable('vim-clang-format.py')
    "dir /b /s /a-d "C:\Program Files (x86)\Microsoft Visual Studio\clang*.exe"
    let g:clang_format_path = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\Llvm\bin\clang-format.exe'
    let g:clang_format_style = 'file'
    let g:clang_format_fallback_style = 'llvm'
    noremap <leader><leader>kk :pyf <c-r>=trim(system('where vim-clang-format.py'))<cr><cr>
    inoremap <c-k> <c-o>:pyf <c-r>=trim(system('where vim-clang-format.py'))<cr><cr>

    "" # noremap <leader><leader>k :set formatexpr?<cr>
    "" # let &formatexpr = 's:ClangFormat()'
    augroup ClangFormatGroup
        au!
        "au BufEnter *.cpp *.h setlocal formatexpr=s:ClangFormat()
    augroup END
endif

if has('win32')
	nnoremap <leader>far :!attrib +r "<c-r>=expand("%:p")<cr>"<cr>
	nnoremap <leader>faw :!attrib -r "<c-r>=expand("%:p")<cr>"<cr>
	nnoremap <leader>fax <Nop>
else
	nnoremap <leader>far :!chmod -w "<c-r>=expand("%:p")<cr>"<cr>
	nnoremap <leader>faw :!chmod +w "<c-r>=expand("%:p")<cr>"<cr>
	nnoremap <leader>fax :!chmod +x "<c-r>=expand("%:p")<cr>"<cr>
endif
"}}}



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Key mappings and custom commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" HOW to use 'ALT' key mappings "{{{
"" Setting up mappings using the alt key is tricky.  The short story is to use
""          sed -n l
"" to print out the key codes of the key combinations you type.  Then use those
"" values directly in setting up the mapping - remembering that '^[' == <esc>
""
""  Key stroke : output of sed cmd  : text for mapping
""  -----------:--------------------:-----------------
""  <a+left>   : ^[[1;3D            : <esc>[1;3D
""  <a+down>   : ^[[1;3B            : <esc>[1;3B
""  <a+up>     : ^[[1;3A            : <esc>[1;3A
""  <a+right>  : ^[[1;3C            : <esc>[1;3C
""
""  <c+left>   : ^[[1;5D            ; <esc>[1;5D
""  <c+down>   : ^[[1;5B            ; <esc>[1;5B
""  <c+up>     : ^[[1;5A            ; <esc>[1;5A
""  <c+right>  : ^[[1;5C            ; <esc>[1;5C
""
""  <s+left>   : ^[[1;2D            ; <esc>[1;2D
""  <s+down>   : ^[[1;2B            ; <esc>[1;2B
""  <s+up>     : ^[[1;2A            ; <esc>[1;2A
""  <s+right>  : ^[[1;2C            ; <esc>[1;2C
""
""  <s+f4>     : ^[[1;2S            : <esc>[1;2S
""
"" see:  http://stackoverflow.com/questions/7501092/can-i-map-alt-key-in-vim
"" and:  http://stackoverflow.com/questions/5379837/is-it-possible-to-mapping-alt-hjkl-in-insert-mode
""
"}}}


" Quick fix mappings "{{{
""
"" These are helpful while processing the "quickfix" window
""
""  NOTE:   I had trouble with these mappings always always always beeping
""          This was fixed by removing the trailing comment from the line that defined the mapping
""          The following URL explains a couple of reasons why a mapping may beep, and the solutions...
""              http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_%28Part_2%29
""

""
"" F4       moves to next error in the quickfix window
"" Shift+F4 moves to previous (again used 'sed -n l' to get codes)
""
nnoremap <f4> :cn<cr>
if has("gui_running")
	nnoremap <S-f4> :cp<cr>
else
	nnoremap <esc>[1;2S :cp<cr>
endif

"" For moving back and forth between the remembered "lists"
nnoremap <leader>[q :colder<cr>
nnoremap <leader>]q :cnewer<cr>
nnoremap <leader>q  <nop>
nnoremap <leader>qq :chistory<cr>
nnoremap <leader>[l :lolder<cr>
nnoremap <leader>]l :lnewer<cr>
nnoremap <leader>ll :lhistory<cr>


""nnoremap <esc>[6;5~ ]c
""nnoremap <esc>[5;5~ [c

""
"" This pair of functions will automatically sort the quickfix window contents
"" every time it changes
""
function! s:CompareQuickfixEntries(i1, i2)
	if bufname(a:i1.bufnr) == bufname(a:i2.bufnr)
		return a:i1.lnum == a:i2.lnum ? 0 : (a:i1.lnum < a:i2.lnum ? -1 : 1)
	else
		return bufname(a:i1.bufnr) < bufname(a:i2.bufnr) ? -1 : 1
	endif
endfunction
function! s:SortUniqQFList()
	let sortedList = sort(getqflist(), 's:CompareQuickfixEntries')
	let uniqedList = []
	let last = ''
	for item in sortedList
		let this = bufname(item.bufnr) . "\t" . item.lnum
		if this !=# last
			call add(uniqedList, item)
			let last = this
		endif
	endfor
	call setqflist(uniqedList)
endfunction
augroup QuickFixSortGroup
    autocmd!
    "autocmd! QuickfixCmdPost * call s:SortUniqQFList()
augroup end
"}}}


" Easily move the current line up or down "{{{
""
"" These sweet mappings move lines up and down with alt+up and alt+down
"" HOWEVER there is a bug when trying to move down multiple lines!
""         (multiple lines work when moving up, though not elegantly)
""
"nnoremap <esc>[1;3B :m .+1<cr>
"nnoremap <esc>[1;3A :m .-2<cr>
"nnoremap <leader>j :m .+1<cr>
"nnoremap <leader>k :m .-2<cr>

"" Mappings that "float" straight vertically up and down until a non-white
"" character is encountered (from:  https://vi.stackexchange.com/a/213/9912)
nnoremap <leader>fj /\%<C-R>=virtcol(".")<CR>v\S<CR>
vnoremap <leader>fj /\%<C-R>=virtcol(".")<CR>v\S<CR>
nnoremap <leader>fk ?\%<C-R>=virtcol(".")<CR>v\S<CR>
vnoremap <leader>fk ?\%<C-R>=virtcol(".")<CR>v\S<CR>
"}}}


" Tab movement "{{{
"" disabling my original tab helpers - I had never started using them, AND the interfere with unimpaired mappings for CTags movement
"" nnoremap <silent> [t :tabprevious<CR>
"" nnoremap <silent> ]t :tabnext<CR>
"" nnoremap <silent> [T :tabfirst<CR>
"" nnoremap <silent> ]T :tablast<CR>
" These three are still useful
nnoremap <leader>aa :tabs<cr>
nnoremap <expr> <leader>ae ':tabedit '
nnoremap <expr> <leader>ab ':tab sb '
nnoremap <leader>an :tabnew<cr>
nnoremap <leader>ac :tabclose<cr>
nnoremap <leader>at :tab term<cr>
" For *moving* a tab, lets use ',' and '.'
nnoremap <leader>a, :tabm -1<cr>
nnoremap <leader>a. :tabm +1<cr>

""
"" Here's some awesome functions I found here:  https://vim.fandom.com/wiki/Move_current_window_between_tabs
""
function! MoveWinToPrevTab()
	"there is only one window
	if tabpagenr('$') == 1 && winnr('$') == 1
		return
	endif
	"preparing new window
	let l:tab_nr = tabpagenr('$')
	let l:cur_buf = bufnr('%')
	if tabpagenr() != 1
		close!
		if l:tab_nr == tabpagenr('$')
			tabprev
		endif
		sp
	else
		close!
		exe "0tabnew"
	endif
	"opening current buffer in new window
	exe "b".l:cur_buf
endfunc
function! MoveWinToNextTab()
	"there is only one window
	if tabpagenr('$') == 1 && winnr('$') == 1
		return
	endif
	"preparing new window
	let l:tab_nr = tabpagenr('$')
	let l:cur_buf = bufnr('%')
	if tabpagenr() < tab_nr
		close!
		if l:tab_nr == tabpagenr('$')
			tabnext
		endif
		sp
	else
		close!
		tabnew
	endif
	"opening current buffer in new window
	exe "b".l:cur_buf
endfunc
nnoremap <leader>ah :call MoveWinToPrevTab()<cr>
nnoremap <leader>al :call MoveWinToNextTab()<cr>
"}}}

" Opening & Closing mappings (utility windows and gui elements) "{{{
nnoremap <silent> <leader>o    <nop>
nnoremap <silent> <leader>oc   :<c-u>call OpenCompanionCode(v:count)<cr>

function! OpenCompanionCode(count) range abort
    " See if current file is "test" or "src"
    let cur = bufname("%")
    if l:cur !~? '\.java$'
        echoerr "This mapping currently only works with JAVA code"
        return
    endif

    let test = l:cur =~? '\wtest\.java$'
    echom "Starting with " . (l:test ? "test" : "src") . " code"

    let txforms = [
                \     ['\v(Java[/\\])@<=src([/\\])@=', 'test'],
                \     ['\v(Java[/\\])@<=test([/\\])@=', 'src'],
                \ ]
    for txf in l:txforms
        if 0 <= match(l:cur, l:txf[0])
            let new = substitute(l:cur, l:txf[0], l:txf[1], '')
            break
        endif
    endfor
    if ! exists('l:new') || l:new == l:cur
        echoerr "Unable to figure out companion file's location"
        return
    endif

    if l:test
        let new = substitute(l:new, 'test\.java$', '.java', '')
    else
        let new = substitute(l:new, '\.java', 'Test.java', '')
    endif

    if a:count == 0
        exe 'e ' . l:new
    elseif a:count == 1
        exe 'vs ' . l:new
    else
        exe 'sp ' . l:new
    endif
endfunction

if has('win32')
    nnoremap <silent> <leader>od   <nop>
    nnoremap <silent> <leader>odd  <nop>
    nnoremap <silent> <leader>oddt :!start <c-r>=substitute(system('echo %USERPROFILE%'), '\v[\s\n\r]+$', '', '')<cr>\Desktop<cr>
    nnoremap <silent> <leader>odt  <nop>
    nnoremap <silent> <leader>odtp :!start <c-r>=substitute(system('echo %TEMP%'), '\v[\s\n\r]+$', '', '')<cr><cr>
    nnoremap <silent> <leader>odu  <nop>
    nnoremap <silent> <leader>odup :!start <c-r>=substitute(system('echo %USERPROFILE%'), '\v[\s\n\r]+$', '', '')<cr><cr>
endif

function! Vopen(count, path) abort
    if a:count == 0
        exe 'tabedit ' . a:path
    elseif a:count == 1
        exe 'vs ' . a:path
    elseif a:count == 2
        exe 'edit ' . a:path
    else
        exe 'sp ' . a:path
    endif
    return ''
endfunction

nnoremap <silent> <leader>o. :<c-u>call Vopen(v:count, getline('.')->trim())<cr>
xnoremap <silent> <leader>o. :<c-u>call Vopen(v:count, VisualSelection())<cr>

nnoremap <silent> <leader>o <nop>
nnoremap <silent> <leader>oq :copen<cr>
nnoremap <silent> <leader>ol :lopen<cr>
nnoremap <silent> <leader>on :NERDTree<cr>
nnoremap <silent> <leader>ot :TagbarOpen<cr>

nnoremap <silent> <leader>og  <nop>
nnoremap <silent> <leader>ogm :set guioptions+=m<cr>
nnoremap <silent> <leader>ogs :set guioptions+=rL<cr>
nnoremap <silent> <leader>oga :set guioptions+=e<cr>

nnoremap <silent> <leader>z <nop>
nnoremap <silent> <leader>zq :cclose<cr>
nnoremap <silent> <leader>zl :lclose<cr>
nnoremap <silent> <leader>zn :NERDTreeClose<cr>
nnoremap <silent> <leader>zt :TagbarClose<cr>

nnoremap <silent> <leader>za :cclose<bar>lclose<bar>NERDTreeClose<bar>TagbarClose<cr>
nnoremap <silent> <leader>zz :hide<cr>
xnoremap <silent> <leader>zz :hide<cr>

nnoremap <silent> <leader>zg  <nop>
nnoremap <silent> <leader>zgm :set guioptions-=m<cr>
nnoremap <silent> <leader>zgs :set guioptions-=rL<cr>
nnoremap <silent> <leader>zga :set guioptions-=e<cr>

nnoremap <silent> <leader>zw  <nop>
nnoremap <silent> <leader>zwh :wincmd h<cr>:q<cr>
nnoremap <silent> <leader>zwj :wincmd j<cr>:q<cr>
nnoremap <silent> <leader>zwk :wincmd k<cr>:q<cr>
nnoremap <silent> <leader>zwl :wincmd l<cr>:q<cr>

"}}}

" Settings for vim-swap -- so the mappings do not clash with my own "{{{
""
"" By defining our own mappings, the plugin should detect this and NOT
"" set the default mappings (which are otherwise identical but use just
"" one leader).
""
"" My mapping that is clashing is "\xx" for maximizing a window.  When both
"" "\xx" and "\x" are defined, VIM pauses for the full timeout waiting for
"" the possible second 'x' -- making the swap mapping frustrating at best
""
"" The way I see it, plugins that are to be downloaded should have a well
"" thought out mapping scheme, and if not possible, default to double-leader
"" mappings
""
xmap <leader><leader>x  <plug>SwapSwapOperands
xmap <leader><leader>cx <plug>SwapSwapPivotOperands
nmap <leader><leader>x  <plug>SwapSwapWithR_WORD
nmap <leader><leader>X  <plug>SwapSwapWithL_WORD
"}}}


" argdo / bufdo / tabdo / windo mappings (i.e. my 'x' mappings) "{{{

" NOTE:  there will be other '\x?' mappings besides these, let's make them all safe
nnoremap <leader>x <nop>

nnoremap <leader>xb <nop>
nnoremap <leader>xt <nop>
nnoremap <leader>xw <nop>

" NOTE:  these have a TRAILING SPACE in the right-hand-side too (so the :... is ready to go)
nnoremap <expr> <leader>xa<space> ':tabdo '
nnoremap <expr> <leader>xb<space> ':bufdo '
nnoremap <expr> <leader>xr<space> ':argdo '
nnoremap <expr> <leader>xw<space> ':windo '

"}}}


" Window mappings & settings (including resizing with shit/ctrl arrows) "{{{
set noequalalways

" Hygiene for all the \w... mappings that follow
nnoremap <leader>w <nop>

" Settings for vim-windowswap
let g:windowswap_map_keys=0
" Without the above, these mappings get set:
"   n  <leader>pw :call WindowSwap#DeprecatedDo()<CR>
"   n  <leader>ww :call WindowSwap#EasyWindowSwap()<CR>
"   n  <leader>yw :call WindowSwap#DeprecatedMark()<CR>

function! EchoWindowInfo(verbose)
    if a:verbose == 2
        echo tabpagebuflist()
        echo winlayout()
    endif

    "for win in range(1, winnr('$'))
    "    echo [win, win_getid(l:win)]
    "endfor
    for bid in tabpagebuflist()
        let name = bufname(l:bid)

        if ! a:verbose
            echo printf('win:%-2d buf:%-2d -> "%s"', bufwinnr(l:bid), bufnr(l:bid), l:name)
        else
            let binfo = getbufinfo(l:bid)
            let bopts = getbufvar(l:bid, '&')
            let winfo = getwininfo(bufwinid(l:bid))
            let wopts = getwinvar(bufwinnr(l:bid), '&')

            echo '"' . l:name . '"'
            " NOTE:  getbufinfo() returns a HUGE dictionary for Nerd tree windows
            "        a) the PP (pretty print) function takes so long it seems like a hang
            "        b) even it was just echo'd it is pages and pages of packed text
            if l:name !~? "^NERD_tree_"
                PP l:binfo
            endif
            echo l:bopts
            PP l:winfo
            echo l:wopts
        endif
    endfor
endfunction

function! EqualizeWindows(force) abort
    for bid in tabpagebuflist()
        let can_reset = a:force
        let bopts = getbufvar(l:bid, '&')
        let wopts = getwinvar(bufwinnr(l:bid), '&')

        " If not forcing, check buf props -- maybe still reset
        if ! l:can_reset
            let neb_fw = getwinvar(bufwinnr(l:bid), 'neb_fw', 0)
            let neb_fh = getwinvar(bufwinnr(l:bid), 'neb_fh', 0)
            let can_reset = l:bopts['buftype'] == ''
                       \ && l:bopts['buflisted'] == 1
                       \ && l:bopts['swapfile'] == 1
                       \ && l:neb_fw != 1
                       \ && l:neb_fh != 1
        endif

        if l:wopts['winfixheight'] == 1 || l:wopts['winfixwidth'] == 1
            " Fixed windows *either* become unfixed...   or "fit to content"
            if l:can_reset
                echo "Resetting 'winfix...' options for " . bufname(l:bid)
                call setwinvar(bufwinnr(l:bid), '&winfixheight', 0)
                call setwinvar(bufwinnr(l:bid), '&winfixwidth', 0)
            else
                echo "Refitting to content, buffer " . bufname(l:bid)
                call win_execute(bufwinid(l:bid), 'resize ' .  2 + getbufinfo(l:bid)[0]['linecount'])
                if l:bopts['textwidth'] > 0
                    " NOTE:  NOT working :|
                    let newsize = (5 + l:bopts['textwidth'])
                    call win_execute(bufwinnr(l:bid), 'vertical resize ' . l:newsize)
                endif
            endif
        endif
    endfor
    wincmd =
endfunction
nnoremap <leader>ww <cmd>call EchoWindowInfo(v:count)<cr>
nnoremap <leader>we <cmd>call EqualizeWindows(v:count)<cr>
nnoremap <leader>ws :call WindowSwap#EasyWindowSwap()<CR>

nnoremap <leader>wf  <nop>
nnoremap <leader>wfz :unlet! w:neb_fh w:neb_fw<cr>:set nowfh<cr>:set nowfh<cr>
nnoremap <leader>wfh :let w:neb_fh = 1<cr>:set wfh<cr>
nnoremap <leader>wfw :let w:neb_fw = 1<cr>:set wfw<cr>
nnoremap <leader>wf? :call MultiEchoM('', ['Fixed width: ' . get(w:,'neb_fw',0), 'Fixed height: ' . get(w:,'neb_fh',0)])<cr>

function! SetGuiSize(lines, columns)
	" Inspired from: https://vim.fandom.com/wiki/Maximize_or_set_initial_window_size
	" But for me, when not in GUI - ANY attempt to adjust lines messed up the
	" display *beyond* the ability of "redraw!" to repair - so that part is commented out
	if has("gui_running")
		exe 'set lines='.a:lines
		exe 'set columns='.a:columns
	"else
	"	if exists("+lines")
	"		set lines=60
	"	endif
	"	if exists("+coluns")
	"		set coluns=235
	"	endif
	endif
endfunction
" These are for resizing to "pneumonic" sizes:
" 'x' for maximal
" 'n' for normal  (size that corresponds with my laptop monitor)
" 'm' for minimal
" 't' for tall
" 'q' for "quarter" size (of my big monitor)
" 'o' for "fourth" size (of my laptop screen)
nnoremap <leader>wx :call SetGuiSize(1000, 1000)<cr>
nnoremap <leader>wn :call SetGuiSize(93, 293)<cr>
nnoremap <leader>wm :call SetGuiSize(38, 135)<cr>
nnoremap <leader>wt :call SetGuiSize(100, 135)<cr>
nnoremap <leader>wq :call SetGuiSize(80, 272)<cr>
nnoremap <leader>wo :call SetGuiSize(48, 144)<cr>
nnoremap <leader>w? :set lines?<bar>set columns?<cr>

"nnoremap <leader>wz :call popup_clear(1)<cr>
function! ClosePopups()
    for popid in popup_list()
        echo 'Closing: ' . l:popid
        call popup_close(l:popid)
    endfor
endfunction
nnoremap <leader>wz :call ClosePopups()<cr>


""
"" Disabling these on MacOS - due to a new plugin i have:  vim-tmux-navigator
""
if ! has('macunix')
	" Make Control-direction switch between windows (like C-W h, etc)
	nmap <silent> <c-k> <c-w><c-k>
	nmap <silent> <c-j> <c-w><c-j>
	nmap <silent> <c-h> <c-w><c-h>
	nmap <silent> <c-l> <c-w><c-l>
endif

""
"" inspired from: https://vim.fandom.com/wiki/Fast_window_resizing_with_plus/minus_keys
""   NOTE:  the function Resize() and the corresponding mappings needed adjustment to work
""
"" The below mappings are different than the web-page suggests
""      on the page, the function returns the string to be executed, AND...
""                   the function is executed IN THE CONTEXT of the expression register
""      here, the function is called directly and IT DOES the work
""

" NOTE (jes): currently my TMUX uses default keys - so ALT is big resize and CTRL is small
"             for VIM - I am leaving it as SHIFT for big and CTRL for small

" Make Shift-arrows resize windows
if has("gui_running")
	nnoremap <silent> <S-Up>     :call Resize('+', '5')<cr>
	nnoremap <silent> <S-Down>   :call Resize('-', '5')<cr>
	nnoremap <silent> <S-Right>  :call Resize('>', '5')<cr>
	nnoremap <silent> <S-Left>   :call Resize('<', '5')<cr>
else
	nnoremap <silent> <esc>[1;2A :call Resize('+', '5')<cr>
	nnoremap <silent> <esc>[1;2B :call Resize('-', '5')<cr>
	nnoremap <silent> <esc>[1;2C :call Resize('>', '5')<cr>
	nnoremap <silent> <esc>[1;2D :call Resize('<', '5')<cr>
endif

" And Ctrl-arrows small adjustments (this is OK in VIM for me - because don't use arrows for navigating :)
if has("gui_running")
	nnoremap <silent> <C-Up>     :call Resize('+', '1')<cr>
	nnoremap <silent> <C-Down>   :call Resize('-', '1')<cr>
	nnoremap <silent> <C-Right>  :call Resize('>', '1')<cr>
	nnoremap <silent> <C-Left>   :call Resize('<', '1')<cr>
else
	nnoremap <silent> <esc>[1;5A :call Resize('+', '1')<cr>
	nnoremap <silent> <esc>[1;5B :call Resize('-', '1')<cr>
	nnoremap <silent> <esc>[1;5C :call Resize('>', '1')<cr>
	nnoremap <silent> <esc>[1;5D :call Resize('<', '1')<cr>
endif
" NOTE:  becuase I sometimes remote control through TeamViewer -- the
"        control codes do not always get through, so I also create leader
"        based mappings for small resizes:
nnoremap <silent> <leader>w<up>    :call Resize('+', '1')<cr>
nnoremap <silent> <leader>w<down>  :call Resize('-', '1')<cr>
nnoremap <silent> <leader>w<right> :call Resize('>', '1')<cr>
nnoremap <silent> <leader>w<left>  :call Resize('<', '1')<cr>

"" NOTE:  after getting over the learning curve of vim script - just enough to understand
""        what this function is doing:  trying to normalize so that '+' always makes the line go up
""        which requires different commands when in the upper -vs- lower pane (same for left/right)
""        I got it all correct (I think).   Yet...
""        I STILL get errors on line 3 of the function:  execute "normal \<c-w>k"
""
""               Error detected while processing function Resize:
""               line    3:
""                   ******     (based on return value because the function continues anyway)
""               Press ENTER or type command to continue
""
""        That line, (3), is written correctly and works when typed in directly
""             (its line 4 now that I've put in a comment just above it to highlight it)
""        I have no idea why this is failing on my system.
""
""  NOW:  as you can see, I changed the technique:  no more using the expression register
""
function! Resize(dir, distance)
	let this = winnr()
	if '+' == a:dir || '-' == a:dir
		execute "wincmd k"
		let new = winnr()
		if new == this
			execute "wincmd j"
			let new = winnr()
			if new == this
				return
			endif
			let x = 'top'
		else
			let x = 'bottom'
		endif
	elseif '>' == a:dir || '<' == a:dir
		execute "wincmd h"
		let new = winnr()
		if new == this
			execute "wincmd l"
			let new = winnr()
			if new == this
				return
			endif
			let x = 'left'
		else
			let x = 'right'
		endif
	endif
	execute this . "wincmd w"

	" These used to return a string that would populate the expression register (@=)
	" so it was this:  "5\<c-v>\<c-w>..." which is the key sequence necessary when using @=
	" (also adjusted to resive the move distance as an argument)
	if ('+' == a:dir && 'bottom' == x) || ('-' == a:dir && 'top' == x)
		execute "normal " . a:distance . "\<c-w>+"
	elseif ('-' == a:dir && 'bottom' == x) || ('+' == a:dir && 'top' == x)
		execute "normal " . a:distance . "\<c-w>-"
	elseif ('<' == a:dir && 'left' == x) || ('>' == a:dir && 'right' == x)
		execute "normal " . a:distance . "\<c-w><"
	elseif ('>' == a:dir && 'left' == x) || ('<' == a:dir && 'right' == x)
		execute "normal " . a:distance . "\<c-w>>"
	else
		echo "oops. check your ~/.vimrc"
	endif
endfunction
"}}}


" Eclipse mappings for folding "{{{
nnoremap <c-kmultiply> zR
nnoremap <c-kdivide> zM
nnoremap <c-kplus> zo
nnoremap <c-kminus> zc
"}}}


" Mappings that are helpful for perforce "{{{
"nnoremap <leader>pe :!p4 edit "<c-r>=expand("%:p")<cr>"<cr>
"nnoremap <leader>pd :b#<cr>:!p4 delete "<c-r>=expand("#:p")<cr>"<cr>
"nnoremap <leader>pa :!p4 add "<c-r>=expand("%:p")<cr>"<cr>
"nnoremap <leader>pr :!p4 revert "<c-r>=expand("%:p")<cr>"<cr>
"nnoremap <expr> <leader>pb ':<c-u>1 Redir !p4 annotate -I -c ' . ( v:count==1 ? '-a ' : '' ) . '-u -T <c-r>=shellescape(expand("%:p"))<cr><cr>'

"nnoremap <leader>pf :!p4 diff "<c-r>=expand("%:p")<cr>"<cr>
"nnoremap <leader>pv :!start /min cmd /c "set P4DIFF=<c-r>=expand("~")<cr>\bin\simple-vimdiff.bat&& p4 diff ^"<c-r>=expand("%:p")<cr>^""<cr>


function! BackupCL(cl, name)
    call system('cl-save ' . a:cl . ' "' . a:name . '"')
    call system('cl-undo "' . a:name . '"')
endfunction
"}}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" This entire section is a breakdown of the default 'errorformat' value, with
"" an update to many of the individual expressions.  The update is to OPTIONALLY
"" match '[cc]' text at the start of the build output lines.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" errorformat section "{{{
""    The Vim expression:   \%( *[cc] \)\?
""        \%(...\)  : a grouping
""        \?        : zero or one of the preceding
""
""    Same, in errorformt:  %\\%%(\ %#[cc]\ %\\)%\\?
""
""    Additionally, this is a zero-width match for '/home':
""                          %\\%%(/home%\\)%\\@=
""
"    Missing these: [exec] File: /home/engineer/depot/components/stargate/work_branches/trunk/dev/src/platform/modules/sef/sef_wrapper.cpp Line Number: 278 Line: 		DoTraceFatal(msg.c_str());
"    (from CCX pre processor)


" NOTE:  (regarding:   vim-dispatch)
"
"   I've noticed that when there is a non-empty efm value, then
"   it will be used to parse the output of a dispatch EVEN THOUGH
"   a compiler was not set prior to dispatch, and during dispatch
"   the compiler option was set by the plugin prior to invoking
"   the current dispach command.
"
"   So while I intend to use vim-dispatch to launch my compiles,
"   I think I need this to be globally set to empty.
"      (so the default value is NOT used, and instead the value
"       from the 'compiler' settings are used)
"
"set efm=

""
"" old scanf()-like notation:      %*[^[] --(into vim regex)-->  %*[^\[]
"" regular expression style:       .*     --(into vim regex)-->  %.%#
"" regular expression style:       [^[]*  --(into vim regex)-->  %[%^[]%#
""
"" Examples of all three used to match anything up to the '[cc]'
""
""      set efm+=%*[^\[][cc]\ %f(%l)\ %#:\ %m
""      set efm+=%.%#[cc]\ %f(%l)\ %#:\ %m
""      set efm+=%[%^[]%#[cc]\ %f(%l)\ %#:\ %m
""

nnoremap <leader>m    <nop>
nnoremap <leader>m?   :set errorformat?<cr>
nnoremap <leader>m&   :set errorformat&<cr>
nnoremap <leader>m=   :set errorformat=
nnoremap <leader>mc   <nop>
nnoremap <leader>mcl  :set errorformat=<cr>
nnoremap <leader>ms   <nop>
nnoremap <leader>msc  :set errorformat=%f(%l)\ %#:\ %m,%f(%l\\\,%c)\ %#:\ %m,\ %#File\ "%f"\\\,\ line\ %l\\\,\ %m<cr>
nnoremap <leader>mst  :set errorformat=%f:%l:\ %m,%f:%l:%c:\ %m<cr>
nnoremap <leader>msg  <nop>
nnoremap <leader>msgr :set errorformat=%f\ %#%[\\|(:]\ %#%l%m<cr>
nnoremap <leader>msm  <nop>
nnoremap <leader>msms :set errorformat=%[0-9:.]%#\ %#%[0-9>:]%#%f(%l):\ %m,%[0-9:.]%#\ %#%[0-9>:]%#%f(%l\\\,%c):\ %m<cr>
nnoremap <leader>msmv :set errorformat=[%[a-z]%\\+]\ /%f[%l\\\,%c]\ %m<cr>
nnoremap <leader>msd  <nop>
nnoremap <leader>msdf :set errorformat=%[0-9:.]%#\ %#%[0-9>:]%#%f(%l\\\,%c):\ %m,%[0-9:.]%#\ %#%[0-9>:]%#%f(%l):\ %m,%[0-9:.]%#\ %#%[0-9>:]%#%f:%l:\ %m,\ %#%f(%l\\\,%c):\ %m,\ %#%f(%l):\ %m,\ %#%f:%l:\ %m,\ %#%f\ %#:\ %m<cr>
nnoremap <leader>msdl :set errorformat=%A%t%*\\w[%*[^]]]:\ %m,%C\ %#-->\ %f:%l:%c,%C%[0-9\ ]%\\+\\|%.%#,%C,%C\ %#\=\ hint:\ %m,%Z\ %#docs:\ %m<cr>

        "errorformat+=%[0-9:.]%#\ %#%[0-9>:]%#%f(%l):\ %m
        "errorformat+=%[0-9:.]%#\ %#%[0-9>:]%#%f(%l\\\,%c):\ %m
        "errorformat+=%f:%l:\ %m<cr>

nmap <leader>mg    <nop>
nmap <leader>mgb   :cgetb<cr>
xmap <leader>mgv   :<c-u>cget <c-r>=VisualSelection()<cr><cr>

nmap <leader>mgm   <nop>
nmap <leader>mgms  <nop>
nmap <leader>mgmsa :cget <c-r>=getcwd()<cr>_build-logs\msbuild-diagnostic.log<cr>
nmap <leader>mgmse :cget <c-r>=getcwd()<cr>_build-logs\msbuild-detailed.log<cr>
nmap <leader>mgmsn :cget <c-r>=getcwd()<cr>_build-logs\msbuild-normal.log<cr>
nmap <leader>mgmsm :cget <c-r>=getcwd()<cr>_build-logs\msbuild-minimal.log<cr>

nmap <leader>mgg   <nop>
nmap <leader>mggm  <nop>
nmap <leader>mggms \msdf:cget <c-r>=OutputLog('*-msbuild-*.log')<cr><cr>\mcl

nmap <leader>mgo   <nop>
nmap <leader>mgol  <nop>
nmap <leader>mgolr :copen<cr>\msdf:cget <c-o>r<cr>\mcl
nmap <leader>mgolo :copen<cr>\msdf:cget <c-o>o<cr>\mcl
nmap <leader>mgolb :copen<cr>\msdf:cget <c-o>b<cr>\mcl
nmap <leader>mgolw :copen<cr>\msdf:cget <c-o>w<cr>\mcl
nmap <leader>mgolc :copen<cr>\msdf:cget <c-o>c<cr>\mcl

""" For MSVC output (which uses parantheses)
""
"" Parts:
""   %[0-9:.]%#    optional timestamp at start of line
""   \ %#          optional whitespace
""   %[0-9>:]%#    optional project ID
""   %f            source file path
""   (%l)          source line number
""   :\ %m         colon, space, then error message
""
"set errorformat=%[0-9:.]%#\ %#%[0-9>:]%#%f(%l):\ %m

"set efm+=%.%#[cc]\ %f(%l)\ %#:\ %m
""" For GCC  output (which uses colons)
"set efm+=%.%#[cc]\ %f:%l:%c:%m
""set efm+=%.%#[cc]%.%#\ %f:%l%.
"set efm+=%.%#[exec]\ %#%f(%l)\ %#:\ %m
"set efm+=%f(%l)\ %#:\ %m
"set efm+=%f:%l:%c:%m
"set efm+=%f:%l:\ %m
"
"" for AG searching and reporting results in binary files
"set efm+=Binary\ file\ %f\ matches\.

" For Java development (the "pointer" line is always there)
"set efm+=%A%f:%l:\ %t%\\w%#:\ %m,%-Z%p^,%-C%.%#


" for :grep   output
"set efm+=%.%#%f(%l)\ %#:\ %m

"" Got both of the two examples from 'quickfix.txt' (lines 1326 and 1341)
"" working at the same time by grouping the %Z expressions at the end
"set efm+=%C\ %.%#
"set efm+=%A\ \ File\ \"%f\"\\,\ line\ %l%.%#
"set efm+=%EError\ %n
"set efm+=%E%>Error\ in\ line\ %l\ of\ %f:
"set efm+=%Cline\ %l
"set efm+=%Ccolumn\ %c
"set efm+=%Z%[%^\ ]%\\@=%m
"set efm+=%Z%m
"set efm+=%+P[%f]
"set efm+=(%l\\,%c)%*[\ ]%t%*[^:]:\ %m
"set efm+=%-Q

"set efm+=%*[^\"]\"%f\"%*\\D%l:\ %m
"set efm+=\"%f\"%*\\D%l:\ %m
"set efm+=%+G%\\%%(\ %#[cc]\ %\\)%\\?%f:%l:\ (Each\ undeclared\ identifier\ is\ reported\ only\ once
"set efm+=%+G%\\%%(\ %#[cc]\ %\\)%\\?%f:%l:\ for\ each\ function\ it\ appears\ in.)
"set efm+=%+G%\\%%(\ %#[cc]\ %\\)%\\?In\ file\ included\ from\ %f:%l:%c:
"set efm+=%+G%\\%%(\ %#[cc]\ %\\)%\\?In\ file\ included\ from\ %f:%l:%c\\,
"set efm+=%+G%\\%%(\ %#[cc]\ %\\)%\\?In\ file\ included\ from\ %f:%l:%c
"set efm+=%+G%\\%%(\ %#[cc]\ %\\)%\\?In\ file\ included\ from\ %f:%l
"set efm+=%+G%\\%%(\ %#[cc]\ %\\)%\\?%*[\ ]from\ %f:%l:%c
"set efm+=%+G%\\%%(\ %#[cc]\ %\\)%\\?%*[\ ]from\ %f:%l:
"set efm+=%+G%\\%%(\ %#[cc]\ %\\)%\\?%*[\ ]from\ %f:%l\\,
"set efm+=%+G%\\%%(\ %#[cc]\ %\\)%\\?%*[\ ]from\ %f:%l
"" These pick up the output from executing Boost unit tests
"set efm+=%-G%*[^\[][exec]\ unknown\ location%m
"set efm+=%*[^\[][exec]\ %f(%l):%\\%%(\ last\ checkpoint%\\)%\\@=%m
"set efm+=%*[^\[][exec]\ %f(%l):\ %m
"set efm+=%*[^\[][exec]\ %*[^/\\:]:\ %f:%l:%m
""" These pick up the actual compile errors from the ANT output
""" NOTE:  they are extremely flexible, so I've added the zero-width '/home' match)
"set efm+=%\\%%(\ %#[cc]\ %\\)%\\?%\\%%(/%\\)%\\@=%f:%l:%c:%m
"set efm+=%\\%%(\ %#[cc]\ %\\)%\\?%\\%%(/%\\)%\\@=%f(%l):%m
"set efm+=%\\%%(\ %#[cc]\ %\\)%\\?%\\%%(/%\\)%\\@=%f:%l:%m

"set efm+=\"%f\"\\,\ line\ %l%*\\D%c%*[^\ ]\ %m
"set efm+=%D%*\\a[%*\\d]:\ Entering\ directory\ %*[`']%f'
"set efm+=%X%*\\a[%*\\d]:\ Leaving\ directory\ %*[`']%f'
"set efm+=%D%*\\a:\ Entering\ directory\ %*[`']%f'
"set efm+=%X%*\\a:\ Leaving\ directory\ %*[`']%f'
"set efm+=%DMaking\ %*\\a\ in\ %f,%f\|%l\|\ %m
" "}}}



" Runtimepath DISABLING section (for totally deactivating installed plugins without un-installing them "{{{
""
"" Experimenting with disabling plugins to see what's interfering with
"" Fugitive (specifically it hangs when exiting a diff)
""          (and spikes CPU when hanging)
""
"set runtimepath-=~\.vim\bundle\Vundle.vim
set runtimepath-=~\.vim\bundle\YouCompleteMe
set runtimepath-=~\.vim\bundle\matchit
"set runtimepath-=~\.vim\bundle\vim-unimpaired
"set runtimepath-=~\.vim\bundle\vim-eunuch
set runtimepath-=~\.vim\bundle\SimpylFold
"set runtimepath-=~\.vim\bundle\ctrlp.vim
"set runtimepath-=~\.vim\bundle\tagbar
"set runtimepath-=~\.vim\bundle\nerdtree
"set runtimepath-=~\.vim\bundle\nerdcommenter
set runtimepath-=~\.vim\bundle\vim-autotag
"set runtimepath-=~\.vim\bundle\nerdtree-useful-plugins
"set runtimepath-=~\.vim\bundle\bufexplorer
"set runtimepath-=~\.vim\bundle\argtextobj.vim
"set runtimepath-=~\.vim\bundle\vim-indent-object
"set runtimepath-=~\.vim\bundle\vim-airline
"set runtimepath-=~\.vim\bundle\vim-fugitive
"set runtimepath-=~\.vim\bundle\vim-scriptease
"set runtimepath-=~\.vim\bundle\vim-dispatch
set runtimepath-=~\.vim\bundle\splice.vim
set runtimepath-=~\.vim\bundle\vim-mergetool
set runtimepath-=~\.vim\bundle\quick-scope
"set runtimepath-=~\.vim\bundle\vim-repeat
"set runtimepath-=~\.vim\bundle\vim-surround
"set runtimepath-=~\.vim\bundle\vim-solarized8
"set runtimepath-=~\.vim\bundle\vim-dirdiff
"set runtimepath-=~\.vim\bundle\vim-swap
"set runtimepath-=~\.vim\bundle\vim-windowswap
"set runtimepath-=~\.vim\bundle\vim-easy-align
"set runtimepath-=~\.vim\bundle\vim-argumentative
"set runtimepath-=~\.vim\bundle\vim-fontsize
"set runtimepath-=~\.vim\bundle\gruvbox
"set runtimepath-=~\.vim\bundle\nord-vim
"set runtimepath-=~\.vim\bundle\onedark.vim
"set runtimepath-=~\.vim\bundle\iceberg.vim
"set runtimepath-=~\.vim\bundle\vim-one
"set runtimepath-=~\.vim\bundle\papercolor-theme
"set runtimepath-=~\.vim\bundle\vim-colors-solarized
"set runtimepath-=~\.vim\bundle\onehalf
"set runtimepath-=~\.vim\bundle\onehalf\vim
set runtimepath-=~\.vim\bundle\vim-cpp-enhanced-highlight
"set runtimepath-=~\.vim\bundle\jumpy.vim
set runtimepath-=~\.vim\bundle\hexHighlight
set runtimepath-=~\.vim\bundle\xterm-color-table.vim
"set runtimepath-=~\.vim\bundle\undotree
set runtimepath-=~\.vim\bundle\vim-stabs
"set runtimepath-=~\.vim\bundle\kotlin-vim
"set runtimepath-=~\.vim\bundle\coc.nvim




"set runtimepath-=~\.vim\bundle\Vundle.vim/after
set runtimepath-=~\.vim\bundle\YouCompleteMe/after
set runtimepath-=~\.vim\bundle\matchit/after
"set runtimepath-=~\.vim\bundle\vim-unimpaired/after
"set runtimepath-=~\.vim\bundle\vim-eunuch/after
set runtimepath-=~\.vim\bundle\SimpylFold/after
"set runtimepath-=~\.vim\bundle\ctrlp.vim/after
"set runtimepath-=~\.vim\bundle\tagbar/after
"set runtimepath-=~\.vim\bundle\nerdtree/after
"set runtimepath-=~\.vim\bundle\nerdcommenter/after
set runtimepath-=~\.vim\bundle\vim-autotag/after
"set runtimepath-=~\.vim\bundle\nerdtree-useful-plugins/after
"set runtimepath-=~\.vim\bundle\bufexplorer/after
"set runtimepath-=~\.vim\bundle\argtextobj.vim/after
"set runtimepath-=~\.vim\bundle\vim-indent-object/after
"set runtimepath-=~\.vim\bundle\vim-airline/after
"set runtimepath-=~\.vim\bundle\vim-fugitive/after
"set runtimepath-=~\.vim\bundle\vim-scriptease/after
"set runtimepath-=~\.vim\bundle\vim-dispatch/after
set runtimepath-=~\.vim\bundle\splice.vim/after
set runtimepath-=~\.vim\bundle\vim-mergetool/after
set runtimepath-=~\.vim\bundle\quick-scope/after
"set runtimepath-=~\.vim\bundle\vim-repeat/after
"set runtimepath-=~\.vim\bundle\vim-surround/after
"set runtimepath-=~\.vim\bundle\vim-solarized8/after
"set runtimepath-=~\.vim\bundle\vim-dirdiff/after
"set runtimepath-=~\.vim\bundle\vim-swap/after
"set runtimepath-=~\.vim\bundle\vim-windowswap/after
"set runtimepath-=~\.vim\bundle\vim-easy-align/after
"set runtimepath-=~\.vim\bundle\vim-argumentative/after
"set runtimepath-=~\.vim\bundle\vim-fontsize/after
"set runtimepath-=~\.vim\bundle\gruvbox/after
"set runtimepath-=~\.vim\bundle\nord-vim/after
"set runtimepath-=~\.vim\bundle\onedark.vim/after
"set runtimepath-=~\.vim\bundle\iceberg.vim/after
"set runtimepath-=~\.vim\bundle\vim-one/after
"set runtimepath-=~\.vim\bundle\papercolor-theme/after
"set runtimepath-=~\.vim\bundle\vim-colors-solarized/after
"set runtimepath-=~\.vim\bundle\onehalf/after
"set runtimepath-=~\.vim\bundle\onehalf\vim/after
set runtimepath-=~\.vim\bundle\vim-cpp-enhanced-highlight/after
"set runtimepath-=~\.vim\bundle\jumpy.vim/after
set runtimepath-=~\.vim\bundle\hexHighlight/after
set runtimepath-=~\.vim\bundle\xterm-color-table.vim/after
"set runtimepath-=~\.vim\bundle\undotree/after
set runtimepath-=~\.vim\bundle\vim-stabs/after
"set runtimepath-=~\.vim\bundle\kotlin-vim/after
"set runtimepath-=~\.vim\bundle\coc.nvim/after
"}}}
