# vim: ft=sh

# Disable <ctrl-s> suspending (reactivated with <ctrl-q>)
stty -ixon

# History
HISTSIZE=100000
HISTFILESIZE=200000

# Prefer local binaries
export PATH="~/.local/bin:$PATH"

shopt -s histappend

# Set Vim as default editor
which nvim &>/dev/null && export EDITOR=nvim || export EDITOR=vim

case $OSTYPE in
    linux*) os="linux";;
    darwin*) os="mac";;
esac

# --------------------------------------------------------------------------- #
#                                   Aliases                                   #
# --------------------------------------------------------------------------- #
if [[ os == linux ]]; then
    opener=xdg-open
else
    opener=open
fi

# Safer delete
alias rm='rm -i'

# Listing files
[ $os = "linux" ] && alias ls='ls --color=auto --group-directories-first'
[ $os = "mac" ] && alias ls='ls -G'
alias l='ls -CF'
alias la='l -A'
alias ll='ls -lFh'
alias lla='ll -A'
alias tree='tree -CF --dirsfirst'

# Listing dirs
alias dirs='dirs -v'

# Grep with color
alias grep='grep --color=auto'

# Web search
alias q='_() { q="${@:1}"; '$opener' "https://duckduckgo.com/?q=${q}"; }; _'

# Why not
alias :q='exit'
alias :e='$EDITOR'

# Git
alias g='git status'
alias g-='git switch -'

# Context aware information
# TODO: Think of some useful commands here.
# Maybe this would be a nice place for the bashbot.
alias ?='$QUESTION_MARK_PRG'
export QUESTION_MARK_PRG='git status'

# Read errors from stdin into a scratch buffer and load into quickfix list
alias quickfix='vim +"set bt=nofile" +cbuffer -'

# Open notes for editing
_complete_notes() {
    COMPREPLY=( $(compgen -W "$(ls $NOTES_DIR/)" $2) )
}
complete -F _complete_notes note
alias note='_() { $EDITOR --cmd "cd $NOTES_DIR" $NOTES_DIR/$1 ; }; _'
alias journal='nvim +Journal'
alias t='$EDITOR +"map Q :wq<CR>" $NOTES_DIR/tasks.taskpaper'
alias T='$EDITOR +"map Q :wq<CR>" $NOTES_DIR/todo.taskpaper'
alias todo='$EDITOR +"map Q :wq<CR>" $NOTES_DIR/todo.taskpaper'

# Open
[[ $OSTYPE = linux* ]] && alias open='xdg-open'

# Syntax highlighting (no need for 'bat')
alias hi='highlight -O ansi --force'
alias hil='_() { highlight -O ansi --force $@ | less -R; }; _'

# Journaling
alias zettel='_() { nvim "+Zettel $*"; }; _'

# ---------- Java Version ---------
[[ -z $JAVA_HOME && "$os" == linux && -x $(which java) ]] && JAVA_HOME=$(readlink -f $(which java) | sed "s:/bin/java::")

# -----------   COMPLETIONS   --------------
# [check for executable] && [ensure exists] && [source completions]
[ -d ~/.config/bash-completion ] || mkdir -p ~/.config/bash-completion
[ -r ~/.config/bash-completion/git ] || curl -sS https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > ~/.config/bash-completion/git

if [ -n "$(ls ~/.config/bash-completion/)" ]; then
    for file in ~/.config/bash-completion/*; do source "$file"; done
fi

(which pandoc &>/dev/null) && eval "$(pandoc --bash-completion)"

_complete_tmux() {
    COMPREPLY=( $(compgen -W "$(tmux list-commands -F#{command_list_name})" $2) )
}
complete -F _complete_tmux tmux

_complete_colorscheme() {
    COMPREPLY=( $(compgen -W "$(grep -E '^\s*.*:\s&.*$' $HOME/.config/alacritty/colors.yml | cut -d \& -f 2)" $2) )
}
complete -F _complete_colorscheme colorscheme

# ---------------------------------- PROMPT -----------------------------------
starship_prompt=true
fancy_prompt=true
if $starship_prompt && (which starship &>/dev/null); then
    eval "$(starship init bash)"
elif $fancy_prompt; then
    case "$TERM" in
    xterm*|rxvt*|tmux*|screen*)
        PS1_tail='\$ '
        PS1_head="${PS1%'\$ '} "
        [[ $PS1 == *git-prompt* ]] || export PS1='$(tmux-prompt)'"$PS1_head"'$(git-prompt)[\j]'"\n$PS1_tail"
        ;;
    *)
        ;;
    esac
fi

# --------------------------- Directory Shortcuts -----------------------------
export CDPATH=~/Develop:~/Develop/s2
export NOTES_DIR=~/Dropbox/Notes
export ZETTELKASTEN=~/Dropbox/Zettel

# --------------------------- C Compilation ---------------------------------
# export CC=clang
# export CFLAGS="${CFLAGS:+${CFLAGS} }-g -Wall -Werror -Wextra -pedantic"
# export LDFLAGS="${LDFLAGS:+${LDFLAGS} }"
# export LDLIBS="${LDLIBS:+${LDLIBS} }"

alias neovide='neovide --multigrid'
