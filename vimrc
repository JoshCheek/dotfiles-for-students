"" ===== Smallest reasonable configuration =====
set nocompatible                " Behave more usefully at the expense of backwards compatibility (this line comes first b/c it alters how the others work)
set encoding=utf-8              " Format of the text in our files (prob not necessary, but should prevent weird errors)
filetype plugin on              " Load code that configures vim to work better with whatever we're editing
filetype indent on              " Load code that lets vim know when to indent our cursor
syntax on                       " Turn on syntax highlighting
set backspace=indent,eol,start  " backspace through everything in insert mode
set expandtab                   " When I press tab, insert spaces instead
set shiftwidth=2                " Specifically, insert 2 spaces
set tabstop=2                   " When displaying tabs already in the file, display them with a width of 2 spaces

"" ===== Instead of backing up files, just reload the buffer (in-memory representation of a file) when it changes. =====
"" Imma edit the same file multiple times, okay, vim? fkn deal
set autoread                         " Auto-reload buffers when file changed on disk
set nobackup                         " don't use backup files
set nowritebackup                    " don't backup the file while editing
set noswapfile                       " don't create swapfiles for new buffers
set updatecount=0                    " Don't try to write swapfiles after some number of updates
set backupskip=/tmp/*,/private/tmp/* " Can edit crontab files

"" ===== Aesthetics =====
set t_Co=256        " Explicitly tell vim that the terminal supports 256 colors (iTerm2 does, )
set background=dark " Tell vim to use colours that works with a dark terminal background (opposite is "light")
set laststatus=2    " Always show the statusline
set nowrap          " Display long lines as truncated instead of wrapped onto the next line
set cursorline      " Colour the line the cursor is on
set number          " Show line numbers
set hlsearch        " Highlight search matches

"" Basic behaviour =====
set scrolloff=4        " adds top/bottom buffer between cursor and window
set incsearch          " Incremental searching
set clipboard=unnamed  " Use system clipboard (requires a reasonably compiled vim, ie MacVim, not system vim)


"" ===== Mappings and keybindings. Note that <Leader> is the backslash by default. =====
" You can change it, though, as seen here: https://github.com/bling/minivimrc/blob/43d099cc351424c345da0224da83c73b75bce931/vimrc#L20-L21
cmap %/ <C-R>=expand("%:p:h")."/"<CR>;                    " Replace %/ with directory of current file (eg `:vs %/`)
cmap %% <C-R>=expand("%")<CR>;                            " Replace %% with current file (eg `:vs %%`)
vnoremap . :norm.<CR>;                                    " In visual mode, "." will for each line, go into normal mode and execute the "."
nnoremap <Leader>v :set paste<CR>"*p<CR>:set nopaste<CR>; " Paste without being stupid ("*p means to paste on next line (p) from the register (") that represents the clipboard (*))
nmap <Leader>p orequire "pry"<CR>binding.pry<ESC>;        " Pry insertion

"" ===== Seeing Is Believing =====
" Assumes you have a Ruby with SiB available in the PATH
nmap <leader>b :%!seeing_is_believing --timeout 12 --line-length 500 --number-of-captures 300 --alignment-strategy chunk<CR>;
nmap <leader>n :%!seeing_is_believing --timeout 12 --line-length 500 --number-of-captures 300 --alignment-strategy chunk --xmpfilter-style<CR>;
nmap <leader>c :%!seeing_is_believing --clean<CR>;
nmap <leader>m A # => <Esc>;
vmap <leader>m :norm A # => <Esc>;


"" =====  easier navigation between split windows =====
" NOTATION:
"
" <C-h>  means "hold control and press 'h'",
"        so this first one means that when you hold control and press "h",
"        it will be as if you had held control and pressed "w",
"        then released control and pressed "h"
"
" <Esc>h means "Press Escape and then press 'h'".
"        Or if your terminal is configured to, you can hold option and press
"        "h". So this first one means that when you hold control and press "h",
"        it will be as if you had held control and pressed "w",
"        then released control and pressed "h"
nnoremap <c-h> <c-w>h; " Goes to the window to the left of this one.
nnoremap <c-j> <c-w>j; " Goes to the window under this one.
nnoremap <c-k> <c-w>k; " Goes to the window above this one.
nnoremap <c-l> <c-w>l; " Goes to the window to the right of this one.


"" ===== Shell keybindings for commandline mode  ======
"  http://tiswww.case.edu/php/chet/readline/readline.html#SEC4
"  many of these taken from vimacs http://www.vim.org/scripts/script.php?script_id=300

" navigation
  " Beginning of the line
    cnoremap <C-a> <Home>
  " End of the line
    cnoremap <C-e> <End>
  " Right 1 character
    cnoremap <C-f> <Right>
  " Left 1 character
    cnoremap <C-b> <Left>
  " Back 1 word
    cnoremap <Esc>b <S-Left>
  " Back a character
    cnoremap <Esc>f <S-Right>
  " Previous line
    cnoremap <Esc>p <Up>
  " Next line
    cnoremap <Esc>n <Down>

" editing
  " Kill right (basically "cut")
    cnoremap <C-k> <C-f>d$<C-c><End>
  " Yank what we killed (basically "paste")
    cnoremap <C-y> <C-r><C-o>
  " Delete next character
    cnoremap <C-d> <Right><C-h>


"" =====  Filetypes  ======
au BufRead,BufNewFile *.elm setfiletype haskell          " Highlight Elm as Haskell
au BufRead,BufNewFile *.sublime-* setfiletype javascript " Highlight sublime configuration files as javascript .sublime-{settings,keymap,menu,commands}
au BufRead,BufNewFile *.sublime-snippet setfiletype html " Highlight sublime templates as html

"" =====  Trailing Whitespace  =====
" Don't remember where I got this from
function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces() " strip trailing whitespace on save

"" =====  Turn off arrow keys  =====
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>
noremap  <Up> <NOP>
noremap  <Down> <NOP>
noremap  <Left> <NOP>
noremap  <Right> <NOP>

"" =====  Tell vim which files are Ruby files  =====
" Stolen from: https://github.com/vim-ruby/vim-ruby/blob/72f8b21856bac46b7b1a19194f5a3aa1006346bb/ftdetect/ruby.vim
function! s:setf(filetype) abort
  if &filetype !=# a:filetype
    let &filetype = a:filetype
  endif
endfunction
au BufNewFile,BufRead *.rb,*.rbw,*.gemspec	        call s:setf('ruby')
au BufNewFile,BufRead *.builder,*.rxml,*.rjs,*.ruby call s:setf('ruby')
au BufNewFile,BufRead [rR]akefile,*.rake	          call s:setf('ruby')
au BufNewFile,BufRead [rR]antfile,*.rant	          call s:setf('ruby')
au BufNewFile,BufRead .irbrc,irbrc		              call s:setf('ruby')
au BufNewFile,BufRead .pryrc			                  call s:setf('ruby')
au BufNewFile,BufRead *.ru			                    call s:setf('ruby')
au BufNewFile,BufRead Capfile,*.cap 		            call s:setf('ruby')
au BufNewFile,BufRead Gemfile			                  call s:setf('ruby')
au BufNewFile,BufRead Guardfile,.Guardfile	        call s:setf('ruby')
au BufNewFile,BufRead Cheffile			                call s:setf('ruby')
au BufNewFile,BufRead Berksfile			                call s:setf('ruby')
au BufNewFile,BufRead [vV]agrantfile		            call s:setf('ruby')
au BufNewFile,BufRead .autotest			                call s:setf('ruby')
au BufNewFile,BufRead *.erb,*.rhtml		              call s:setf('eruby')
au BufNewFile,BufRead [tT]horfile,*.thor	          call s:setf('ruby')
au BufNewFile,BufRead *.rabl			                  call s:setf('ruby')
au BufNewFile,BufRead *.jbuilder		                call s:setf('ruby')
au BufNewFile,BufRead Puppetfile		                call s:setf('ruby')
au BufNewFile,BufRead [Bb]uildfile		              call s:setf('ruby')
au BufNewFile,BufRead Appraisals		                call s:setf('ruby')
au BufNewFile,BufRead Podfile,*.podspec		          call s:setf('ruby')
au BufNewFile,BufRead [rR]outefile		              call s:setf('ruby')
au BufNewFile,BufRead .simplecov		                call s:setf('ruby')
