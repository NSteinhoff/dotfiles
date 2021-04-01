# vim: ft=sh

# Disable <ctrl-s> suspending (reactivated with <ctrl-q>)
stty -ixon

# Variables
: ${NOTES_DIR:=~/Dropbox/Notes}

# History
HISTSIZE=100000
HISTFILESIZE=200000

export PATH="~/.local/bin:$PATH"

shopt -s histappend

# Set Vim as default editor
export EDITOR=vim
which nvim &>/dev/null && export EDITOR=nvim

case $OSTYPE in
    linux*) os="linux";;
    darwin*) os="mac";;
esac

# -----------------------------------------------------------------------------
#  ALIASES
# -----------------------------------------------------------------------------
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
alias ll='ls -lFh'
alias lla='ll -a'
alias tree='tree --dirsfirst'

# Listing dirs
alias dirs='dirs -v'

# Web search
alias q='_() { q="${@:1}"; '$opener' "https://duckduckgo.com/?q=${q}"; }; _'

# Why not
alias :q='exit'
alias :e='$EDITOR'

# Git
alias g='git status'

# Context aware information
# TODO: Think of some useful commands here.
# Maybe this would be a nice place for the bashbot.
alias ?='$QUESTION_MARK_PRG'
export QUESTION_MARK_PRG='git status'
export QUESTION_MARK_PRG='git status'

# Read errors from stdin into a scratch buffer and load into quickfix list
alias quickfix='vim +"set bt=nofile" +cbuffer -'

# Open notes for editing
_complete_notes() {
    COMPREPLY=( $(compgen -W "$(ls $NOTES_DIR/)" $2) )
}
complete -F _complete_notes note
alias note='_() { $EDITOR --cmd "cd $NOTES_DIR" +"map q :wq<CR>" $NOTES_DIR/$1 ; }; _'
alias t='$EDITOR +"map Q :wq<CR>" $NOTES_DIR/tasks.taskpaper'

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

_complete_tmux() {
    COMPREPLY=( $(compgen -W "$(tmux list-commands -F#{command_list_name})" $2) )
}
complete -F _complete_tmux tmux

# ---------------------------------- PROMPT -----------------------------------
starship_prompt=true
fancy_prompt=true
if $starship_prompt &&(which starship &>/dev/null); then
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
alias gopacks='cd ~/dev/dotfiles/stow/nvim/.config/nvim/pack/external/opt'
alias mypacks='cd ~/dev/dotfiles/stow/nvim/.config/nvim/pack/personal/opt'
export CDPATH=~/dev:~/dev/s2
export JOURNAL_ROOT=~/Dropbox/Notes
export ZETTELKASTEN=~/Dropbox/Zettel

# ---------------------------------- direnv -----------------------------------
which direnv &>/dev/null && eval "$(direnv hook bash)"
