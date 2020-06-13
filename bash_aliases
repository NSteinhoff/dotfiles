# vim: ft=sh
[ -n "$TMUX" ] || tmux attach -t default

# Disable <ctrl-s> suspending (reactivated with <ctrl-q>)
stty -ixon

# History
HISTSIZE=100000
HISTFILESIZE=200000

# Set Vim as default editor
which nvim &>/dev/null && export EDITOR=nvim || export EDITOR=vim

# Set Vim as man pager
# which nvim &>/dev/null && export MANPAGER='nvim +Man!'

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
alias :e='nvim'

# Open notes for editing
_complete_notes() {
    COMPREPLY=( $(compgen -W "$(ls ~/Dropbox/Documents/Notes/)" $2) )
}
complete -F _complete_notes note
alias note='_() { $EDITOR ~/Dropbox/Documents/Notes/$1 ; }; _'

# Open
[[ $OSTYPE = linux* ]] && alias open='xdg-open'

# Syntax highlighting (no need for 'bat')
which highlight &>/dev/null && alias hi='highlight -O ansi'
which highlight &>/dev/null && alias hil='_() { highlight -O ansi $@ | less -R; }; _'

# ---------- Java Version ---------
[[ -z $JAVA_HOME && "$os" == linux && -x $(which java) ]] && JAVA_HOME=$(readlink -f $(which java) | sed "s:/bin/java::")

# -----------   COMPLETIONS   --------------
# [check for executable] && [ensure exists] && [source completions]
[ -d ~/.config/bash-completion ] || mkdir -p ~/.config/bash-completion

which cht.sh &>/dev/null || (curl https://cht.sh/:cht.sh > ~/.local/bin/cht.sh && chmod +x ~/.local/bin/cht.sh)
which cht.sh &>/dev/null && ([ -f ~/.config/bash-completion/cht.sh ] || cht.sh :bash_completion > ~/.config/bash-completion/cht.sh)
which kubectl &>/dev/null && ([ -f ~/.config/bash-completion/kubectl ] || kubectl completion bash > ~/.config/bash-completion/kubectl)
which minikube &>/dev/null && ([ -f ~/.config/bash-completion/minikube ] || minikube completion bash > ~/.config/bash-completion/minikube)
which helm &>/dev/null && ([ -f ~/.config/bash-completion/helm ] || helm completion bash > ~/.config/bash-completion/helm)

for file in ~/.config/bash-completion/*; do source "$file"; done

[ -d "$HOME/.bloop" ] && source "$HOME/.bloop/bash/bloop"
which pyenv &>/dev/null && eval "$(pyenv init -)"


# ---------------------------------- PROMPT -----------------------------------
case "$TERM" in
xterm*|rxvt*|tmux*|screen*)
    PS1_tail='\$ '
    PS1_head="${PS1%'\$ '} "
    export PS1='$(tmux_indicator)'"$PS1_head"'$(git_branch_indicator)[\j]'"\n$PS1_tail"
    ;;
*)
    ;;
esac

export PROMPT_COMMAND="$HOME/.local/bin/bashbot"


# ----------------------------- Helper Functions ------------------------------
function_lib="$HOME/.local/lib/bash_functions"
[ -f "$function_lib" ] && source "$function_lib"


# --------------------------------- GREETING ----------------------------------
[[ ${PWD} == ${HOME} ]] && greeting
