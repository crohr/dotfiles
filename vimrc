set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

Bundle "rails.vim"
Bundle "Markdown"

Bundle "git.zip"

" (HT|X)ml tool
Bundle "ragtag.vim"


" Utility
Bundle "repeat.vim"
Bundle "surround.vim"
Bundle "SuperTab"
Bundle "file-line"
Bundle "Align"

" FuzzyFinder
Bundle "L9"
Bundle "FuzzyFinder"

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
