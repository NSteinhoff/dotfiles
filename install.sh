#!/bin/bash
############################
# .install.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
bkpdir=~/dotfiles_bkp             # old dotfiles backup directory
files=(vimrc vim screenrc gitconfig tmux.conf zshrc bash_aliases crawlrc ctags ctags.d scalafmt.conf)

##########

# install zsh
if false; then
    echo "Making Zsh default shell"
    sudo chsh -s `which zsh`
    echo "Installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# create dotfiles_old in homedir
echo "Creating $bkpdir for backup of any existing dotfiles in ~ ..."
mkdir -p $bkpdir

# change to the dotfiles directory
echo "Changing to the $dir directory ..."
cd $dir

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in ${files[*]}; do
    if [ -L ~/.$file ]; then
        echo -n "Removing old symlink: "
        rm ~/.$file
    fi
    if [ -f ~/.$file ] || [ -d ~/.$file ]; then
        echo -n "Moving: "
        mv -v ~/.$file $bkpdir/.$file
    fi
    echo -n "Creating symlink: "
    ln -v -s $dir/$file ~/.$file
done

# Init and update the plugins tracked as submodules
git submodule update --init --recursive
