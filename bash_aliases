# vim: ft=sh
# Disable <ctrl-s> suspending (reactivated with <ctrl-q>)
stty -ixon

# History
HISTSIZE=100000
HISTFILESIZE=200000

# Set Vim as default editor
export EDITOR=vim

# Set Vim as man pager
# which nvim &>/dev/null && export MANPAGER='nvim +Man!'

case $OSTYPE in
    linux*) os="linux";;
    darwin*) os="mac";;
esac

# -----------------------------------------------------------------------------
#  ALIASES
# -----------------------------------------------------------------------------

# Listing files
[ $os = "linux" ] && alias ls='ls --color=auto --group-directories-first'
[ $os = "mac" ] && alias ls='ls -G'
alias ll='ls -lF'
alias lla='ll -a'
alias tree='tree --dirsfirst'
alias gtree='git ls-files | tree --fromfile --dirsfirst'

# Listing dirs
alias dirs='dirs -v'

# Syntax highlighting (no need for 'bat')
which highlight &>/dev/null && alias hi='highlight -O ansi'

# ---------- Java Version ---------
[[ -z $JAVA_HOME && "$os" == linux && -x $(which java) ]] && JAVA_HOME=$(readlink -f $(which java) | sed "s:/bin/java::")

# -----------   COMPLETIONS   --------------
# [check for executable] && [ensure exists] && [source completions]
[ -d ~/.config/bash-completion ] || mkdir -p ~/.config/bash-completion
which cht.sh &>/dev/null || (curl https://cht.sh/:cht.sh > ~/.local/bin/cht.sh && chmod +x ~/.local/bin/cht.sh)
which cht.sh &>/dev/null && ([ -f ~/.config/bash-completion/cht.sh ] || cht.sh :bash_completion > ~/.config/bash-completion/cht.sh) && source ~/.config/bash-completion/cht.sh
which kubectl &>/dev/null && ([ -f ~/.config/bash-completion/kubectl ] || kubectl completion bash > ~/.config/bash-completion/kubectl) && source ~/.config/bash-completion/kubectl
which minikube &>/dev/null && ([ -f ~/.config/bash-completion/minikube ] || minikube completion bash > ~/.config/bash-completion/minikube) && source ~/.config/bash-completion/minikube
which helm &>/dev/null && ([ -f ~/.config/bash-completion/helm ] || helm completion bash > ~/.config/bash-completion/helm) && source ~/.config/bash-completion/helm
[ -d "$HOME/.bloop" ] && source "$HOME/.bloop/bash/bloop"
which pyenv &>/dev/null && eval "$(pyenv init -)"


# ---------------------------------- PROMPT -----------------------------------
case "$TERM" in
xterm*|rxvt*)
    PS1_tail='\$ '
    PS1_head="${PS1%'\$ '} "
    export PS1="$PS1_head"'$(git_branch_indicator)[\j]'"\n$PS1_tail"
    ;;
*)
    ;;
esac

export PROMPT_COMMAND="$HOME/.local/bin/bashbot"


# ----------------------------- Helper Functions ------------------------------
function_lib="$HOME/.local/lib/bash_functions"
[ -f "$function_lib" ] && source "$function_lib"


# ----------------------------- Docker Aliases ------------------------------
alias docker-here='docker run -it --rm --user "$(id -u):$(id -g)" -v "$PWD:$PWD" -w "$PWD"'


# --------------------------------- GREETING ----------------------------------
greeting
