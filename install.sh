#!/bin/bash
############################
# .install.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## ZSH

# install zsh
if false; then
    tput setaf 3
    echo "Making Zsh default shell"
    sudo chsh -s `which zsh`
    echo "Installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    tput sgr0
fi

########## Dotfiles in HOME

dir=~/dotfiles                    # dotfiles directory
bkpdir=~/.dotfiles_bkp
files=(inputrc vimrc vim git_template screenrc gitconfig gitignore tmux.conf zshrc bash_aliases crawlrc ctags ctags.d scalafmt.conf)

# create dotfiles_old in homedir
echo "Creating $bkpdir for backup of any existing dotfiles in ~ ..."
mkdir -p $bkpdir

# change to the dotfiles directory
echo "Changing to the $dir directory ..."
cd $dir

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in ${files[*]}; do
    if [ -L ~/.$file ]; then
        tput setaf 3
        echo -n "Removing old symlink; "
        rm ~/.$file
        tput sgr0
    fi
    if [ -f ~/.$file ] || [ -d ~/.$file ]; then
        tput setaf 3
        echo -n "Moving existing file; "
        mv -v ~/.$file $bkpdir/$file
        tput sgr0
    fi
    tput setaf 2
    echo -n "Creating symlink: "
    tput sgr0
    ln -v -s $dir/$file ~/.$file
done

########## Configurations in ~/.config

cfgdir=$dir/config
cfgbkpdir=~/.config/backup_$(date +%F-%T)
files=(alacritty/alacritty.yml)

# create dotfiles_old in homedir

# change to the dotfiles directory
echo "Changing to the $cfgdir directory ..."
cd $cfgdir

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in ${files[*]}; do
    if [ -L ~/.config/$file ]; then
        tput setaf 3
        echo -n "Removing old symlink; "
        rm ~/.config/$file
        tput sgr0
    fi
    if [ -f ~/.config/$file ] || [ -d ~/.config/$file ]; then
        tput setaf 3
        echo -n "Backing-up existing file; "
        mkdir -p $cfgbkpdir/${file%/*}
        mv -v ~/.config/$file $cfgbkpdir/$file
        tput sgr0
    fi
    tput setaf 2
    echo -n "Creating symlink: "
    tput sgr0
    ln -v -s $cfgdir/$file ~/.config/$file
done


# Init and update the plugins tracked as submodules
git submodule update --init --recursive
