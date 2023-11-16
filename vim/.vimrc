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

nnoremap <leader>v    <nop>
nnoremap <expr> <leader>vb   ':vert sb '
nnoremap <leader>ve   :tabedit $MYVIMRC<cr>
nnoremap <leader>vr   :so $MYVIMRC<cr>
nnoremap <leader>vt   :vert term<cr>
nnoremap <leader>vi   <nop>
nnoremap <leader>vif  <nop>
nnoremap <leader>vifn :set viminfofile=NONE<cr>
nnoremap <leader>vifd :set viminfofile&<cr>
nnoremap <leader>vif? :set viminfofile?<cr>
nnoremap <leader>vif= :set viminfofile=

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
"map Q gq

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
    return escape(a:val, '()[{?*+|^$.&~#')
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
    let rv = substitute(l:rv, '"', "'\"'", 'g')
    return VimCmdEscape(l:rv)
endfunction

vnoremap <silent> * :<C-U> let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
                   \gvy/\v<C-R>=&ic?'\c':'\C'<CR>
                   \<C-R><C-R>=substitute(VimRxEscape(@"), '\s\+', '\\s+', 'g')<CR><CR>
                   \gVzv:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U> let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
                   \gvy?\v<C-R>=&ic?'\c':'\C'<CR>
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
	let $BASH_ENV = "~/.bashrc_for_vim"
	set pyxversion=2
    " i: 'interactive' to get all the aliases
    "set shellcmdflag=-ic
    " NOTE:  I *wanted* to enable interactive shells all the time on MacOS, but...
    "        for some reason VIM launched in my iTerm was crashing!?!  I do not know why :(
    "        I do know, it was THIS LINE -- setting the 'shellcmdflag' option.
    "        So for now -- I will create a mapping to add interactive :D
    nnoremap <leader>shcfi :set shellcmdflag=-ic<cr>
elseif ! has('win32')
	let $BASH_ENV = "~/.bashrc_for_vim"
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

if has('gui_running')
    let s:first_run = 0
    if ! exists("s:font_set")
        let s:font_set = 1
        let s:first_run = 1

        let s:guifont=''
        if has('gui_win32')
            let s:guifont='Lucida_Console:h8:cANSI:qDRAFT'
        elseif has('gui_macvim')
            let s:guifont='Menlo-Regular:h11'
        elseif has('gui_gtk2') && !has('unix')
            let s:guifont='Consolas:h11:cANSI'
            "let s:guifont='Monospace:10'
        endif
    endif

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
    function! MakeGuiFont() range
        if v:count == 0
            return s:guifont
        endif
        return substitute(s:guifont, '\v:h\d+', ':h' . v:count, '')
    endfunction

    if s:guifont != ""
        nnoremap <expr> <leader>rf ':<c-u>set guifont=' . MakeGuiFont() . '<cr>'
        if s:first_run == 1
            let &guifont=s:guifont
            normal \<Plug>FontsizeDefault
        endif
    endif
endif
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
map  <F1> <esc>
imap <F1> <esc>

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
""
""       (see: https://vi.stackexchange.com/questions/25086/vim-hangs-when-i-open-a-typescript-file)
""
""       So now I have a mapping to set it to '1' only when my scrolling sucks
""
""
if has('macunix')
    set regexpengine=1
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
    if getcmdtype() != ":"
        return v:false
    endif
    if getcmdpos() == 1
        return v:true
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
    echo 'Count: ' . a:0
    let idx = 1
    for i in a:000
        echo '  arg ' l:idx . ': ' . i
        let idx = l:idx + 1
    endfor
endfunction
command! -nargs=* -complete=command -range ArgTestQ call ArgTest(<range>, <line1>, <line2>, <q-args>)
CommandAbbrev argtestq ArgTestQ
command! -nargs=* -complete=command -range ArgTestF call ArgTest(<range>, <line1>, <line2>, <f-args>)
CommandAbbrev argtestf ArgTestF

function! DbgTest()
    if v:count == 0
        let cnt = 10
    else
        let cnt = v:count
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
        echo histget(":", "-" . l:idx)
        let idx = l:idx - 1
    endwhile
endfunction
nnoremap <leader>tz :<c-u>call DbgTest()<cr>

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
nnoremap <leader>gem :<c-u>call GetSpecifiedInfo("map", 0)<cr>
nnoremap <leader>gek :<c-u>call GetSpecifiedInfo("marks", 0)<cr>
nnoremap <leader>gec :<c-u>call GetSpecifiedInfo("command", 0)<cr>
nnoremap <leader>gea :<c-u>call GetSpecifiedInfo("autocmd", 0)<cr>
nnoremap <leader>geh :<c-u>call GetSpecifiedInfo("highlight", 0)<cr>
nnoremap <leader>gel :<c-u>call GetSpecifiedInfo("let", 0)<cr>
nnoremap <leader>ger :<c-u>call GetSpecifiedInfo("registers", 0)<cr>
nnoremap <leader>ges :<c-u>call GetSpecifiedInfo("scriptnames", 0)<cr>
nnoremap <leader>geg :<c-u>call GetSpecifiedInfo("messages", 0)<cr>
nnoremap <leader>geq :<c-u>call GetSpecifiedInfo("clist", 0)<cr>
nnoremap <leader>geb <nop>
nnoremap <leader>gebq :<c-u>call GetSpecifiedInfo("clist!", 0)<cr>

nnoremap <leader>gev <nop>
nnoremap <leader>gevm :<c-u>call GetSpecifiedInfo("map", 1)<cr>
nnoremap <leader>gevk :<c-u>call GetSpecifiedInfo("marks", 1)<cr>
nnoremap <leader>gevc :<c-u>call GetSpecifiedInfo("command", 1)<cr>
nnoremap <leader>geva :<c-u>call GetSpecifiedInfo("autocmd", 1)<cr>
nnoremap <leader>gevh :<c-u>call GetSpecifiedInfo("highlight", 1)<cr>
nnoremap <leader>gevl :<c-u>call GetSpecifiedInfo("let", 1)<cr>
nnoremap <leader>gevr :<c-u>call GetSpecifiedInfo("registers", 1)<cr>
nnoremap <leader>gevs :<c-u>call GetSpecifiedInfo("scriptnames", 1)<cr>
nnoremap <leader>gevg :<c-u>call GetSpecifiedInfo("messages", 1)<cr>
nnoremap <leader>gevq :<c-u>call GetSpecifiedInfo("clist", 1)<cr>
nnoremap <leader>gevb <nop>
nnoremap <leader>gevbq :<c-u>call GetSpecifiedInfo("clist!", 1)<cr>

nnoremap <leader>geyd :<c-u>call GetSpecifiedInfo("YcmDebugInfo", 0)<cr>

function! GetSpecifiedInfo(cmd, verbose)
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
	if v:count == 1
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
function! Redir(cmd, rng, start, end)
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
		"if a:rng == 0
		"	let output = systemlist(cmd)
		"else
		"	let joined_lines = join(getline(a:start, a:end), '\n')
		"	let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
		"	"let output = systemlist(cmd . " <<< $" . cleaned_lines)
		"	let output = split(cleaned_lines, "\n")
		"endif
	else
        let output = execute(a:cmd)->split("\n")
	endif
    if a:rng == a:start && a:rng == a:end && a:rng == 1
        vnew
    else
        new
    endif
	let w:redir_scratch_window = 1
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
	call setline(1, output)
endfunction
command! -nargs=1 -complete=command -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)
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

function! GetMarksFile(fname)
    let path = a:fname->resolve()
    " Determine path to "marks" file
    if l:path =~? '\vDocuments\\build-files\\[^\\]{-}-cmds\.txt$'
        return substitute(l:path, '\v-cmds\.txt$', '-marks.txt', '')
    elseif l:path =~? '\vDocuments\\test-files\\cmds-[^\\]+\.txt$'
        return substitute(l:path, '\vcmds-([^\\]+\.txt)$', 'marks-\1', '')
    endif
    echoe "Only know how to save marks for my cmds files"
    return
endfunction

function! LoadMarks(fname)
    let markspath = GetMarksFile(a:fname)
    for line in l:markspath->readfile()
        let fields = l:line->split()
        " if it is an a-z mark...
        if len(l:fields) > 0 && l:fields[0] =~# '^[a-z]$'
            " set the mark in the current buffer
            echo l:fields[1] . 'mark ' . l:fields[0]
            exe l:fields[1] . 'mark ' . l:fields[0]
        endif
    endfor
endfunction

function! SaveMarks(fname)
    let markspath = GetMarksFile(a:fname)
    let cmdout = execute("marks")->split("\n")
    let marks = []
    for line in l:cmdout
        let fields = l:line->split()
        " if it is an a-z mark...
        if len(l:fields) > 0 && l:fields[0] =~# '^[a-z]$'
            echo l:fields[1] . 'mark ' . l:fields[0]
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
nnoremap <leader>kl :call LoadMarks(@%)<cr>
nnoremap <leader>ks :call SaveMarks(@%)<cr>

"}}}


" Mappings to execute the current line "{{{

""
"" Options and Helper functions first...
""
if has('win32')
    set shellcmdflag=/v:on\ /c
endif
function! LineAsWatchCmd() abort
    let cmd0 = split(getline('.'))[0]
    let loc = trim(system('where ' . l:cmd0))
    let ext = fnamemodify(l:loc, ':e')
    if v:count == 0
        let cmd = "term watch -d "
    else
        let cmd = "term watch -n " . v:count . " -d "
    endif
    if tolower(l:ext) == 'exe'
        let cmd = l:cmd . "'" . getline('.') . "'"
    else
        let cmd = l:cmd . 'cmd /c ' . CygEscape(getline('.'))
    endif
    return l:cmd
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
function! LineAsShellCmd(capture) abort
    return TextAsShellCmd(a:capture, getline('.'))
endfunction
function! VisualAsShellCmd(capture) abort
    return TextAsShellCmd(a:capture, VisualSelection())
endfunction
function! TextAsShellCmd(capture, text) abort
    " TODO:  this OS detection is duplicated just below, remove that
    "        duplication
    if has('win32')
        let line = '(' . VimCmdEscape(a:text) . ')'
        let heading = l:line
    else
        let line = VimCmdEscape(a:text)
        let heading = '(' . l:line . ')'
    endif
    if a:capture
        call OutputCaptureHeading(l:heading)
        let line = l:line . ' 2>&1 | tee -ai out.txt'
    endif
    return l:line
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
function! InnerParagraphAsShellCmd(capture) abort
    let inner = GetInnerParagraph()
    let lines = getline(l:inner[0], l:inner[1])

    " NOTE:  Here, each line will be surrounded by "()" and joined by "&"
    "        to combine multiple commands onto a single command line.
    "        the whole thing is intended to be executed with a single :!

    "        we cannot use shellescape(), since it surrounds each line with
    "        quotes so we use escape() to do what shellescape(..., 1) would do
    "        (i.e. escape the 'special' items)
    if has('win32')
        let lines = map(l:lines, '"(" . VimCmdEscape(v:val) . ")"')
        let heading = l:lines
    else
        let lines = map(l:lines, 'VimCmdEscape(v:val)')
        let heading = map(l:lines, '"(" . v:val . ")"')
    endif

    if a:capture
        call OutputCaptureHeading(l:heading)
        let lines = map(l:lines, 'v:val . " 2>&1 | tee -ai out.txt"')
    endif
    if has('win32')
        let linesep = ' & '
    else
        let linesep = ' ; '
    endif
    return join(l:lines, l:linesep)
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
        execute(l:line)
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
vnoremap <leader>ee :<c-u>norm ]op<c-r>=eval(VisualSelection())<cr><cr>
nnoremap <leader>em yypkA =<Esc>jOscale=2<Esc>:.,+1!bc<CR>kJ0
nnoremap <leader>ec :<c-r>=getline('.')<cr><cr>

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
vnoremap <leader>ed :<c-u>norm ]op<c-r>=EpochToDate(VisualSelection())<cr><cr>

nnoremap <leader>shrug :echo '¯\_(ツ)_/¯'<cr>
inoremap <expr> <c-s> '¯\_(ツ)_/¯'

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
nnoremap <leader>eg :r !<c-r>=LineAsShellCmd(0)<cr><cr>
nnoremap <leader>es :r !echo <c-r>=VimCmdEscape(getline('.'))<cr><cr>

"" er.    : [E]xecute [R]un           -- in foreground (no pasting)
"" el.    : [E]xecute [L]aunch        -- in background (no pasting)
"" e.f    : [E]xecute ... [F]ree      -- no redirection
"" e.c    : [E]xecute ... [C]apture   -- redirection & tee  (with: "2>&1 | tee -ai out.txt")
"" NEW:
"" elr    : [E]xecute [L]ine [R]un      -- w/o count: "free", with count: "capture"
"" ell    : [E]xecute [L]ine [L]aunch   -- w/o count: "free", with count: "capture"

nnoremap <leader>el <nop>
vnoremap <leader>ev <nop>

nnoremap <leader>elr :<c-u>!<c-r>=LineAsShellCmd(v:count)<cr><cr>
vnoremap <leader>evr :<c-u>!<c-r>=VisualAsShellCmd(v:count)<cr><cr>
if has('win32')
	nnoremap <leader>ell :<c-u>!start cmd /v:on /c "<c-r>=LineAsShellCmd(v:count)<cr> & pause"<cr>
	vnoremap <leader>evl :<c-u>!start cmd /v:on /c "<c-r>=VisualAsShellCmd(v:count)<cr> & pause"<cr>
else
	nnoremap <leader>ell :<c-u>!<c-r>=LineAsShellCmd(v:count)<cr> &<cr>
	vnoremap <leader>evl :<c-u>!<c-r>=VisualAsShellCmd(v:count)<cr> &<cr>
endif

if has ('win32')
    nnoremap <leader>wal :<c-u><c-r>=LineAsWatchCmd()<cr><cr><c-w>p
    nnoremap <leader>wvl :<c-u>vert <c-r>=LineAsWatchCmd()<cr><cr><c-w>p

    nnoremap <leader>waq <c-w>j<c-w><c-c>:bd<cr>
    nnoremap <leader>wvq <c-w>l<c-w><c-c>:bd<cr>
endif

""
"" For paragraphs
""
"" e.p.   : [E]xecute [R][L] [P]aragraph [F][C]
"" NEW:
"" epr    : [E]xecute [P]aragraph [R]un      -- w/o count: "free", w/ count: "capture"
"" epl    : [E]xecute [P]aragraph [L]aunch   -- w/o count: "free", w/ count: "capture"
"" epc    : [E]xecute [P]aragraph [C]ommands -- count not used (runs each line as VIM command)

nnoremap <leader>epr  :<c-u>!<c-r>=InnerParagraphAsShellCmd(v:count)<cr><cr>

if has('win32')
	nnoremap <leader>epl  :<c-u>!start cmd /v:on /c "<c-r>=InnerParagraphAsShellCmd(v:count)<cr> & pause"<cr>
else
    " For *nix surround it all with "()" for the "&" to apply (i.e. background all of it)
	nnoremap <leader>epl  :<c-u>!(<c-r>=InnerParagraphAsShellCmd(v:count)<cr>) &<cr>
endif
nnoremap <leader>epc :call ExecuteInnerParagraph()<cr>
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
function! ShowTabSettings()
	execute 'set expandtab?'
	execute 'set tabstop?'
	execute 'set shiftwidth?'
	execute 'set softtabstop?'
endfunc
function! SetSpaceSize()
	execute 'set expandtab'
	"" NOTE:  because I use the 'vim-stabs' plugin, it over-rides the '=' key
	""        when 'equalprg' is set, 'vim-stabs' honors it as an over-ride
	""        therefore, I default to allowing 'vim-stabs' to handle things
	""        but if it goes wonky, this mapping can setup my own tool
	""        (the mapping is redefined every time, to honor 'v:count')
	execute 'nnoremap <leader>se :<c-u>set equalprg=tabtool\ -tw\ ' . v:count . '\ -cls<cr>'
	execute 'set tabstop=' . v:count
	execute 'set shiftwidth=' . v:count
	execute 'set softtabstop=' . v:count
	echo "Set spaces to be:  " . v:count
endfunc
function! SetTabSize()
	execute 'set noexpandtab'
	execute 'nnoremap <leader>se :<c-u>set equalprg=tabtool\ -tw\ ' . v:count . '\ -clt<cr>'
	execute 'set tabstop=' . v:count
	execute 'set shiftwidth=' . v:count
	execute 'set softtabstop=' . v:count
	echo "Set tabs to be:  " . v:count
endfunc

" NOTE:  if you provide a count of ZERO -- it displays the curret settings
nnoremap <expr> <leader>ss ":<c-u>call " . (v:count ? "SetSpaceSize" : "ShowTabSettings") . "()<cr>"
nnoremap <expr> <leader>st ":<c-u>call " . (v:count ? "SetTabSize" : "ShowTabSettings") . "()<cr>"
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

" Next we map some mappings to switch between the programs on system that have more than one choice
if executable('ag')
	execute 'nnoremap <leader>grag :set grepprg=' . s:ag_cmd . '<cr>'
else
	execute 'nnoremap <leader>grag <Nop>'
endif
" NOTE:  no 'elseif'   -- all mappings defined if programs exist
if executable('ggrep')
	execute 'nnoremap <leader>grgg :set grepprg=' . s:gg_cmd . '<cr>'
else
	execute 'nnoremap <leader>grgg <Nop>'
endif
if executable('cgrep')
	execute 'nnoremap <leader>grcg :set grepprg=' . s:cg_cmd . '<cr>'
else
	execute 'nnoremap <leader>grcg <Nop>'
endif
execute 'nnoremap <leader>grgr :set grepprg=' . s:gr_cmd . '<cr>'
nnoremap <leader>grdf :set grepprg&<cr>

nnoremap <leader>grnv :set grepprg=<c-r>=escape(substitute(&grepprg, '--vimgrep ', '', ''), ' "\()\|')<cr><cr>
nnoremap <leader>grnb :set grepprg=<c-r>=escape(substitute(&grepprg, '--search-binary ', '', ''), ' "\()\|')<cr><cr>
nnoremap <leader>grab :set grepprg=<c-r>=escape(substitute(&grepprg, '\$\*$', '--search-binary $*', ''), ' "\()\|')<cr><cr>
nnoremap <leader>grns :set grepprg=<c-r>=escape(substitute(&grepprg, '--silent ', '', ''), ' "\()\|')<cr><cr>
nnoremap <leader>grch :set grepprg=<c-r>=escape(&grepprg, ' "\()\|')<cr>
" NOTE: above, the '|' char needs to be escaped, while '\' does not,
"       so the first '\' means itself and is not affecting the '(' right after it


nnoremap <expr> <leader>gr<space> ':lgrep! '
nnoremap <leader>gr? :set grepprg?<cr>

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
nnoremap        <leader>gw  <nop>
nnoremap <expr> <leader>gwc ':Redir !' . GrepPrgForCmd() . ' "' . GrepEscape(expand('<cword>')) . '" '
nnoremap <expr> <leader>gwl ':lgrep! "' . GrepEscape(expand('<cword>')) . '" '
nnoremap        <leader>ga  <nop>
nnoremap <expr> <leader>gac ':Redir !' . GrepPrgForCmd() . ' "' . GrepEscape(expand('<cWORD>')) . '" '
nnoremap <expr> <leader>gal ':lgrep! "' . GrepEscape(expand('<cWORD>')) . '" '
nnoremap        <leader>gl  <nop>
nnoremap <expr> <leader>glc ':Redir !' . GrepPrgForCmd() . ' "' . GrepEscape(getline(".")) . '" '
nnoremap <expr> <leader>gll ':lgrep! "' . GrepEscape(getline(".")) . '" '
vnoremap        <leader>gw  <nop>
vnoremap <expr> <leader>gwc ':<c-u>Redir !' . GrepPrgForCmd() . ' "<c-r>=GrepEscape(VisualSelection())<cr>" '
vnoremap <expr> <leader>gwl ':<c-u>lgrep! "<c-r>=GrepEscape(VisualSelection())<cr>" '

" \cf == C-lean F-ile listing   (the output of llist or clist -- so things like gF and CTRL-W_F work)
nnoremap <leader>cf :%s/\v^%( *\d+ )?(.{-}):(\d+):/\1 \2:/<cr>
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
command! -nargs=1 Gall call GallFunction(<q-args>)
"}}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" These options are new for me
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE: this only helps when '.vimrc' is re-sourced after loading a file that has
"       autoformating options.  (b/c of the filetype option below)
set formatoptions-=tc	" without this, wrapping is automatic for certain file types
nnoremap <leader>nw :set formatoptions-=tc<cr>


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


" settings related to 'diff' mode "{{{
set diffopt+=vertical
"" Disabling these two in favor of using the unimpaired shortcuts
"nnoremap <leader>df :diffoff<cr>
"nnoremap <leader>dt :diffthis<cr>
nnoremap <leader>xbdf :bufdo diffoff<cr>
nnoremap <leader>du :diffupdate<cr>
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
function! DiffOp(op) range
    exe 'normal' (v:count == 0 ? a:op : v:count . a:op)
endfunction
nnoremap <silent> <Plug>VimdiffGet :<c-u>call DiffOp('do')<cr>]czz:silent! call repeat#set("\<Plug>VimdiffGet", v:count)<cr>
nnoremap <silent> <Plug>VimdiffPut :<c-u>call DiffOp('dp')<cr>]czz:silent! call repeat#set("\<Plug>VimdiffPut", v:count)<cr>
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
nnoremap <leader>dw  <nop>
nnoremap <leader>dwi :set diffopt+=iwhite<cr>
nnoremap <leader>dww :set diffopt-=iwhite<cr>
nnoremap <leader>dc  <nop>
nnoremap <leader>dci :set diffopt+=icase<cr>
nnoremap <leader>dcc :set diffopt-=icase<cr>
function! SetDiffContext() range
    let opts = filter(split(&diffopt, ','), 'v:val !~ "^context"')
    if v:count != 0
        call add(l:opts, 'context:' . v:count)
    endif
    let &diffopt=join(l:opts, ',')
endfunction
nnoremap <leader>dx :<c-u>call SetDiffContext()<cr>
" This also switch tabs when diff mode is not ON
function! PageKeysForDiffs()
    return bufname('%') =~# 'fugitive:\\' || &diff
endfunction
nnoremap <expr> <c-pageup>   PageKeysForDiffs() ? ':normal [czz<cr>' : ':tabprev<cr>'
nnoremap <expr> <c-pagedown> PageKeysForDiffs() ? ':normal ]czz<cr>' : ':tabnext<cr>'

" These mappings are for "normalizing" text so LOGS may compare easier
nnoremap        <leader>dn  <nop>
nnoremap <expr> <leader>dni ':<c-u>% s/\v^\[.{-}\] /[TIME] /<cr>:PopSearch<cr><c-o>'
nnoremap <expr> <leader>dnp ':<c-u>% s/\v(] )@<=<c-r><c-w>( :)@=/PID' . v:count . '/<cr>:PopSearch<cr><c-o>'
nnoremap <expr> <leader>dnt ':<c-u>% s/\v(: )@<=<c-r><c-w>( :)@=/TID' . v:count . '/<cr>:PopSearch<cr><c-o>'
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
"" This is for Vundle,  hosted on github here:  https://github.com/nebbish/Vundle.vim
"" Vundle is a 'plugin manager' (but really a 'runtimepath' manager) I forked that
"" helps with vim plugins:  installing/uninstalling/updating/...
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vundle section    >>>  PLUGINs are in here  <<<    "{{{
""
"" It is based on pathogen, and supercedes it with ease of use - but requires 'git'
"" and will perform 'git clone' actions for each configured repository
""
"" Brief Vundle help
"" :PluginList       - lists configured plugins
"" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
"" :PluginSearch foo - searches for foo; append `!` to refresh local cache
"" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
""
"" see :h vundle for more details or wiki for FAQ
""
filetype off			"" required for Vundle to load, will be re-enabled below

""
"" NOTE:  Got this recipe for how to "bootstrap" a Vundle setup from a fresh
""        system with only 'git' available.
""  see:  https://gist.github.com/klaernie/db37962e955c82254fed
""
"" I have modified it in the following ways:
""    * to work on multiple platforms
""    * to use :exe instead of :! so that no windows pop up
""    * to activate my work branch from my Vundle fork
""
set runtimepath+=~/.vim/bundle/Vundle.vim
let s:bootstrap = 0
let s:vundlerepo = 'https://github.com/nebbish/Vundle.vim.git'
let s:vundlehome = expand('~/.vim/bundle/Vundle.vim') " expand(...) also makes it OS specific
let s:bundledir = fnamemodify(s:vundlehome, ':h')
try
	"
	" NOTE:  I *want* to use shellescape() below for the path arguments, but since I need to run
	"        this on BOTH Windows & *nix/Mac -- I need to manually surround with double quotes.
	"
	"           * On Windows  shellescape() surrounds with double quotes
	"           * On *nix/mac shellescape() surrounds with single quotes
	"
	"        However, in both situations, this needs to work within:  exe "... system('... <here> ...') ..."
	"
    exe "silent call system('cd \"" . s:vundlehome . "\" && git checkout neb-dev')"
    call vundle#begin()		"" can pass in a path for alternate plugin location
catch /\vE117:|E282:/
    let s:bootstrap = 1
    if has('win32')
        exe "silent call system('mkdir \"" . s:bundledir . "\"')"
        exe "silent call system('set GIT_DIR= && git clone " . s:vundlerepo . " \"" . s:vundlehome . "\"')"
    else
        exe "silent call system('mkdir -p \"" . s:bundledir . "\"')"
        exe "silent call system('unset GIT_DIR && git clone " . s:vundlerepo . " \"" . s:vundlehome . "\"')"
    endif
    let s:ocwd = getcwd()
    try
        exe 'cd ' . s:vundlehome
        exe "call system('git checkout neb-dev')"
    finally
        exe 'cd ' . s:ocwd
    endtry
    redraw!
    call vundle#begin()
endtry
""   my fork of 'VundleVim/Vundle.vim'
Plugin 'nebbish/Vundle.vim', {'revision': 'neb-dev'} "" let Vundle manage Vundle, REQUIRED
""
"" Other plugins here...
""

"" YCM:  Completions and tool tips.
""  NOTE:  needs more work to be enabled - more installed, and more locally built dependencies :(
"Plugin 'ycm-core/YouCompleteMe'

"" Current Matchit options:
""   Original (I think):  https://github.com/chrisbra/matchit
""   The one I used to include here: https://github.com/geoffharcourt/vim-matchit
""   Enhanced:  https://github.com/andymass/vim-matchup
Plugin 'chrisbra/matchit'
"" Found through this question:  "how to convert html escape codes"
"" http://stackoverflow.com/questions/5733660/is-there-an-html-escape-paste-mode-for-vim
""   my fork of 'tpope/unimpaired'
Plugin 'nebbish/vim-unimpaired', {'revision': 'neb-dev'}
"" After discovering the above, I just poked around the other stuff by Tim Pope, and liked this too:
Plugin 'tpope/vim-eunuch'
"" Found this one at: https://github.com/tmhedberg/SimpylFold
"" It is about proper folding of PY code
Plugin 'tmhedberg/SimpylFold'
"" Found this one at: https://thoughtbot.com/blog/replacing-nerdtree-with-ctrl-p
Plugin 'ctrlpvim/ctrlp.vim'
"" Found this one here:
Plugin 'majutsushi/tagbar'
"" Co-worker pointed me towards this guy...
""   my fork of preservim/nerdtree
Plugin 'nebbish/nerdtree', {'revision': 'neb-dev'}
Plugin 'preservim/nerdcommenter'
"" Found this from:  https://ricostacruz.com/til/navigate-code-with-ctags
Plugin 'craigemery/vim-autotag'
"" Found this just by searching for something like it.   there are LOTS of forks that tweak it one way or another
""    my fork of 'masaakif/nerdtree-useful-plugins'
Plugin 'nebbish/nerdtree-useful-plugins', {'revision': 'neb-dev'}
"" Stumbled upon this while exploring peoples write-up comparison of CtrlP and CommandT
Plugin 'jlanzarotta/bufexplorer'
"" Here are some 'object types' that work with the noun/verb command structure :D
"" Found here:  https://blog.carbonfive.com/vim-text-objects-the-definitive-guide/
""      argument (a)       good for all languages
Plugin 'vim-scripts/argtextobj.vim'
""      indent level (i)   good for languages like Python (which rely on indent level)
Plugin 'michaeljsmith/vim-indent-object'
"" This is meant to work with `ag` which I just installed
if !has('win32')
    Plugin 'rking/ag.vim'
endif
"Plugin 'Chun-Yang/vim-action-ag'
"" Found while looking for an easy way to jump b/w decl & defn   -- not that easy, even with CTags & CtrlP
""Plugin 'LucHermitte/lh-tags'     I'm not sure if I want this one - but I did not want to forget knowing about it ;)
Plugin 'vim-airline/vim-airline'
"" Found on the web.  Amazing assistance for working with Git repositories
Plugin 'tpope/vim-fugitive'
"" Another one from tpope - that helps manage scripts (helps a developer of scripts)
Plugin 'tpope/vim-scriptease'
"" Another one from tpope - that helps launch sub-programs
Plugin 'tpope/vim-dispatch'
"" This was something I found looking for "vim as a merge tool"
Plugin 'sjl/splice.vim'
"" Here is another plugin for "generically" helping with conflict markers
"" (does not have any SCM specifics, just open a file with markers, and start it)
Plugin 'samoshkin/vim-mergetool'
"" I found this while searching around about Tmux mappings - and I'm gonna try it :)
""    Found here:  https://vimawesome.com/plugin/vim-tmux-navigator
""    Great writeup here:  https://gist.github.com/mislav/5189704
if has('macunix')
    "" Right now, I only use tmux on my MacOS dev box
    Plugin 'christoomey/vim-tmux-navigator'
endif
"" Stumbled across this while searching for something else...    but
"" considering my own VIM use case...   this is PERFECT for me :)  (if it works)
"Plugin 'unblevable/quick-scope'
"" Found this when I wanted to repeat my own mappings - surprised I didn't already have it
Plugin 'tpope/vim-repeat'
"" Not sure if I want this - but gonna grab it together with 'vim-repeat'
Plugin 'tpope/vim-surround'
"" Colors suggested by a good Vimcast: http://vimcasts.org/episodes/fugitive-vim-working-with-the-git-index/
Plugin 'lifepillar/vim-solarized8'
"" Found this while searching for a way to run the debugger from VIM.
""    For `gdb`, there is a built-in feature:  `termdebug`
"" However, I now use a Mac - so I want to run LLDB also :)
""   NOTE:  currently not working -- this VIM binary seg-faults when importing 'lldb'.
""          See: https://www.mail-archive.com/lldb-dev@lists.llvm.org/msg07787.html
""          also: https://reviews.llvm.org/D70252 update to docs to explain this
""   If I use /usr/bin/vim - (came with Catalina) it works.   grrrrrrrrrrrr
"Plugin 'gilligan/vim-lldb'
"" Here's something for comparing folders
""    my fork of 'will133/vim-dirdiff'
Plugin 'nebbish/vim-dirdiff', {'revision': 'neb-dev'}
"" Found this when searching for a good way to swap words
""     see:  https://vim.fandom.com/wiki/Swapping_characters,_words_and_lines
"" There are other options -- I am trying this one for now :)
Plugin 'kurkale6ka/vim-swap'
"" I wish I could make the built-in functionality meed the needs, but this
"" seems like a solid plugin -- if it all works
Plugin 'wesQ3/vim-windowswap'
"" I was looking for a way to pad lines to align a character in a column
"" This S.O. answer listed some options: https://superuser.com/a/771152/659417
"" I'm going with the vim-easy-align, because I like the inerface:
"" https://github.com/junegunn/vim-easy-align#tldr---one-minute-guide
Plugin 'junegunn/vim-easy-align'
Plugin 'godlygeek/tabular.git'
"" Found this looking for a way to transpose arond a comma, here:
""     https://stackoverflow.com/a/14741301/5844631
Plugin 'PeterRincker/vim-argumentative'
"" Found this when I learned that Gvim fonts are adjustable, handy for screensharing
Plugin 'drmikehenry/vim-fontsize'
"" More colorschemes, from:  https://vimcolorschemes.com/
Plugin 'morhetz/gruvbox'
Plugin 'arcticicestudio/nord-vim'
Plugin 'joshdick/onedark.vim'
"Plugin 'sainnhe/sonokai'
"Plugin 'kaicataldo/material.vim'
"Plugin 'sonph/onehalf'
"Plugin 'vigoux/oak'
Plugin 'cocopon/iceberg.vim'
Plugin 'rakr/vim-one'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'altercation/vim-colors-solarized'
Plugin 'sonph/onehalf', { 'rtp': 'vim' }
"" Found this when looking for better c++ highlighting
Plugin 'octol/vim-cpp-enhanced-highlight'
"" Found this when looking up help for "nroff" for the '[[' and ']]' commands
Plugin 'nebbish/jumpy.vim', {'revision': 'neb-dev'}
"" Found this when trying to fix ONE highlighting
Plugin 'coldfix/hexHighlight'
Plugin 'guns/xterm-color-table.vim'
"" I stumbled upon this handy page while searching for a built-in
"" way to treat the current line as if an :Ex command and run it
""   https://www.hillelwayne.com/post/intermediate-vim/
"" On that page of great advice, was this little gem of a plugin:
Plugin 'mbbill/undotree'
"" I discovered this when looking up ".editconfig" which is a CROSS-IDE config file!!
"" Apparently VS and IntelliJ, and Pycharm, and others all honor this tab-settings file
"" For VIM, though -- this plugin adds mappings for <tab> and <cr> to handle something
"" I'm calling "smart alignment", where tabs are used for the indent, but spaces are
"" used to align wrapped lines
"Plugin 'Thyrum/vim-stabs'   NOTE:   Disbaled b/c of the 'o' and 'O' mappings
"" Kotlin syntax
Plugin 'udalov/kotlin-vim'
"" Found these, trying to help use VIM for pure writing
Plugin 'junegunn/seoul256.vim'
Plugin 'junegunn/goyo.vim'
Plugin 'junegunn/limelight.vim'
"" This is "like" Boost for Vim -- what will be in the next version
"" (currently 2 years newer than what is on my MacOS, with changes I want)
Plugin 'tpope/vim-markdown'


call vundle#end()			"" required

if s:bootstrap
    silent PluginInstall
    quit
end

filetype plugin indent on	"" required (the 'indent' clause is fine absent or present)
"}}}


" Markdown-related mappings and settings "{{{
"" # "
"" # " These settings are from the built-in functionality
"" # " (either from the installed VIM, or tpope/vim-markdown)
"" # "

" If you want to enable fenced code block syntax highlighting in your markdown
" documents you can enable it in your `.vimrc` like so:
"let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']

" To disable markdown syntax concealing add the following to your vimrc:
"let g:markdown_syntax_conceal = 0
nnoremap <silent> <leader>om  <nop>
nnoremap <silent> <leader>oms :let g:markdown_syntax_conceal = 0<cr>
nnoremap <silent> <leader>zm  <nop>
nnoremap <silent> <leader>zms :let g:markdown_syntax_conceal = 1<cr>

" Syntax highlight is synchronized in 50 lines. It may cause collapsed
" highlighting at large fenced code block.
" In the case, please set larger value in your vimrc:
"let g:markdown_minlines = 100
nnoremap        <leader><leader>ml? :echo g:markdown_minlines<cr>
nnoremap <expr> <leader><leader>mll ':let g:markdown_minlines = ' . v:count . '<cr>'

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
python3
\ #
\ # TODO:  refactor this section to have common "arg" conversion helpers
\ #        and return value "cleaning" helpers (such as stripping the appended newline)
\ #
\ import binascii
\ def uudecode(encoded_ascii_value):
\     if encoded_ascii_value is bytes:
\         encoded_ascii_value = encoded_ascii_value.decode('utf-8')
\     return binascii.a2b_uu(encoded_ascii_value)
\ def uuencode(original_value):
\     if type(original_value) is str:
\         original_value = original_value.encode('utf-8')
\     return binascii.b2a_uu(original_value)
\ def base64decode(encoded_ascii_value):
\     if encoded_ascii_value is bytes:
\         encoded_ascii_value = encoded_ascii_value.decode('utf-8')
\     return binascii.a2b_base64(encoded_ascii_value)
\ def base64encode(original_value):
\     if type(original_value) is str:
\         original_value = original_value.encode('utf-8')
\     return binascii.b2a_base64(original_value)

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
    if ! exists('g:TidyColumn')
        let tidycol = winwidth(0)
    else
        let tidycol = g:TidyColumn
    endif

    let opts = '-q -i -w ' . l:tidycol . ' --break-before-br yes'
    " NOTE: this script-scoped variable is set to the value of `v:count` by `TransformMotionSetup` below
    if s:vcount == 1
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
    return system('jsontool', a:str)
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

nnoremap <expr> <leader>]u TransformMotionSetup('s:PyUuDecode')
xnoremap <expr> <leader>]u TransformMotionSetup('s:PyUuDecode')
nnoremap <expr> <leader>]uu TransformMotionSetup('s:PyUuDecode') . '_'
nnoremap <expr> <leader>[u TransformMotionSetup('s:PyUuEncode')
xnoremap <expr> <leader>[u TransformMotionSetup('s:PyUuEncode')
nnoremap <expr> <leader>[uu TransformMotionSetup('s:PyUuEncode') . '_'

nnoremap <expr> <leader>]p TransformMotionSetupD('s:PyBase64Decode')
xnoremap <expr> <leader>]p TransformMotionSetupD('s:PyBase64Decode')
nnoremap <expr> <leader>]pp TransformMotionSetupD('s:PyBase64Decode') . '_'
nnoremap <expr> <leader>[p TransformMotionSetupD('s:PyBase64Encode')
xnoremap <expr> <leader>[p TransformMotionSetupD('s:PyBase64Encode')
nnoremap <expr> <leader>[pp TransformMotionSetupD('s:PyBase64Encode') . '_'

nnoremap <expr> <leader>]b TransformMotionSetup('s:Base64Decode')
xnoremap <expr> <leader>]b TransformMotionSetup('s:Base64Decode')
nnoremap <expr> <leader>]bb TransformMotionSetup('s:Base64Decode') . '_'
nnoremap <expr> <leader>[b TransformMotionSetup('s:Base64Encode')
xnoremap <expr> <leader>[b TransformMotionSetup('s:Base64Encode')
nnoremap <expr> <leader>[bb TransformMotionSetup('s:Base64Encode') . '_'

nnoremap <expr> <leader>tx TransformMotionSetup('s:TidyXml')
xnoremap <expr> <leader>tx TransformMotionSetup('s:TidyXml')
nnoremap <expr> <leader>txx TransformMotionSetup('s:TidyXml') . '_'

nnoremap <expr> <leader>th TransformMotionSetup('s:TidyHtml')
xnoremap <expr> <leader>th TransformMotionSetup('s:TidyHtml')
nnoremap <expr> <leader>thh TransformMotionSetup('s:TidyHtml') . '_'

nnoremap <expr> <leader>tj TransformMotionSetup('s:TidyJson')
xnoremap <expr> <leader>tj TransformMotionSetup('s:TidyJson')
nnoremap <expr> <leader>tjj TransformMotionSetup('s:TidyJson') . '_'


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
let g:DirDiffIgnoreLineEndings=1
let g:DirDiffExcludes = "_.sw?,.*.sw?"
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

nnoremap        <leader>id        <nop>
nnoremap        <leader>idd       :Gdiffsplit<cr>
nnoremap        <leader>idv       :Gvdiffsplit<cr>
nnoremap        <leader>idh       :Ghdiffsplit<cr>
nnoremap <expr> <leader>id<space> ':Gdiffsplit '
nnoremap <expr> <leader>idp       ':<c-u>G diff origin/master...origin/pull/' . v:count . '<cr>'

""NOTE:  this is *OFTEN* not defined when I think it should be, so I'm adding my own mapping for it
nnoremap <leader>dq :<c-u>call fugitive#DiffClose()<cr>

nnoremap <leader>ig <nop>
nnoremap <expr> <leader>igl ':Glgrep! '
nnoremap <expr> <leader>igc ':Ggrep! '

nnoremap <leader>ib  <nop>
nnoremap <leader>ibl :G blame<cr>
nnoremap <leader>ibr :G branch --list -a<cr>

nnoremap <expr> <leader>if ':<c-u>G fetch ' . (v:count == '0' ? '' : (v:count == '1' ? '--all --prune' : '')) . '<cr>'
nnoremap <expr> <leader>iu ':<c-u>G push '  . (v:count == '0' ? '' : (v:count == '1' ? '--force' : (v:count == '2' ? '-u origin' : ''))) . '<cr>'
nnoremap <expr> <leader>ip ':<c-u>G pull '  . (v:count == '0' ? '--ff-only' : (v:count == '1' ? '--rebase' : '')) . '<cr>'

nnoremap        <leader>ic         <nop>
nnoremap        <leader>ica        :G commit --amend<cr>
nnoremap        <leader>icz        <nop>
nnoremap <expr> <leader>icz<space> ':G stash '
nnoremap        <leader>iczl       :G stash list<cr>
nnoremap        <leader>iczu       :G stash push -m current<cr>
nnoremap        <leader>iczg       :G stash push --staged -m current_staged<cr>
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
"" # nnoremap <leader>il <nop>
"" # nnoremap <leader>ilo :call GitDo('G hlog')<cr>
"" # nnoremap <leader>ila :call GitDo('G hlag')<cr>
"" # " These next two mappings will populate the "local" and "quickfix" lists respectively
"" # " NOTE: this involves an 'efm' within the Fugitive plugin that does NOT work with '--graph' or my '--pretty' formats
"" # "       (i.e.  if I add --graph, then the quickfix window does not find the commits to jump to)
"" # nnoremap <leader>ill :call GitDo('Gllog! --date=human --decorate -- ')<cr>
"" # nnoremap <leader>ilc :call GitDo('Gclog! --date=human --decorate -- ')<cr>

"" # nnoremap <leader>ilg <nop>
"" # nnoremap <leader>ilgl :call GitDo('Gllog! --date=human --decorate --all --grep ')<cr>
"" # nnoremap <leader>ilgc :call GitDo('Gclog! --date=human --decorate --all --grep ')<cr>
"" #

nnoremap <leader>il <nop>
nnoremap <expr> <leader>ilo (v:count == '0' ? ':<c-u>G hlog<cr>' : (v:count == '1' ? ':<c-u>vert G hlog<cr>' : ':<c-u>0G hlog<cr>'))
nnoremap <expr> <leader>ila (v:count == '0' ? ':<c-u>G hlag<cr>' : (v:count == '1' ? ':<c-u>vert G hlag<cr>' : ':<c-u>0G hlag<cr>'))
" These next two mappings will populate the "local" and "quickfix" lists respectively
" NOTE: this involves an 'efm' within the Fugitive plugin that does NOT work with '--graph' or my '--pretty' formats
"       (i.e.  if I add --graph, then the quickfix window does not find the commits to jump to)
nnoremap <leader>ill :Gllog! --date=human --decorate --
nnoremap <leader>ilc :Gclog! --date=human --decorate --

nnoremap        <leader>ilg  <nop>
nnoremap <expr> <leader>ilgl ':Gllog! --date=human --decorate --all --grep '
nnoremap <expr> <leader>ilgc ':Gclog! --date=human --decorate --all --grep '

nnoremap <leader>iw :Gwrite<cr>

"
" Mneumonic:    resolve merge
"
nnoremap <leader>rm  <nop>
nnoremap <leader>rmb gg/\v^[<=>]{4,}(\ [A-Z0-9a-z]{1,}\|$)<cr>zz
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
nnoremap <leader>fd     <nop>
nnoremap <leader>fdl    :FocusDispatch <c-r><c-l><cr>
nnoremap <leader>fdr    <nop>
nnoremap <leader>fdrl   :FocusDispatch <c-r>b <c-r><c-l><cr>

""
"" Next are mappings (& helper function) specifically for MSBuild
""
function! SetMSBuildDispatch(cmd)
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

    if v:count == 0
        let allargs = [a:cmd, l:mainargs, join(l:logargs)]
    elseif v:count == 1
        let allargs = [a:cmd, l:mainargs]
    else
        let allargs = [a:cmd]
    endif
    exe 'FocusDispatch ' . join(l:allargs) . ' ' . getline('.')
endfunc

nnoremap <leader>fdm    <nop>
nnoremap <leader>fdms   :<c-u>call SetMSBuildDispatch('msbuild')<cr>
nnoremap <leader>fd1    <nop>
nnoremap <leader>fd17   <nop>
nnoremap <leader>fd17b  :<c-u>call SetMSBuildDispatch('ms2017bt')<cr>
nnoremap <leader>fd17p  :<c-u>call SetMSBuildDispatch('ms2017pro')<cr>
nnoremap <leader>fd19   <nop>
nnoremap <leader>fd19b  :<c-u>call SetMSBuildDispatch('ms2019bt')<cr>
nnoremap <leader>fd19p  :<c-u>call SetMSBuildDispatch('ms2019pro')<cr>
nnoremap <leader>fdd    <nop>
nnoremap <leader>fddn   :<c-u>call SetMSBuildDispatch('dotnet publish')<cr>
nnoremap <leader>fd19d  <nop>
nnoremap <leader>fd19dn :<c-u>call SetMSBuildDispatch('dn2019bt publish')<cr>

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
function! SetGradleDispatch(...) abort range
    ""
    "" NOTE:  this adjusts the JAVA_HOME environment variable within VIM
    ""        generally when launching gradle, this is what I want.
    ""        this will only become trouble if I find myself interleaving my Gradle launching
    ""        with some other Java work for which I want a different JAVA_HOME
    ""
    if v:count == 0
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
    if !exists("l:gradleTool")
        "" # Try a wrapper in the current folder
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
nnoremap <leader>fdgr   :<c-u>call SetGradleDispatch('--no-daemon')<cr>
nnoremap <leader>fdgd   :<c-u>call SetGradleDispatch()<cr>

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
nnoremap <expr> <leader>fc ":<c-u>set foldcolumn=" . v:count . "<cr>"
nnoremap <leader>fl? :set foldlevel?<cr>
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
autocmd VimEnter * call NERDTreeAddKeyMap({
		\ 'key': 'yy',
		\ 'callback': 'NERDTreeYankCurrentNode',
		\ 'quickhelpText': 'put full path of current node into the default register' })

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
	let g:ctrlp_user_command = 'ag %s -u -l --depth 50 --nocolor -g ""'
	" When using 'ag' to search based on file names -- it is so fast CtrlP does not need to cache enything
	" (we'll see about that claim ;)
	"let g:ctrlp_use_caching = 0
endif
let g:ctrlp_show_hidden = 1

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
nnoremap <leader>tb :TagbarOpen fjc<cr>
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
"" The color scheme is NOT a plugin, and needs to be manually retrieved, using:
""
""     macro: 0wy$:"
""
""     "" For Linux
""     !mkdir ~/.vim/colors
""     cd ~/.vim/colors
""
""     "" For Windows
""     !mklink /d %VIMRUNTIME%\..\vimfiles %USERPROFILE%\.vim\vimfiles
""     !mkdir %USERPROFILE%\.vim\vimfiles\colors
""     cd %USERPROFILE%\.vim\vimfiles\colors

""     "" NOTE:  zenburn is ONLY dark
""     !wget https://raw.githubusercontent.com/jnurmine/Zenburn/master/colors/zenburn.vim
""     !wget https://raw.githubusercontent.com/vim-scripts/moria/master/colors/moria.vim

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
nnoremap <leader>lp  <Nop>
nnoremap <leader>lpb :colorscheme pablo<cr>
nnoremap <leader>lpc :colorscheme PaperColor<cr>
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

" NOTE:  activating "one" *before* "papercolor" sets the colors of the file
"        heading bar (which is otherwise ignored by papercolor)
if ! exists("s:colorscheme_default_has_been_set")
    let s:colorscheme_default_has_been_set = 1
    " NOTE:  I really use Papercolor almost everywhere   ... BUT ...
    "        that one does NOT properly handle the window status line
    "        SO I always find myself setting 'One' and then 'Papercolor'
    "        to get the status lines right.
    if has('macunix')
        "colorscheme solarized8_high
        colorscheme papercolor
        set background=dark
    elseif has('linux')
        colorscheme solarized8
        set background=dark
    else
        " Doing both one-right-after-the-other does NOT work here in VIMRC :(
        " (so I have commentd out the switch to papercolor)
            " colorscheme one
            " redrawstatus!
        colorscheme papercolor
        set background=light
    endif
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
function! Expand(flags)
    if a:flags == 'd'
        let retval = expand('%:p')->substitute('[\\/][^\\/]*$', '', '')
    elseif a:flags == 'l'
        let retval = expand('%')->resolve()
    elseif a:flags == 'g'
        let gitdir = trim(system('cd ' . Expand('d') . ' && git rev-parse --show-toplevel'))
        if len(l:gitdir) == 0
            return ''
        endif
        let retval = Expand('p')[len(l:gitdir) + 1:]
    elseif a:flags == '.'
        let retval = expand('%')->fnamemodify(':.')
    elseif a:flags == '~'
        let retval = expand('~')
    elseif a:flags == '4'
        let out = system('p4 where ' . shellescape(expand('%:p')))
        let retval = substitute(l:out, '\v^(//depot/.{-}) //.*', '\1', '')
    elseif a:flags == 'c'
        let retval = expand('~') . '/.conan/data'
    elseif a:flags == '%'
        let retval = getcwd()
    else
        let retval = expand('%:' . a:flags)
    endif
    let retval = substitute(l:retval, '\vfugitive:\\{3}', '', '')
    return l:retval
endfunction

"" NOTE:  this may not be working :(   (see ":help <expr>")
cnoremap <expr> %p  getcmdtype() =~ '[:=]' ? Expand('p')   : '%p'
cnoremap <expr> %d  getcmdtype() =~ '[:=]' ? Expand('d')   : '%d'
cnoremap <expr> %%  getcmdtype() =~ '[:=]' ? Expand('%')   : '%%'
cnoremap <expr> %f  getcmdtype() =~ '[:=]' ? Expand('t')   : '%f'
cnoremap <expr> %t  getcmdtype() =~ '[:=]' ? Expand('t:r') : '%t'
cnoremap <expr> %r  getcmdtype() =~ '[:=]' ? Expand('r')   : '%r'
cnoremap <expr> %h  getcmdtype() =~ '[:=]' ? Expand('h')   : '%h'
cnoremap <expr> %e  getcmdtype() =~ '[:=]' ? Expand('e')   : '%e'
cnoremap <expr> %l  getcmdtype() =~ '[:=]' ? Expand('l')   : '%l'
cnoremap <expr> %g  getcmdtype() =~ '[:=]' ? Expand('g')   : '%g'
cnoremap <expr> %.  getcmdtype() =~ '[:=]' ? Expand('.')   : '%.'
cnoremap <expr> %c  getcmdtype() =~ '[:=]' ? Expand('c')   : '%c'
cnoremap <expr> %~  getcmdtype() =~ '[:=]' ? Expand('~')   : '%~'
cnoremap <expr> %4  getcmdtype() =~ '[:=]' ? Expand('4')   : '%4'
cnoremap <expr> %z  getcmdtype()

inoremap <expr> <c-d>  <nop>
inoremap <expr> <c-d>. Expand('.')
inoremap <expr> <c-d>% Expand('%')
inoremap <expr> <c-d>~ Expand('~')
inoremap <expr> <c-d>c Expand('c')

nnoremap <leader>gf  <nop>
nnoremap <leader>gfp :let @"='<c-r>=Expand('p')<cr>'<bar>let @+=@"<cr>
nnoremap <leader>gfd :let @"='<c-r>=Expand('d')<cr>'<bar>let @+=@"<cr>
nnoremap <leader>gf% :let @"='<c-r>=Expand('%')<cr>'<bar>let @+=@"<cr>
nnoremap <leader>gff :let @"='<c-r>=Expand('t')<cr>'<bar>let @+=@"<cr>
nnoremap <leader>gft :let @"='<c-r>=Expand('t:r')<cr>'<bar>let @+=@"<cr>
nnoremap <leader>gfr :let @"='<c-r>=Expand('r')<cr>'<bar>let @+=@"<cr>
nnoremap <leader>gfh :let @"='<c-r>=Expand('h')<cr>'<bar>let @+=@"<cr>
nnoremap <leader>gfe :let @"='<c-r>=Expand('e')<cr>'<bar>let @+=@"<cr>
nnoremap <leader>gfl :let @"='<c-r>=Expand('l')<cr>'<bar>let @+=@"<cr>
nnoremap <leader>gfg :let @"='<c-r>=Expand('g')<cr>'<bar>let @+=@"<cr>
nnoremap <leader>gf. :let @"='<c-r>=Expand('.')<cr>'<bar>let @+=@"<cr>
nnoremap <leader>gf4 :let @"='<c-r>=Expand('4')<cr>'<bar>let @+=@"<cr>


cnoremap <expr> <c-o>a  getcwd().'_build-logs\msbuild-diagnostic.log'
cnoremap <expr> <c-o>e  getcwd().'_build-logs\msbuild-detailed.log'
cnoremap <expr> <c-o>n  getcwd().'_build-logs\msbuild-normal.log'
cnoremap <expr> <c-o>m  getcwd().'_build-logs\msbuild-minimal.log'

function! OutputLog(expr)
    let l:log = glob('.\Output\Logs\en-us**\' . a:expr)
    if l:log == ''
        let l:log = glob('.\Windows**\' . a:expr)
    endif
    if l:log == ''
        throw 'Unable to find output build log for [' . a:expr .']'
    endif
    return l:log
endfunction
cnoremap <expr> <c-o>r  OutputLog('*Reporting*.txt')
cnoremap <expr> <c-o>o  OutputLog('*OldServer*.txt')
cnoremap <expr> <c-o>b  OutputLog('*Bootstrap*.txt')
cnoremap <expr> <c-o>w  OutputLog('*NewServer.txt')
cnoremap <expr> <c-o>c  OutputLog('*Cpp*.txt')
cnoremap <expr> <c-o>8  OutputLog('*-msbuild-x86-Release.log')
cnoremap <expr> <c-o>6  OutputLog('*-msbuild-x86_64-Release.log')

""
"" Handy mapping that I should have created LOOOOng ago.
""    (though really, all of my Ex-mode '<c-o>...' mappings are new)
""
cnoremap <expr> <c-o>v  VisualSelection()


"" mapping to set the current directory from a specific buffer's file path
""  w/o a count: uses the current buffer's path
"" with a count: uses the path of that buffer
"nnoremap <expr> <leader>cd ":<c-u>cd <c-r>=expand('" . (v:count == '0' ? '%' : '#' . v:count) . ":p:h')<cr><cr>"
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
        execute '%s/\v(\r|\^M)+$//'
        execute '%s/\v\r(\n)@!/\r/g'
    catch /\vE486:/
        echo "No carraige returns found :)"
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

if executable('vim-clang-format.py')
    "dir /b /s /a-d "C:\Program Files (x86)\Microsoft Visual Studio\clang*.exe"
    let g:clang_format_path = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\Llvm\bin\clang-format.exe'
    let g:clang_format_style = 'file'
    let g:clang_format_fallback_style = 'llvm'
    noremap <leader><leader>k :pyf <c-r>=trim(system('where vim-clang-format.py'))<cr><cr>
    inoremap <c-k> <c-o>:pyf <c-r>=trim(system('where vim-clang-format.py'))<cr><cr>
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

""
"" disabling this so the new open/close mappings become more familiar
""   \oq   (to open quickfix)
""   \zq   (to close quickfix)
""
"nnoremap <leader>qo :copen<cr>
"nnoremap <leader>qc :cclose<cr>
"nnoremap <leader>ql :cclose<cr>

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

vnoremap <expr> <leader>fs ':<c-u>% g/\v' . VimRxEscape(VisualSelection()) . '/d<cr>:PopSearch<cr><c-o>'
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

function! OpenCompanionCode() range abort
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

    if v:count == 0
        exe 'e ' . l:new
    elseif v:count == 1
        exe 'vs ' . l:new
    else
        exe 'sp ' . l:new
    endif
endfunction

" Opening & Closing mappings (utility windows and gui elements) "{{{
nnoremap <silent> <leader>o    <nop>
nnoremap <silent> <leader>oc   :<c-u>call OpenCompanionCode()<cr>

if has('win32')
    nnoremap <silent> <leader>of   <nop>
    nnoremap <silent> <leader>ofd  <nop>
    nnoremap <silent> <leader>ofdt :!start <c-r>=substitute(system('echo %USERPROFILE%'), '\v[\s\n\r]+$', '', '')<cr>\Desktop<cr>
    nnoremap <silent> <leader>oft  <nop>
    nnoremap <silent> <leader>oftp :!start <c-r>=substitute(system('echo %TEMP%'), '\v[\s\n\r]+$', '', '')<cr><cr>
    nnoremap <silent> <leader>ofu  <nop>
    nnoremap <silent> <leader>ofup :!start <c-r>=substitute(system('echo %USERPROFILE%'), '\v[\s\n\r]+$', '', '')<cr><cr>
endif

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

nnoremap <silent> <leader>zg  <nop>
nnoremap <silent> <leader>zgm :set guioptions-=m<cr>
nnoremap <silent> <leader>zgs :set guioptions-=rL<cr>
nnoremap <silent> <leader>zga :set guioptions-=e<cr>

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
nnoremap <expr> <leader>xa<space> ':argdo '
nnoremap <expr> <leader>xb<space> ':bufdo '
nnoremap <expr> <leader>xt<space> ':tabdo '
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
function! EqualizeWindows()
    for bid in tabpagebuflist()
        let bopts = getbufvar(l:bid, '&')
        let wopts = getwinvar(bufwinnr(l:bid), '&')

        " For "normal" editor windows with swap files that are listed -- reset their "winfix" options
        if l:bopts['buftype'] == '' && l:bopts['buflisted'] == 1 && l:bopts['swapfile'] == 1  && (l:wopts['winfixheight'] == 1 || l:wopts['winfixwidth'] == 1)
            echo "Resetting 'winfix...' options for " . bufname(l:bid)
            call setwinvar(bufwinnr(l:bid), '&winfixheight', 0)
            call setwinvar(bufwinnr(l:bid), '&winfixwidth', 0)
        endif
    endfor
    wincmd =
endfunction
nnoremap <leader>ww <cmd>call EchoWindowInfo(v:count)<cr>
nnoremap <leader>we <cmd>call EqualizeWindows()<cr>
nnoremap <leader>ws :call WindowSwap#EasyWindowSwap()<CR>

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
nnoremap <leader>wx :call SetGuiSize(1000, 1000)<cr>
" This is the size that corresponds with my laptop monitor size (think of 'n' for 'normal')
nnoremap <leader>wn :call SetGuiSize(93, 293)<cr>
nnoremap <leader>wm :call SetGuiSize(40, 134)<cr>
nnoremap <leader>wt :call SetGuiSize(100, 134)<cr>
nnoremap <leader>wq :call SetGuiSize(80, 272)<cr>
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


""
"" These mappings are helpful for perforce
""
nnoremap <leader>pe :!p4 edit "<c-r>=expand("%:p")<cr>"<cr>
nnoremap <leader>pd :b#<cr>:!p4 delete "<c-r>=expand("#:p")<cr>"<cr>
nnoremap <leader>pa :!p4 add "<c-r>=expand("%:p")<cr>"<cr>
nnoremap <leader>pr :!p4 revert "<c-r>=expand("%:p")<cr>"<cr>
nnoremap <expr> <leader>pb ':<c-u>1 Redir !p4 annotate -I -c ' . ( v:count==1 ? '-a ' : '' ) . '-u -T <c-r>=shellescape(expand("%:p"))<cr><cr>'

nnoremap <leader>pf :!p4 diff "<c-r>=expand("%:p")<cr>"<cr>
nnoremap <leader>pv :!start /min cmd /c "set P4DIFF=<c-r>=expand("~")<cr>\bin\simple-vimdiff.bat&& p4 diff ^"<c-r>=expand("%:p")<cr>^""<cr>


function! BackupCL(cl, name)
    call system('cl-save ' . a:cl . ' "' . a:name . '"')
    call system('cl-undo "' . a:name . '"')
endfunction


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

        "errorformat+=%[0-9:.]%#\ %#%[0-9>:]%#%f(%l):\ %m
        "errorformat+=%[0-9:.]%#\ %#%[0-9>:]%#%f(%l\\\,%c):\ %m
        "errorformat+=%f:%l:\ %m<cr>

nmap <leader>mg    <nop>
nmap <leader>mgb   :cgetb<cr>
nmap <leader>mgm   <nop>
nmap <leader>mgms  <nop>
nmap <leader>mgmsa :cget <c-r>=getcwd()<cr>_build-logs\msbuild-diagnostic.log<cr>
nmap <leader>mgmse :cget <c-r>=getcwd()<cr>_build-logs\msbuild-detailed.log<cr>
nmap <leader>mgmsn :cget <c-r>=getcwd()<cr>_build-logs\msbuild-normal.log<cr>
nmap <leader>mgmsm :cget <c-r>=getcwd()<cr>_build-logs\msbuild-minimal.log<cr>

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

