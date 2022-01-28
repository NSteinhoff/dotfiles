# Dotfiles

## Installation

    make install

    make uninstall

This will also install `stow` for you.

To install any of the individual packages listed by `ls stow`:

    stow -vvv <package>

Or uninstall with:

    stow -vvvD <package>


### Configuration files
Configuration *"packages"* are managed with [`stow`][stow].


### Tag files
Tag files are updated through git-hooks as described by [TPope][tpope-ctags].

Location: `.git/tags`


[tpope-ctags]: https://tbaggery.com/2011/08/08/effortless-ctags-with-git.html
[stow]: https://www.gnu.org/software/stow/
