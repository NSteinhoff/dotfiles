#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
bkpdir=~/dotfiles_bkp             # old dotfiles backup directory
files=(vimrc vim screenrc gitconfig tmux.conf zshrc crawlrc ctags scalafmt.conf bash_functions)

##########

# install zsh
echo -n "Making Zsh default shell"
sudo chsh -s `which zsh`
echo -n "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# create dotfiles_old in homedir
echo -n "Creating $bkpdir for backup of any existing dotfiles in ~ ..."
mkdir -p $bkpdir

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    echo "Moving ~/.$file to $bkpdir/$file"
    mv -n ~/.$file $bkpdir/.$file
    echo "Creating symlink '~/."$file"' -> '"$dir/$file"'"
    ln -s $dir/$file ~/.$file
done

# Init and update the plugins tracked as submodules
git submodule update --init --recursive
