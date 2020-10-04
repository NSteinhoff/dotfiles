# vim: ft=sh

# Disable <ctrl-s> suspending (reactivated with <ctrl-q>)
stty -ixon

# History
HISTSIZE=100000
HISTFILESIZE=200000

# Set Vim as default editor
export EDITOR=vim

case $OSTYPE in
    linux*) os="linux";;
    darwin*) os="mac";;
esac

# -----------------------------------------------------------------------------
#  ALIASES
# -----------------------------------------------------------------------------

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
alias q='_() { q=${1:-$(xsel -op)}; xdg-open "https://duckduckgo.com/?q=${q}"; }; _'

# Why not
alias :q='exit'
alias :e='$EDITOR'

# Read errors from stdin into a scratch buffer and load into quickfix list
alias quickfix='vim +"set bt=nofile" +cbuffer -'

# Open notes for editing
_complete_notes() {
    COMPREPLY=( $(compgen -W "$(ls ~/Dropbox/Documents/Notes/)" $2) )
}
complete -F _complete_notes note
alias note='_() { $EDITOR +"map q :wq<CR>" ~/Dropbox/Documents/Notes/$1 ; }; _'
alias t='$EDITOR +"map q :wq<CR>" ~/Dropbox/Documents/Notes/tasks.taskpaper'

# Open
[[ $OSTYPE = linux* ]] && alias open='xdg-open'

# Syntax highlighting (no need for 'bat')
which -s highlight && alias hi='highlight -O ansi --force'
which -s highlight && alias hil='_() { highlight -O ansi --force $@ | less -R; }; _'

# ---------- Java Version ---------
[[ -z $JAVA_HOME && "$os" == linux && -x $(which java) ]] && JAVA_HOME=$(readlink -f $(which java) | sed "s:/bin/java::")

# -----------   COMPLETIONS   --------------
# [check for executable] && [ensure exists] && [source completions]
[ -d ~/.config/bash-completion ] || mkdir -p ~/.config/bash-completion

which -s cht.sh && ([ -f ~/.config/bash-completion/cht.sh ] || cht.sh :bash_completion > ~/.config/bash-completion/cht.sh)
which -s kubectl && ([ -f ~/.config/bash-completion/kubectl ] || kubectl completion bash > ~/.config/bash-completion/kubectl)
which -s minikube && ([ -f ~/.config/bash-completion/minikube ] || minikube completion bash > ~/.config/bash-completion/minikube)
which -s helm && ([ -f ~/.config/bash-completion/helm ] || helm completion bash > ~/.config/bash-completion/helm)

if [ -n "$(ls ~/.config/bash-completion/)" ]; then
    for file in ~/.config/bash-completion/*; do source "$file"; done
fi

[ -d "$HOME/.bloop" ] && source "$HOME/.bloop/bash/bloop"
which -s pyenv && eval "$(pyenv init -)"

_complete_tmux() {
    COMPREPLY=( $(compgen -W "$(tmux list-commands -F#{command_list_name})" $2) )
}
complete -F _complete_tmux tmux


# ---------------------------------- PROMPT -----------------------------------
case "$TERM" in
xterm*|rxvt*|tmux*|screen*)
    PS1_tail='\$ '
    PS1_head="${PS1%'\$ '} "
    [[ $PS1 == *git-prompt* ]] || export PS1='$(tmux-prompt)'"$PS1_head"'$(git-prompt)[\j]'"\n$PS1_tail"
    ;;
*)
    ;;
esac

export PROMPT_COMMAND="$HOME/.local/bin/bashbot"

# ----------------------------------- fff -------------------------------------
# Favourites (Bookmarks) (keys 1-9) (dir or file)
export FFF_FAV1=~/Development
export FFF_FAV2=~/Dropbox
export FFF_FAV3=~/Downloads
export FFF_FAV4=/usr/share
export FFF_FAV5=/etc
export FFF_FAV6=
export FFF_FAV7=~/.bash_aliases
export FFF_FAV8=~/.local/bin
export FFF_FAV9=~/dotfiles

# cd after exit
command -v fff &>/dev/null && alias f='_() {
    fff $@
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")"
    command -v tree &>/dev/null && tree -a --dirsfirst --filelimit 10 -L 1
}; _'

# --------------------------------- TMUXIFY -----------------------------------
tmuxify() {
    # If tmux is installed, we attach each new shell to a tmux session
    #
    # single
    #     One option is to attach all terminals to the same session, in which
    #     case tmux is used for all window / pane management.
    #
    # integrated
    #     Another option is to attach each terminal to its own session, and
    #     use the OS window manager for handling windows and tiling.
    #     Here, tmux is pretty much in 'stealth' mode really only used
    #     for the copy mode, i.e. terminal:session:window:pane 1:1:1:1
    [ -x $(which tmux) ] || return 1

    local tmux_mode=${1:-undefined}
    local tmux_cmd
    case $tmux_mode in
        integrated)
            tmux_cmd="tmux new-session"
            ;;
        single)
            tmux_cmd="tmux new-session -A -s default"
            ;;
        *)
            echo invalid tmux mode \'$tmux_mode\'
            return 1
            ;;
    esac

    [ -n "$TMUX" ] || exec $tmux_cmd
}
false && tmuxify integrated

# --------------------------------- GREETING ----------------------------------
[[ ${PWD} == ${HOME} && ${os} == linux ]] && greeting
