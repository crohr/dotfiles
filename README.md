## Installation

### Ubuntu 20.04

Run the install script (idempotent):

    SERVER="1.2.3.4"
    scp install.sh root@$SERVER:/tmp/install.sh && ssh -A -t root@$SERVER bash /tmp/install.sh

### OSX:

    brew tap thoughtbot/formulae
    brew install rcm
    git clone https://github.com/crohr/dotfiles ~/.dotfiles
    rcup

Setup vim:

    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
