"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" FIRST:  here are some commands to help 'debug' option settings and where
""         they may have been 'set'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :scriptnames			shows a list of scripts that have been loaded (& from where)
" :verbose 'option'?	to find the current value, and from where it was set
"
" For more see:  http://vim.wikia.com/wiki/Debug_unexpected_option_settings


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" These options come from a nice 'Coming home to Vim' article on the web here,
""		http://stevelosh.com/blog/2010/09/coming-home-to-vim/
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" few lines that should absolutely be here "{{{
""
"" NOTE:  the 'nocompatible' option automatically adjusts many other options
""        do it first, and only this once
""
set nocompatible	" defaults to off, but good to have
set modelines=0		" for security and safety
" "}}}

" general settings that 'just make things better' "{{{
set encoding=utf-8
set sidescroll=1
" set scrolloff=3	" when cursor is at top/bot of screen, keep X lines visable
" set showmode		" on by default anyway
set showcmd			" display (bottom right) the cmd characters typed so far
" set visualbell	" turn the beeps into flashes
" set cursorline
set ttyfast			" smoother redrawing when terminal connection is fast
" set ruler			" on already
set laststatus=2	" show status line ('2' == always)
set relativenumber	" display relative line numbers (new in 7.3)
set number			" display the absolute line number on the current line only
"set breakindent
"set breakindentopt=sbr
"set showbreak=⤹→\ 
set showbreak=⤹\ 
"set undofile		" create .<filename>.un~ files persist undo chains
" "}}}

let mapleader = "\\"

