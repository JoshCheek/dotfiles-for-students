set nocompatible  " don't try to be compatible with legacy vi
filetype off
filetype plugin indent on    " required
set encoding=utf-8

"" Basic editor behaviour
filetype plugin indent on       " load file type plugins + indentation
set t_Co=256                    " Explicitly tell vim that the terminal supports 256 colors
syntax enable                   " highlighting and shit
set cursorline                  " colours the line the cursor is on
set scrolloff=4                 " adds top/bottom buffer between cursor and window
set number                      " line numbers
set showcmd                     " display incomplete commands
set autoread                    " Auto-reload buffers when file changed on disk
set background=light            " don't use the fkn bright colours

"" Whitespace
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

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()  " strip trailing whitespace on save
set nowrap                                                   " don't wrap lines
set tabstop=2 shiftwidth=2                                   " a tab is two spaces (or set this to 4)
set expandtab                                                " use spaces, not tabs (optional)
set backspace=indent,eol,start                               " backspace through everything in insert mode

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching

"" Omg, vim, Imma edit the same file multiple times, okay? fkn deal with it
set nobackup                             " no backup files
set nowritebackup                        " don't backup file while editing
set noswapfile                           " don't create swapfiles for new buffers
set updatecount=0                        " Don't try to write swapfiles after some number of updates
set backupskip=/tmp/*,/private/tmp/*"    " can edit crontab files

"" Convenience
nmap <Leader>p orequire "pry"<CR>binding.pry<ESC>;        " pry insertion
vnoremap . :norm.<CR>;                                    " in visual mode, "." will for each line, go into normal mode and execute the "."
nnoremap <Leader>w :w!<CR>;                               " Fuck you x1million, vim (http://stackoverflow.com/questions/26070153/vim-wont-write-file-without-a-sometimes-e13)
nnoremap <Leader>v :set paste<CR>"*p<CR>:set nopaste<CR>; " paste without being stupid ("*p means to paste on next line (p) from the register (") that represents the clipboard (*))

" replaces %/ with current directory, and %% with current file
cmap %/ <C-R>=expand("%:p:h")."/"<CR>
cmap %% <C-R>=expand("%")<CR>

"" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

"" Emacs/Readline keybindings for commandline mode
"  http://tiswww.case.edu/php/chet/readline/readline.html#SEC4
"  many of these taken from vimacs http://www.vim.org/scripts/script.php?script_id=300
" navigation
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <Esc>b <S-Left> " commenting out b/c makes it pause
cnoremap <Esc>f <S-Right>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>
" editing
cnoremap <M-p> <Up>
cnoremap <M-n> <Down>
cnoremap <C-k> <C-f>d$<C-c><End>
cnoremap <C-y> <C-r><C-o>"
cnoremap <C-d> <Right><C-h>

"" filetypes
au BufRead,BufNewFile *.elm setfiletype haskell
au BufRead,BufNewFile *.sublime-* setfiletype javascript " .sublime-{settings,keymap,menu,commands}
au BufRead,BufNewFile *.sublime-snippet setfiletype html
