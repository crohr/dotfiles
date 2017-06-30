set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

Plugin 'fatih/vim-go'
Bundle "rails.vim"
" Bundle 'KurtPreston/vim-autoformat-rails'
" Auto-detect indentation
" Bundle "tpope/vim-sleuth"
Bundle "Markdown"

Bundle "git.zip"

" (HT|X)ml tool
Bundle "ragtag.vim"

Bundle "rodjek/vim-puppet"

" Utility
Bundle "repeat.vim"
Bundle "surround.vim"
Bundle "SuperTab"
Bundle "file-line"
Bundle "Align"

" FuzzyFinder
Bundle "L9"
Bundle "FuzzyFinder"
Bundle "ctrlp.vim"

" tComment
Bundle "tComment"
nnoremap // :TComment<CR>
vnoremap // :TComment<CR>

" Command-T
Bundle "git://git.wincent.com/command-t.git"
let g:CommandTMatchWindowAtTop=1 " show window at top

" Navigation
Bundle "http://github.com/gmarik/vim-visual-star-search.git"

call vundle#end()            " required
filetype plugin indent on    " required

" show hidden files by default in ctrlp
let g:ctrlp_show_hidden = 1

" easily switch between paste and nopaste
set pastetoggle=<F6>

autocmd Filetype ruby setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype python setlocal tabstop=8 expandtab shiftwidth=4 softtabstop=4
autocmd Filetype eruby setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype html setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype markdown setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype scss setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype css setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype conf setlocal ts=2 sts=2 sw=2 expandtab

syntax on
set number
autocmd Filetype sh setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
" autocmd FileType go setlocal shiftwidth=8 tabstop=8 softtabstop=8 noexpandtab
