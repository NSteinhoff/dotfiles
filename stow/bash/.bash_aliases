# vim: ft=sh

# Disable <ctrl-s> suspending (reactivated with <ctrl-q>)
stty -ixon

# History
HISTSIZE=100000
HISTFILESIZE=200000

_clean_history() {
  # history -n has to be there before history -w to read from
  # .bash_history the commands saved from any other terminal,
  history -n            # Read in entries that are not in current history
  history -a            # Append history; does not trigger erasedups
  history -c            # Clear current history
  history -r            # Read history from $HISTFILE
}

export PROMPT_COMMAND="_clean_history;$PROMPT_COMMAND"
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
alias ll='ls -lF'
alias lla='ll -a'
alias tree='tree --dirsfirst'
alias gtree='git ls-files | tree --fromfile --dirsfirst'

# Listing dirs
alias dirs='dirs -v'

# Web search
alias q='_() { q=${1:-$(xsel -op)}; '$opener' "https://duckduckgo.com/?q=${q}"; }; _'

# Why not
alias :q='exit'
alias :e='$EDITOR'

# Git
alias g='git status'

# Read errors from stdin into a scratch buffer and load into quickfix list
alias quickfix='vim +"set bt=nofile" +cbuffer -'

# Open notes for editing
_complete_notes() {
    COMPREPLY=( $(compgen -W "$(ls ~/Dropbox/Documents/Notes/)" $2) )
}
complete -F _complete_notes note
alias note='_() { $EDITOR +"map q :wq<CR>" ~/Dropbox/Documents/Notes/$1 ; }; _'
alias t='$EDITOR +"map Q :wq<CR>" ~/Dropbox/Documents/Notes/tasks.taskpaper'

# Open
[[ $OSTYPE = linux* ]] && alias open='xdg-open'

# Syntax highlighting (no need for 'bat')
which highlight &>/dev/null && alias hi='highlight -O ansi --force'
which highlight &>/dev/null && alias hil='_() { highlight -O ansi --force $@ | less -R; }; _'

# ---------- Java Version ---------
[[ -z $JAVA_HOME && "$os" == linux && -x $(which java) ]] && JAVA_HOME=$(readlink -f $(which java) | sed "s:/bin/java::")

# -----------   COMPLETIONS   --------------
# [check for executable] && [ensure exists] && [source completions]
[ -d ~/.config/bash-completion ] || mkdir -p ~/.config/bash-completion

[ -r ~/.config/bash-completion/git ] || curl -sS https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > ~/.config/bash-completion/git
which cht.sh &>/dev/null && ([ -f ~/.config/bash-completion/cht.sh ] || cht.sh :bash_completion > ~/.config/bash-completion/cht.sh)
which kubectl &>/dev/null && ([ -f ~/.config/bash-completion/kubectl ] || kubectl completion bash > ~/.config/bash-completion/kubectl)
which minikube &>/dev/null && ([ -f ~/.config/bash-completion/minikube ] || minikube completion bash > ~/.config/bash-completion/minikube)
which helm &>/dev/null && ([ -f ~/.config/bash-completion/helm ] || helm completion bash > ~/.config/bash-completion/helm)

if [ -n "$(ls ~/.config/bash-completion/)" ]; then
    for file in ~/.config/bash-completion/*; do source "$file"; done
fi

[ -d "$HOME/.bloop" ] && source "$HOME/.bloop/bash/bloop"
which pyenv &>/dev/null && eval "$(pyenv init -)"

_complete_tmux() {
    COMPREPLY=( $(compgen -W "$(tmux list-commands -F#{command_list_name})" $2) )
}
complete -F _complete_tmux tmux


# ---------------------------------- PROMPT -----------------------------------
fancy_prompt=true
if $fancy_prompt; then
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

# export PROMPT_COMMAND="$HOME/.local/bin/bashbot"

# ----------------------------------- fff -------------------------------------
# Favourites (Bookmarks) (keys 1-9) (dir or file)
export FFF_FAV1=~/dev
export FFF_FAV2=~/Dropbox
export FFF_FAV3=~/Downloads
export FFF_FAV4=/usr/share
export FFF_FAV5=/etc
export FFF_FAV6=
export FFF_FAV7=~/.bash_aliases
export FFF_FAV8=~/.local/bin
export FFF_FAV9=~/dev/dotfiles/stow/nvim/.config/nvim/pack/external

# cd after exit
which fff &>/dev/null && alias f='_() {
    fff $@
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")"
    command -v tree &>/dev/null && tree -a --dirsfirst --filelimit 10 -L 1
}; _'

# ------------------------------- Directories ---------------------------------
alias gopacks='cd ~/dev/dotfiles/stow/nvim/.config/nvim/pack/external/opt'
alias mypacks='cd ~/dev/dotfiles/stow/nvim/.config/nvim/pack/personal/opt'
export CDPATH=~/.config:~/dev:~/dev/s2

# ---------------------------------- direnv -----------------------------------
which direnv &>/dev/null && eval "$(direnv hook bash)"

# --------------------------------- GREETING ----------------------------------
[[ ${PWD} == ${HOME} && ${os} == linux ]] && greeting
