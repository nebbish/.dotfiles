"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" FIRST:  here are some commands to help 'debug' option settings and where
""         they may have been 'set'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :scriptnames			shows a list of scripts that have been loaded (& from where)
" :verbose 'option'?	to find the current value, and from where it was set
"
" For more see:  http://vim.wikia.com/wiki/Debug_unexpected_option_settings


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Here is the LEADER setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = "\\"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" These options come from a nice 'Coming home to Vim' article on the web here,
""		http://stevelosh.com/blog/2010/09/coming-home-to-vim/
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Settings that should be right at the top "{{{
""
"" NOTE:  the 'nocompatible' option automatically adjusts many other options
""        do it first, and only this once
""
set nocompatible		" defaults to off, but good to have
set modelines=0			" for security and safety
" NOTE:  this will affect the behavior of the "unnamed" register and which
"        actual REGister gets the stuff that goes into the "unnamed" register
"  Deciding to disable this - I think I got used to the VIM default register NOT being the OS clipboard
"  AND instead...   only choosing when to interact with the clipboard
"set clipboard=unnamed	" Use the OS clipboard by default (on versions compiled with `+clipboard`)
" "}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" This section is about making my BASH shell aliases available to '!' commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings & settings related to :! and :shell "{{{
"" NOTE:  see the docs for "Bash Startup Files" - bash looks for this env
""        whenever a shell is launched NON-interactively (which vim does ;)
let $BASH_ENV = "~/.bashrc_for_vim"
set shellcmdflag=-l\ -c
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

set encoding=utf-8
set sidescroll=1
" set scrolloff=3	" when cursor is at top/bot of screen, keep X lines visable
" set showmode		" on by default anyway
set showcmd			" display (bottom right) the cmd characters typed so far
" set visualbell	" turn the beeps into flashes
set ttyfast			" smoother redrawing when terminal connection is fast
" set ruler			" on already
set laststatus=2	" show status line ('2' == always)

set relativenumber	" display relative line numbers (new in 7.3)
set number			" display the absolute line number on the current line only
function! ToggleBoolOption(val)
	if eval('&'.a:val)
		execute 'set no'.a:val
	else
		execute 'set '.a:val
	endif
endfunction
nnoremap <leader>tn :call ToggleBoolOption('nu')<bar>call ToggleBoolOption('rnu')<cr>
nnoremap <leader>trn :call ToggleBoolOption('rnu')<cr>
nnoremap <leader>tnu :call ToggleBoolOption('nu')<cr>
nnoremap <leader>tw :set wrap!<cr>
augroup helpnumbers
	au!
	au FIleType help setlocal number | setlocal relativenumber
augroup END

" NOTE:  the listchars settings are in the section borrowed from 'gmarik'
"set breakindent
"set breakindentopt=sbr
"set showbreak=⤹→\ 
set showbreak=⤹\ 
"set undofile		" create .<filename>.un~ files persist undo chains

"" This is an attempt to create an inverse of the 'J' command (split)
"nnoremap <c-j> gEa<cr><esc>ew		" join with <ctrl>+j

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" The following options came from:  https://github.com/gmarik/vimfiles/blob/1f4f26d42f54443f1158e0009746a56b9a28b053/vimrc#L136
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" I did this a loooong time aga - i'm not even exactly sure where the parts I took from gmarik's repo conclude...
" Anyhow, here is the URL for reference;  https://github.com/gmarik/dotfiles/blob/master/.vim/vimrc
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
nnoremap <leader>gm :call GetSpecifiedInfo("map", 0)<cr>
nnoremap <leader>gc :call GetSpecifiedInfo("command", 0)<cr>
nnoremap <leader>ga :call GetSpecifiedInfo("autocmd", 0)<cr>
nnoremap <leader>gh :call GetSpecifiedInfo("highlight", 0)<cr>
nnoremap <leader>gs :call GetSpecifiedInfo("scriptnames", 0)<cr>

nnoremap <leader>gvm :call GetSpecifiedInfo("map", 1)<cr>
nnoremap <leader>gvc :call GetSpecifiedInfo("command", 1)<cr>
nnoremap <leader>gva :call GetSpecifiedInfo("autocmd", 1)<cr>
nnoremap <leader>gvh :call GetSpecifiedInfo("highlight", 1)<cr>
nnoremap <leader>gvs :call GetSpecifiedInfo("scriptnames", 1)<cr>
function! GetSpecifiedInfo(cmd, verbose)
	redir @"
	if a:verbose
		execute "verbose silent " . a:cmd
	else
		execute "silent " . a:cmd
	endif
	redir END
	new
	put! \"
endfunc
"}}}


" tame searching/moving settings "{{{
nnoremap / /\v
vnoremap / /\v
set ignorecase		" use case insensitive searching by default
set smartcase		" however, if a capital letter was entered, go back to case SENSitive
set incsearch		" when typing a search ('/') starts finding/highlighting right away
set showmatch		" briefly highlight the matching 'bracket' (i.e. '[]','()','{}',...)
set hlsearch		" highlight the search results (use :nohl to clear highlights)
nnoremap <leader><space> :nohl<cr>
nnoremap <leader>rr :redraw!<cr>
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
"" This is new after I started using this file with MacVIM on my new Macbook
"" Perhaps this is just from a newer version of VIM behind it all
""    see:  https://github.com/vim/vim/issues/989
let g:python_recommended_style=0

" https://aonemd.github.io/blog/finding-things-in-vim

"" NOTE:  I just found a TREASURE of a S.O. answer regarding some GREAT searching options...
"         https://vi.stackexchange.com/a/8858/9912
"
" Additional pages related to setting 'ag' as the grepprg option:
"   https://codeinthehole.com/tips/using-the-silver-searcher-with-vim/
"   https://aonemd.github.io/blog/finding-things-in-vim
"   Searching in hidden files:  --hidden
"   Searching in hidden subdirs:  -u
"
" Also:  about 'ag' - if you specify 'nogroup' (implies *both* nobreak &
"         noheading) ...   and THEN also specify 'noheading'...    you get BREAKS
" let s:ag_cmd = 'ag\ --column\ --nogroup\ --nocolor\ $*'
" let s:ag_cmd = 'ag\ --vimgrep\ $*'
let s:ag_cmd = 'ag\ --hidden\ -u\ --vimgrep\ $*'
let s:gg_cmd = 'ggrep\ -Pn\ $*'

if executable('ag')
	execute 'set grepprg=' . s:ag_cmd
elseif executable('ggrep')
	execute 'set grepprg=' . s:gg_cmd
endif

" Next we map some keys to manually switch between the programs
if executable('ag')
	execute 'nnoremap <leader>ra :set grepprg=' . s:ag_cmd . '<cr>'
endif
" NOTE:  no 'elseif'   -- all mappings defined if programs exist
if executable('ggrep')
	execute 'nnoremap <leader>rg :set grepprg=' . s:gg_cmd . '<cr>'
endif
nnoremap <leader>rd :set grepprg&<cr>
"}}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" These options are new for me
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE: this only helps when '.vimrc' is re-sourced after loading a file that has
"       autoformating options.  (b/c of the filetype option below)
set formatoptions-=tc	" without this, wrapping is automatic for certain file types
nnoremap <leader>nw :set formatoptions-=tc<cr>


" settings related to 'diff' mode "{{{
set diffopt+=vertical
nnoremap <leader>df :diffoff<cr>
nnoremap <leader>dt :diffthis<cr>
nnoremap <leader>du :diffupdate<cr>
" This is a neat little expression that cleanly lists all the windows
" currently in 'diff' mode.  from:  https://vi.stackexchange.com/a/16949/9912
nnoremap <leader>dl :echo join(
\								filter(
\										map(
\											range(1, winnr('$')),
\											'getwinvar(v:val, "&diff") ? "windows:".v:val." buffer:".winbufnr(v:val)." -> ".bufname(winbufnr(v:val)) : ""'),
\										'!empty(v:val)'),
\								"\n")<cr>

"
" Here I create two handy wrappers around the built-in 'do' and 'dp' commands
" thae automatically jump to the next change - AND can be repeated with '.' :D
" (For an example that uses the <Plug> facility, see:  https://vi.stackexchange.com/a/9547/9912)
"      Two examples of how to invoke a <Plug> mapping:
"            nmap <leader>do <Plug>VimdiffGet
"            nmap <leader>do :execute "normal \<Plug>VimdiffGet"<cr>
"
nnoremap <silent> <Plug>VimdiffGet :diffget<cr>]czz:silent! call repeat#set("\<Plug>VimdiffGet", v:count)<cr>
nnoremap <silent> <Plug>VimdiffPut :diffput<cr>]czz:silent! call repeat#set("\<Plug>VimdiffPut", v:count)<cr>
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
function! Maximize()
	" Inspired from: https://vim.fandom.com/wiki/Maximize_or_set_initial_window_size
	" But for me, when not in GUI - ANY attempt to adjust lines messed up the
	" display *beyond* the ability of "redraw!" to repair - so that part is commented out
	if has("gui_running")
		set lines=1000 columns=1000
	"else
	"	if exists("+lines")
	"		set lines=60
	"	endif
	"	if exists("+coluns")
	"		set coluns=235
	"	endif
	endif
endfunction
nnoremap <leader>ds :set diffopt=filler<bar>call Maximize()<bar>wincmd =<bar>normal gg]c<bar>redraw!<cr>
nnoremap <leader>di :set diffopt+=iwhite<cr>
" This also switch tabs when diff mode is not ON
nnoremap <expr> <c-pageup>   &diff ? '[czz' : ':tabprev<cr>'
nnoremap <expr> <c-pagedown> &diff ? ']czz' : ':tabnext<cr>'
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
filetype off			"" required for Vundle to load, will be renabled below

""
"" NOTE:  Got this recipe for how to "bootstrap" a Vundle setup from a fresh
""        system with only 'git' available.
""  see:  https://gist.github.com/klaernie/db37962e955c82254fed
""
set runtimepath+=~/.vim/bundle/Vundle.vim
let s:bootstrap = 0
try
	call vundle#begin()		"" can pass in a path for alternate plugin location
catch /E117:/
	let s:bootstrap = 1
	silent !mkdir -p ~/.vim/bundle
	silent !unset GIT_DIR && git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	redraw!
	call vundle#begin()
endtry
Plugin 'VundleVim/Vundle.vim'	"" let Vundle manage Vundle, REQUIRED
""
"" Other plugins here...
""

"" YCM:  Completions and tool tips.
""  NOTE:  needs more work to be enabled - more installed, and more locally built dependencies :(
"Plugin 'ycm-core/YouCompleteMe'

"" Current Matchit options:
""   Original (I think):  https://github.com/chrisbra/matchit
""   The one I used to incude here: https://github.com/geoffharcourt/vim-matchit 
""   Enhanced:  https://github.com/andymass/vim-matchup
Plugin 'chrisbra/matchit'
"" Found through this question:  "how to convert html escape codes"
""    http://stackoverflow.com/questions/5733660/is-there-an-html-escape-paste-mode-for-vim
Plugin 'tpope/vim-unimpaired'
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
Plugin 'preservim/nerdtree'
Plugin 'preservim/nerdcommenter'
"" Found this from:  https://ricostacruz.com/til/navigate-code-with-ctags
Plugin 'craigemery/vim-autotag'
"" Found this just by searching for something like it.   it seems new -- ought to give a shout out or something
Plugin 'MarSoft/nerdtree-grep-plugin'
"" Stumbled upon this while exploring peoples write-up comparison of CtrlP and CommandT
Plugin 'jlanzarotta/bufexplorer'
"" Here are some 'object types' that work with the noun/verb command structure :D
""	Found here:  https://blog.carbonfive.com/vim-text-objects-the-definitive-guide/
""      argument (a)       good for all languages
Plugin 'vim-scripts/argtextobj.vim'
""      indent level (i)   good for languages like Python (which rely on indent level)
Plugin 'michaeljsmith/vim-indent-object'
"" This is meant to work with `ag` which I just installed
Plugin 'rking/ag.vim'
Plugin 'Chun-Yang/vim-action-ag'
"" Found while looking for an easy way to jump b/w decl & defn   -- not that easy, even with CTags & CtrlP
""Plugin 'LucHermitte/lh-tags'     I'm not sure if I want this one - but I did not want to forget knowing about it ;)
Plugin 'vim-airline/vim-airline'
"" Found on the web.  Amazing assistance for working with Git repositories
Plugin 'tpope/vim-fugitive'
"" Another one from tpope - that helps manage scripts (helps a developer of scripts)
Plugin 'tpope/vim-scriptease'
"" I found this while searching around about Tmux mappings - and I'm gonna try it :)
""    Found here:  https://vimawesome.com/plugin/vim-tmux-navigator
""    Great writeup here:  https://gist.github.com/mislav/5189704
Plugin 'christoomey/vim-tmux-navigator'
"" Stumbled across this while searching for something else...    but
"" considering my own VIM use case...   this is PERFECT for me :)  (if it works)
Plugin 'unblevable/quick-scope'
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
Plugin 'will133/vim-dirdiff'

call vundle#end()			"" required

if s:bootstrap
	silent PluginInstall
	quit
end

filetype plugin indent on	"" required (the 'indent' clause is fine absent or present)
"}}}

" Settings relatd to the vim-unimpaired "{{{
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
"}}}

" BufExplorer mappings and settings "{{{
let g:bufExplorerShowNoName=1        " Show "No Name" buffers.
"}}}

" Debugging problems with fugitive "{{{
nnoremap <leader>i0 :0Gstatus<cr>
nnoremap <leader>is :Gstatus<cr>
"
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
set foldmethod=marker	" fold on the marker
""set foldmethod=syntax	" fold based on syntax
set foldlevel=100		" don't autofold anything (but I can still fold manually)

set foldopen=block,hor,tag    " what movements open folds
set foldopen+=percent,mark
set foldopen+=quickfix

nnoremap <leader>fmm :set foldmethod=marker<cr>
nnoremap <leader>fms :set foldmethod=syntax<cr>
nnoremap <leader>fme :set foldmethod=expr<cr>
nnoremap <leader>fmd :set foldmethod=diff<cr>
nnoremap <leader>fmi :set foldmethod=indent<cr>
"}}}


" NERDTree mappings and settings "{{{
nnoremap <leader>nt :NERDTreeToggle<cr>
nnoremap <leader>nf :NERDTreeFind<cr>
nnoremap <leader>nc :NERDTreeClose<cr>
nnoremap <leader>ng :NERDTreeFocus<cr>
"" Found here: https://superuser.com/questions/1050256/how-can-i-set-relative-line-numbers-upon-entering-nerdtree-on-vim
let g:NERDTreeShowLineNumbers=1
"autocmd BufEnter NERD_* setlocal rnu
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
		call setreg('+', n.path.str())
	endif
endfunction
"}}}


" CtrlP (& tags related) mappings and settings "{{{
" This is a technique to get VIM to search upwards for CTags 'tags' files
"  see:   ':h file-searching'
"  from:  https://stackoverflow.com/a/5019111/5844631
set tags=./tags;~
nnoremap <leader>cp :CtrlPTag<cr>
nnoremap <leader>cf :CtrlPBufTag<cr>
"nnoremap <leader>cm :CtrlPMRUFiles<cr>
"nnoremap <leader>cb :CtrlPBuffer<cr>
let g:ctrlp_max_files=0
" I got this idea from here:  https://thoughtbot.com/blog/faster-grepping-in-vim
let g:ctrlp_user_command = 'ag %s -l --hidden --nocolor -g ""'
" When using 'ag' to search based on file names -- it is so fast CtrlP does not need to cache enything
" (we'll see about that claim ;)
"let g:ctrlp_use_caching = 0
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


" Color settings - incl. line hightlight "{{{
" I found the following web pages helpful for setting these values
"
"      Color reference:   https://jonasjacek.github.io/colors/
"                         (with pics & names)
"
"      Some wierd table I have yet to figure out:
"             https://siatwe.wordpress.com/2018/03/23/vim-ctermfg-and-ctermbg-color-values/
"
"      Skeleton i borrowed:    https://vi.stackexchange.com/questions/23066/change-cursorline-style

nnoremap <leader>h :set cursorline! cursorcolumn!<cr>
augroup cursorline
	au!
	""
	"" NOTE:  I would rather link the line to the column -- so the colorscheme has a 'say'
	""        but it is almost always way to bright and overpowering
	""
	"au ColorScheme * hi clear CursorLine | hi link CursorLine CursorColumn
	au ColorScheme * hi clear CursorLine | hi clear CursorColumn |
					\ hi CursorLine term=reverse ctermbg=235 guibg=Grey15 |
					\ hi CursorColumn term=reverse ctermbg=235 guibg=Grey15
	"au ColorScheme * hi clear CursorLine | hi clear CursorColumn |
	"				\ hi CursorLine term=reverse ctermbg=145 guibg=Grey69 |
	"				\ hi CursorColumn term=reverse ctermbg=145 guibg=Grey69
augroup END
" Doing this here sets up what I like and triggers the autocmd just above
nnoremap <leader>o   <Nop>
nnoremap <leader>ob  <Nop>
nnoremap <leader>obt :set background=light<cr>
nnoremap <leader>obk :set background=dark<cr>
nnoremap <leader>obu :colorscheme blue<cr>
nnoremap <leader>od  <Nop>
nnoremap <leader>odb :colorscheme darkblue<cr>
nnoremap <leader>odf :colorscheme default<cr>
nnoremap <leader>odl :colorscheme delek<cr>
nnoremap <leader>ods :colorscheme desert<cr>
nnoremap <leader>oe  <Nop>
nnoremap <leader>oel :colorscheme elflord<cr>
nnoremap <leader>oen :colorscheme evening<cr>
nnoremap <leader>oi :colorscheme industry<cr>
nnoremap <leader>ok :colorscheme koehler<cr>
nnoremap <leader>om  <Nop>
nnoremap <leader>omv :colorscheme macvim<cr>
nnoremap <leader>omn :colorscheme morning<cr>
nnoremap <leader>omy :colorscheme murphy<cr>
nnoremap <leader>op  <Nop>
nnoremap <leader>opb :colorscheme pablo<cr>
nnoremap <leader>opp :colorscheme peachpuff<cr>
nnoremap <leader>or :colorscheme ron<cr>
nnoremap <leader>os  <Nop>
nnoremap <leader>osn :colorscheme shine<cr>
nnoremap <leader>ost :colorscheme slate<cr>
nnoremap <leader>os8 :colorscheme solarized8<cr>
nnoremap <leader>osf :colorscheme solarized8_flat<cr>
nnoremap <leader>osh :colorscheme solarized8_high<cr>
nnoremap <leader>osl :colorscheme solarized8_low<cr>
nnoremap <leader>ot :colorscheme torte<cr>
nnoremap <leader>oz :colorscheme zellner<cr>
"}}}


" Settings from VIM help files & examples "{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" These settings came from /usr/share/vim/vim74/vimrc_example.vim
"" (i.e. the example vimrc that installs with Vim)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Good stuff from the example that ships with Vim
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


" borrowed mappings & settings 'nickaigi' "{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" The following options came from:  https://github.com/nickaigi/config/blob/master/.vimrc#L12
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
"" Disabling items that come with the 'Unimpaired' plugin
"" nnoremap <silent> [b :bprevious<CR>
"" nnoremap <silent> ]b :bnext<CR>
"" nnoremap <silent> [B :bfirst<CR>
"" nnoremap <silent> ]B :blast<CR>
"" This is a way to delete the buffer but not the window
command! Bd bp<bar>bd#		"" close the current buffer, but not the window
nnoremap <leader>bd :bp<bar>bd#<cr>
nnoremap <leader>bk :bp<bar>bd!#<cr>
nnoremap <leader>bw :bp<bar>bw#<cr>
nnoremap <leader>bq :bp<bar>bw!#<cr>

" Command & mapping that take a {count} and reverse lines
command! -bar -range=% Reverse <line1>,<line2>g/^/m<line1>-1|nohl
nnoremap <leader>re :Reverse<CR>
xnoremap <leader>re :Reverse<CR>

""
""Easy expansion of the active file directory	(see ":help <expr>")
""
"" NOTE:  this may not be working :(
cnoremap <expr> %p  getcmdtype() == ':' ? expand('%:p') : '%p'
cnoremap <expr> %%  getcmdtype() == ':' ? expand('%:h').'/' : '%%'
""
"" Save a file that requires root permissions (see ":help :w_c" and ":help c_%")
""
cnoremap w!! w !sudo tee >/dev/null %
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
" This setting shows buffers in the top bar when there is just one tab
"let g:airline#extensions#tabline#enabled=1
"}}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" These options are related to general source editing
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Source editing mappings & settings "{{{
""
"" This first 'simple' mapping just performs a ':s' command to delete trailing whitespace
""
""nnoremap <leader>tr :%s/[ \t]\+$//<cr>

""
"" This second version does the same thing but preserves the search history
""
nnoremap <leader>tr :let b:old = @/<bar>%s/[ \t]\+$//<bar>call histdel('/',-1)<bar>let @/ = b:old<cr>
""
"" This third version was my inspiration, from http://stackoverflow.com/a/21087108/5844631
"" However, I am not sure why there is a '<cr>==' in the middle.  I am not sure what that does
""
""nnoremap <leader>tr :let b:old = @/<bar>%s/[ \t]\+$//<cr>==:nohls<bar>call histdel('/',-1)<bar>let @/ = b:old<cr>

""
"" For easy file type conversion and cleanup of the extra ^M characters that appear when converting Dos->Unix
""
nnoremap <leader>ftu :e ++ff=unix<cr>
nnoremap <leader>ftd :e ++ff=dos<cr>
nnoremap <leader>ftm :%s/<C-V><cr>$//<cr>

""
"" These options are related to C/C++ source editing
""
" These are for indenting/unindenting/formating blocks of code
" NOTE:  these are very nearly colliding with the mappings that come with the BufExplorer plugin
nmap <leader>bi /\{<cr>j0mskn%k0me's0<c-v>'e0I	\tr's0kk
nmap <leader>bu /\{<cr>j0mskn%k0me's0<c-v>'e0x's0kk
nmap <leader>bf 0ms/\{<cr>%me's!'eclang-format<cr>


nnoremap <leader>mr :!chmod -w %<cr>
nnoremap <leader>mw :!chmod +w %<cr>
nnoremap <leader>mx :!chmod +x %<cr>
"}}}



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
""	NOTE:	I had trouble with these mappings always always always beeping
""			This was fixed by removing the trailing comment from the line that defined the mapping
""			The following URL explains a couple of reasons why a mapping may beep, and the solutions...
""				http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_%28Part_2%29
""
""
"" F4		moves to next error in the quickfix window
"" Shift+F4	moves to previous (again used 'sed -n l' to get codes)
""
nnoremap <leader>qo :copen<cr>
nnoremap <leader>qc :cclose<cr>
nnoremap <leader>ql :cclose<cr>

nnoremap <f4> :cn<cr>
nnoremap <esc>[1;2S :cp<cr>
"nnoremap <c-j> :cn<cr>
"nnoremap <c-k> :cp<cr>

""nnoremap <esc>[6;5~ ]c
""nnoremap <esc>[5;5~ [c
"}}}


" Easily move the current line up or down "{{{
""
"" These sweet mappings move lines up and down with alt+up and alt+down
"" HOWEVER there is a bug when trying to move down multiple lines!
""         (multiple lines work when moving up, though not elegantly)
""
"nnoremap <esc>[1;3B :m .+1<cr>
"nnoremap <esc>[1;3A :m .-2<cr>
nnoremap <leader>j :m .+1<cr>
nnoremap <leader>k :m .-2<cr>
"}}}


" Tab movement "{{{
"" disabling my original tab helpers - I had never started using them, AND the interfere with unimpaired mappings for CTags movement
"" nnoremap <silent> [t :tabprevious<CR>
"" nnoremap <silent> ]t :tabnext<CR>
"" nnoremap <silent> [T :tabfirst<CR>
"" nnoremap <silent> ]T :tablast<CR>
" These three are still useful
nnoremap <leader>ae :tabedit 
nnoremap <leader>an :tabnew<cr>
nnoremap <leader>ac :tabclose<cr>
" Make Alt-left and right switch tabs
"nnoremap <esc>[1;3C :tabn<cr>
"nnoremap <esc>[1;3D :tabp<cr>
"" Before enabling these...   I'm trying to get used to:   'gt' and 'gT'
"nnoremap <leader>an :tabn<cr>
"nnoremap <leader>ap :tabp<cr>
""
"" Here's some awesome functions I found here:  https://vim.fandom.com/wiki/Move_current_window_between_tabs
""
function! MoveToPrevTab()
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
function! MoveToNextTab()
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
"" These mappings are for <Alt-,> and <Alt-.> (use `sed -n l` to discover the right codes)
nnoremap <leader>ah :call MoveToPrevTab()<cr>
nnoremap <leader>al :call MoveToNextTab()<cr>
"}}}


" Window mappings & settings (including resizing with shit/ctrl arrows) "{{{
set noequalalways
nnoremap <silent> <leader>l :hide<cr>

""
"" Disabling these - due to a new plugin i have:  vim-tmux-navigator
""
" Make Control-direction switch between windows (like C-W h, etc)
"nmap <silent> <c-k> <c-w><c-k>
"nmap <silent> <c-j> <c-w><c-j>
"nmap <silent> <c-h> <c-w><c-h>
"nmap <silent> <c-l> <c-w><c-l>

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
nnoremap <silent> <esc>[1;2A :call Resize('+', '5')<cr>
nnoremap <silent> <esc>[1;2B :call Resize('-', '5')<cr>
nnoremap <silent> <esc>[1;2C :call Resize('>', '5')<cr>
nnoremap <silent> <esc>[1;2D :call Resize('<', '5')<cr>

" And Ctrl-arrows small adjustments (this is OK in VIM for me - because don't use arrows for navigating :)
nnoremap <silent> <esc>[1;5A :call Resize('+', '1')<cr>
nnoremap <silent> <esc>[1;5B :call Resize('-', '1')<cr>
nnoremap <silent> <esc>[1;5C :call Resize('>', '1')<cr>
nnoremap <silent> <esc>[1;5D :call Resize('<', '1')<cr>

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
nnoremap <leader>pe :!p4 edit "$(realpath "%")"<cr>
nnoremap <leader>pa :!p4 add "$(realpath "%")"<cr>
"" I'm nervous about this - accidentally losing work and all...
nnoremap <leader>pr :!p4 revert "$(realpath "%")"<cr>


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
"" This bit of magic will force this file to reload every time it is saved
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup myvimrc
	au!
	""  NOTE:  currently I don't have a ".gvimrc file, so I have commented that part out
	""au bufwritepost $MYVIMRC,$MYGVIMRC so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
	au bufwritepost $MYVIMRC so $MYVIMRC
augroup end

