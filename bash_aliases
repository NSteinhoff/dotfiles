# vim: ft=sh
# Disable <ctrl-s> suspending (reactivated with <ctrl-q>)
stty -ixon

# History
HISTSIZE=100000
HISTFILESIZE=200000

# Set Vim as default editor
export EDITOR=vim

# Set Vim as man pager
[ -n "$(which nvim)" ] && export MANPAGER='nvim +Man!'

case $OSTYPE in
    linux*) os="linux";;
    darwin*) os="mac";;
esac

# ----------------------------- Helper Functions ------------------------------
function_lib="$HOME/.local/lib/bash_functions"
if [ -f "$function_lib" ]; then
    source "$function_lib"
fi

# --------- Listing files ------------
[ $os = "linux" ] && alias ls='ls --color=auto --group-directories-first'
[ $os = "mac" ] && alias ls='ls -G'
alias ll='ls -lF'
alias lla='ll -a'
alias tree='tree --dirsfirst'
alias gtree='git ls-files | tree --fromfile --dirsfirst'

# --------- Listing dirs ------------
alias dirs='dirs -v'

# ---------- Java Version ---------
if [[ -z $JAVA_HOME ]]; then
    if [[ "$os" == linux && -x $(which java) ]]; then
        export JAVA_HOME=$(readlink -f $(which java) | sed "s:/bin/java::")
    fi
fi

# -----------   COMPLETIONS   --------------
[ -d ~/.config/bash-completion ] || mkdir -p ~/.config/bash-completion
if [ -z "$(which cht.sh)" ]; then
    echo "Installing cht.sh"
    curl https://cht.sh/:cht.sh > ~/.local/bin/cht.sh
    chmod +x ~/.local/bin/cht.sh
fi
if [ -n "$(which cht.sh)" ]; then
    [ -f ~/.config/bash-completion/cht.sh ] || cht.sh :bash_completion > ~/.config/bash-completion/cht.sh
    source ~/.config/bash-completion/cht.sh
fi

# ----------- Kubectl && Minikube completion ----------
if [ -n "$(which kubectl)" ]; then
    [ -f ~/.config/bash-completion/kubectl ] || kubectl completion bash > ~/.config/bash-completion/kubectl
    source ~/.config/bash-completion/kubectl
fi
if [ -n "$(which minikube)" ]; then
    [ -f ~/.config/bash-completion/minikube ] || minikube completion bash > ~/.config/bash-completion/minikube
    source ~/.config/bash-completion/minikube
fi
if [ -n "$(which helm)" ]; then
    [ -f ~/.config/bash-completion/helm ] || helm completion bash > ~/.config/bash-completion/helm
    source ~/.config/bash-completion/helm
fi

# ------------- Bloop --------------
[ -d "$HOME/.bloop" ] && source "$HOME/.bloop/bash/bloop"

# ---------------------------------- Pyenv ------------------------------------
[ -n "$(which pyenv)" ] && eval "$(pyenv init -)"



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

export PROMPT_COMMAND="$HOME/.local/bin/prompt_command"


# --------------------------------- GREETING ----------------------------------
greeting
