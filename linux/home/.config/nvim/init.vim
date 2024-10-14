"set mouse=a

" Press F3 to toggle line numbering
set number
set relativenumber
nmap <F3> :set invnumber<CR>:set invrelativenumber<CR>
imap <F3> :set invnumber<CR>:set invrelativenumber<CRAa

" Press F2 to toggle whitespace
set lcs+=space:·
nmap <F2> :set invlist<CR>
imap <F2> <ESC>:set invlist<CR>a

" Press F4 to toggle paste mode
nnoremap <F4> :set invpaste paste?<CR>
set pastetoggle=<F4>
set showmode

let g:clipboard = {
        \   'name': 'wslclipboard',
        \   'copy': {
        \      '+': 'win32yank.exe -i --crlf',
        \      '*': 'win32yank.exe -i --crlf',
        \    },
        \   'paste': {
        \      '+': 'win32yank.exe -o --lf',
        \      '*': 'win32yank.exe -o --lf',
        \   },
        \   'cache_enabled': 1,
        \ }

" Synchronize clipboard and default registers, for copy-paste across terminals
" NOTE: For Neovim running in WSL, ensure win32yank.exe is available in PATH
set clipboard+=unnamedplus

" Fix cursor flicker caused by tmux status bar updates
"let &t_SI = "\e[6 q"
"let &t_EI = "\e[2 q"

" Indentation
set tabstop=4 shiftwidth=4 expandtab
filetype plugin indent on

autocmd BufNewFile,BufRead
    \ *.git/config
    \,.gitconfig
    \,.gitmodules
    \,gitconfig
    \,~/.config/git/config
    \ setfiletype gitconfig

autocmd FileType gitconfig set noexpandtab
autocmd FileType json set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType yaml set tabstop=2|set shiftwidth=2|set expandtab