" tame searching/moving settings "{{{
nnoremap / /\v
vnoremap / /\v
set ignorecase		" use case insensitive searching by default
set smartcase		" however, if a capital letter was entered, go back to case SENSitive
set incsearch		" when typing a search ('/') starts finding/highlighting right away
set showmatch		" briefly highlight the matching 'bracket' (i.e. '[]','()','{}',...)
set hlsearch		" highlight the search results (use :nohl to clear highlights)
nnoremap <leader><space> :nohl<cr>
"" This first 'simple' mapping just performs a ':s' command to delete trailing whitespace
""nnoremap <leader>tr :%s/[ \t]\+$//<cr>
"" This second version does the same thing but preserves the search history
nnoremap <leader>tr :let b:old = @/<bar>%s/[ \t]\+$//<bar>call histdel('/',-1)<bar>let @/ = b:old<cr>
nnoremap <leader>tu :e ++ff=unix<cr>
nnoremap <leader>tm :%s/<C-V><cr>$//<cr>
""
"" This third version was my inspiration, from http://stackoverflow.com/a/21087108/5844631
"" However, I am not sure why there is a '<cr>==' in the middle.  I am not sure what that does
""
""nnoremap <leader>tr :let b:old = @/<bar>%s/[ \t]\+$//<cr>==:nohls<bar>call histdel('/',-1)<bar>let @/ = b:old<cr>
" "}}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" These options have been with me for a while - not sure where they came from
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" my own setup, been around from the beginning "{{{
""
"" Basic options that should always be set
""
set hidden			"" keeps buffers alive when the window/tab closes
set path=.,,**,~/**,~/bin,/usr/include
set history=5000
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
""set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
"}}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" These options are new for me 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE: this only helps when '.vimrc' is re-sourced after loading a file that has
"       autoformating options.  (b/c of the filetype option below)
set formatoptions-=tc	" without this, wrapping is automatic for certain file types
nnoremap <leader>nw :set formatoptions-=tc<cr>

" mappings for helping with 'diff' mode "{{{
nnoremap <leader>do :diffoff<cr>
nnoremap <leader>dt :diffthis<cr>
nnoremap <leader>du :diffupdate<cr>
" This is here to manually re-run the commands that I have in my p4vimdiff.sh script
"nnoremap <leader>ds :colorscheme evening<bar>set diffopt+=iwhite<bar>set lines=60<bar>set columns=235<bar>wincmd =<bar>normal gg]c<cr>
nnoremap <leader>ds :colorscheme evening<bar>set lines=60<bar>set columns=235<bar>wincmd =<bar>normal gg]c<cr>
nnoremap <leader>di :set diffopt+=iwhite<cr>
" "}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" These options are related to C/C++ source editing
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings for helping with C/C++ source editing "{{{
" These are for indenting/unindenting/formating blocks of code
nmap <leader>bi /\{<cr>j0mskn%k0me's0<c-v>'e0I	\tr's0kk
nmap <leader>bu /\{<cr>j0mskn%k0me's0<c-v>'e0x's0kk
nmap <leader>bf 0ms/\{<cr>%me's!'eclang-format<cr>
" "}}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" This is for 'pathogen' (which manages plugins) and comes from advice here:
""	http://stevelosh.com/blog/2010/09/coming-home-to-vim/
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pathogen section (DISABLED) "{{{
""
""	DISABLED in favor of "Vundle" just below
""
"" filetype off
"" call pathogen#runtime_append_all_bundels()
"" filetype plugin indent on
""
" "}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" This is for Vundle,  hosted on github here:  https://github.com/VundleVim/Vundle.vim
"" Vundle is a 'plugin manager' (but really a 'runtimepath' manager) that helps with
"" vim plugins:  installing/uninstalling/updating/...
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vundle section "{{{
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
filetype off			"" required for Vundle to load, will be renabled below

set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()		"" can pass in a path for alternate plugin location

Plugin 'VundleVim/Vundle.vim'	"" let Vundle manage Vundle, REQUIRED
"" Other plugins here...
Bundle 'geoffharcourt/vim-matchit'
"" Found through this question:  "how to convert html escape codes"
""    http://stackoverflow.com/questions/5733660/is-there-an-html-escape-paste-mode-for-vim
Bundle 'tpope/vim-unimpaired'
"" After discovering the above, I just poked around the other stuff by Tim Pope, and liked this too:
Bundle 'tpope/vim-eunuch'
"" Found this one at: https://github.com/tmhedberg/SimpylFold
"" It is about proper folding of PY code
"" NOTE:  the instructions say to use the 'Plugin' directive, but I am trying the 'Bundle' directive
Bundle 'tmhedberg/SimpylFold'

call vundle#end()			"" required
filetype plugin indent on	"" required (the 'indent' clause is fine absent or present)
" "}}}



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" These settings came from /usr/share/vim/vim74/vimrc_example.vim
"" (i.e. the example vimrc that installs with Vim)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Good stuff from the example that ships with Vim ""{{{
""
"" Don't use Ex mode, use Q for formatting
""
"noremap Q gq
""
"" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
"" so that you can undo CTRL-U after inserting a line break.
""	see:  ":help i_CTRL-G_u"
inoremap <c-u> <c-g>u<c-u>
"" The following is from:  http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U
inoremap <c-w> <c-g>u<c-w>
""
"" Convenient command to see the difference between the current buffer and the
"" file it was loaded from, thus the changes you made.
"" Only define it when not defined already.
""
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif
"}}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" The following options came from:  https://github.com/nickaigi/config/blob/master/.vimrc#L12
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" options borrowed from nickaigi's github "{{{
set ttimeoutlen=50			" solves the delay after pressing Esc (default is 1000ms)
set splitbelow
set splitright
set wildmode=longest,list	" what <tab> displays (or does) default was 'full'
"set vb t_vb=				" turn off the beeps AND the flashes
""
"" Mappings to traverse buffer list
""	Not sure if '<silent>' is helpful here, I do not quite understand it.
""	However, see ":help map-silent" for more help on what it does.
""
"" See ":help [" for what the bracket characters normally do
""
nnoremap <leader>bb :b#<CR>
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>
"" This is a way to delete the buffer but not the window
command! Bd bp<bar>bd#		"" close the current buffer, but not the window
nnoremap <leader>bd :bp<bar>bd#<cr>

nnoremap <leader>te :tabedit 
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>tc :tabclose<cr>
nnoremap <silent> [t :tabprevious<CR>
nnoremap <silent> ]t :tabnext<CR>
nnoremap <silent> [T :tabfirst<CR>
nnoremap <silent> ]T :tablast<CR>
""
""Easy expansion of the active file directory	(see ":help <expr>")
""
cnoremap <expr> %%  getcmdtype() == ':' ? expand('%:h').'/' : '%%'
""
"" Shortcut for :nohl	(normally <c-l> is:  Clear and redraw the screen.)
""
nnoremap <silent> <c-l> :<c-u>nohlsearch<CR><c-l>
""
"" Save a file that requires root permissions (see ":help :w_c" and ":help c_%")
""
cnoremap w!! w !sudo tee >/dev/null %
" "}}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" The following options came from:  https://github.com/gmarik/vimfiles/blob/1f4f26d42f54443f1158e0009746a56b9a28b053/vimrc#L136
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" options borrowed from gmarik's github "{{{
"" NOTE:  gmarik uses F10 for this, but I have not disabled F10 in gnome
set pastetoggle=<c-p>	" easy toggle of paste mode
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

function! DiffStatus()
	if &l:diff == 1 | return '[diff]' | else | return '' | endif
endfunction

set statusline=%<%f\          " custom statusline
set stl+=[%{&ff}]             " show fileformat
set stl+=%{DiffStatus()}
set stl+=%y%m%r%=
set stl+=%-14.(%l,%c%V%)\ %P

set foldenable			" turn folding on
set foldmethod=marker	" fold on the marker
""set foldmethod=syntax	" fold based on syntax
set foldlevel=100		" don't autofold anything (but I can still fold manually)

nnoremap <leader>fm :set foldmethod=marker<cr>
nnoremap <leader>fs :set foldmethod=syntax<cr>
nnoremap <leader>fe :set foldmethod=expr<cr>
nnoremap <leader>fd :set foldmethod=diff<cr>
nnoremap <leader>fi :set foldmethod=indent<cr>

nnoremap <leader>mr :!chmod -w %<cr>
nnoremap <leader>mw :!chmod +w %<cr>


set foldopen=block,hor,tag    " what movements open folds
set foldopen+=percent,mark
set foldopen+=quickfix

"" This is an attempt to create an inverse of the 'J' command (split)
"nnoremap <c-j> gEa<cr><esc>ew		" join with <ctrl>+j

" Make Control-direction switch between windows (like C-W h, etc)
nmap <silent> <c-k> <c-w><c-k>
nmap <silent> <c-j> <c-w><c-j>
nmap <silent> <c-h> <c-w><c-h>
nmap <silent> <c-l> <c-w><c-l>
" "}}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Key mappings and custom commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" HOW to use 'ALT' key mappings "{{{
"" Setting up mappings using the alt key is tricky.  The short story is to use
""			sed -n l
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
""  <s+f4>     : ^[[1;2S            : <esc>[1;2S
""
"" see:  http://stackoverflow.com/questions/7501092/can-i-map-alt-key-in-vim
"" and:  http://stackoverflow.com/questions/5379837/is-it-possible-to-mapping-alt-hjkl-in-insert-mode
"" 
"}}}
" Key mappings themselves "{{{
""
"" These are helpful while processing the "quickfix" window
""
""	NOTE:	I had trouble with these mappings always always always beeping
""			This was fixed by removing the trailing comment from the line that defined the mapping
""			The following URL explains a couple of reasons why a mapping may beep, and the solutions...
""				http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_%28Part_2%29
""
""
"" F4		moves to next error in the quickfix window
"" Shift+F4	moves to previous (again used 'sed -n l' to get codes)
""
nnoremap <f4> :cn<cr>
nnoremap <esc>[1;2S :cp<cr>
"nnoremap <c-j> :cn<cr>
"nnoremap <c-k> :cp<cr>

"" word wrap on <ctrl>+a (see :help :_!)
""nnoremap <c-a> :set wrap!<cr>
nnoremap <leader>w :set wrap!<cr>

""nnoremap <esc>[6;5~ ]c
""nnoremap <esc>[5;5~ [c

""
"" These sweet mappings move lines up and down with alt+up and alt+down
"" HOWEVER there is a bug when trying to move down multiple lines!
""         (multiple lines work when moving up, though not elegantly)
""
""	<alt>+<down>
"nnoremap <esc>[1;3B :m .+1<CR>==
""	<alt>+<up>
"nnoremap <esc>[1;3A :m .-2<CR>==
nnoremap <esc>[1;3B :m .+1<cr>
nnoremap <esc>[1;3A :m .-2<cr>
nnoremap <leader>j :m .+1<cr>
nnoremap <leader>k :m .-2<cr>

nnoremap <expr> <c-pageup>   &diff ? '[czz' : ':tabprev<cr>'
nnoremap <expr> <c-pagedown> &diff ? ']czz' : ':tabnext<cr>'

""
"" These mappings correspond to the same Eclipse shortcuts for folding code
""
nnoremap <c-kmultiply> zR
nnoremap <c-kdivide> zM
nnoremap <c-kplus> zo
nnoremap <c-kminus> zc
"}}}


""
"" These mappings are helpful for perforce
""
nnoremap <leader>pe :!p4 edit %<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" This entire section is a breakdown of the default 'errorformat' value, with
"" an update to many of the individual expressions.  The update is to OPTIONALLY
"" match '[cc]' text at the start of the build output lines.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" errorformat section "{{{
""	The Vim expression:	\%( *[cc] \)\?
""		\%(...\)	: a grouping
""		\?		: zero or one of the preceding
""
""	Same, in errorformt:	%\\%%(\ %#[cc]\ %\\)%\\?
""
""	Additionally, this is a zero-width match for '/home':
""							%\\%%(/home%\\)%\\@=
""
set efm=
set efm+=%*[^\"]\"%f\"%*\\D%l:\ %m
set efm+=\"%f\"%*\\D%l:\ %m
set efm+=%+G%\\%%(\ %#[cc]\ %\\)%\\?%f:%l:\ (Each\ undeclared\ identifier\ is\ reported\ only\ once
set efm+=%+G%\\%%(\ %#[cc]\ %\\)%\\?%f:%l:\ for\ each\ function\ it\ appears\ in.)
set efm+=%+G%\\%%(\ %#[cc]\ %\\)%\\?In\ file\ included\ from\ %f:%l:%c:
set efm+=%+G%\\%%(\ %#[cc]\ %\\)%\\?In\ file\ included\ from\ %f:%l:%c\\,
set efm+=%+G%\\%%(\ %#[cc]\ %\\)%\\?In\ file\ included\ from\ %f:%l:%c
set efm+=%+G%\\%%(\ %#[cc]\ %\\)%\\?In\ file\ included\ from\ %f:%l
set efm+=%+G%\\%%(\ %#[cc]\ %\\)%\\?%*[\ ]from\ %f:%l:%c
set efm+=%+G%\\%%(\ %#[cc]\ %\\)%\\?%*[\ ]from\ %f:%l:
set efm+=%+G%\\%%(\ %#[cc]\ %\\)%\\?%*[\ ]from\ %f:%l\\,
set efm+=%+G%\\%%(\ %#[cc]\ %\\)%\\?%*[\ ]from\ %f:%l
"" These pick up the output from executing Boost unit tests
set efm+=%-G%*[^\[][exec]\ unknown\ location%m
set efm+=%*[^\[][exec]\ %f(%l):%\\%%(\ last\ checkpoint%\\)%\\@=%m
set efm+=%*[^\[][exec]\ %f(%l):\ %m
set efm+=%*[^\[][exec]\ %*[^/\\:]:\ %f:%l:%m
"" These pick up the actual compile errors from the ANT output
"" NOTE:  they are extremely flexible, so I've added the zero-width '/home' match)
set efm+=%\\%%(\ %#[cc]\ %\\)%\\?%\\%%(/%\\)%\\@=%f:%l:%c:%m
set efm+=%\\%%(\ %#[cc]\ %\\)%\\?%\\%%(/%\\)%\\@=%f(%l):%m
set efm+=%\\%%(\ %#[cc]\ %\\)%\\?%\\%%(/%\\)%\\@=%f:%l:%m
set efm+=\"%f\"\\,\ line\ %l%*\\D%c%*[^\ ]\ %m
set efm+=%D%*\\a[%*\\d]:\ Entering\ directory\ %*[`']%f'
set efm+=%X%*\\a[%*\\d]:\ Leaving\ directory\ %*[`']%f'
set efm+=%D%*\\a:\ Entering\ directory\ %*[`']%f'
set efm+=%X%*\\a:\ Leaving\ directory\ %*[`']%f'
set efm+=%DMaking\ %*\\a\ in\ %f,%f\|%l\|\ %m
" "}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" This section is about making my BASH shell aliases available to '!' commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" NOTE:  see the docs for "Bash Startup Files" - bash looks for this env
""        whenever a shell is launched NON-interactively (which vim does ;)
let $BASH_ENV = "~/.bashrc_for_vim"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" This bit of magic will force this file to reload every time it is saved
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup myvimrc
    au!
	""  NOTE:  currently I don't have a ".gvimrc file, so I have commented that part out
    ""au bufwritepost $MYVIMRC,$MYGVIMRC so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
    au bufwritepost $MYVIMRC so $MYVIMRC
augroup end

