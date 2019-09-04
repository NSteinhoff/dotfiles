# Disable <ctrl-s> suspending (reactivated with <ctrl-q>)
stty -ixon

# History
HISTSIZE=100000
HISTFILESIZE=200000

# Set Vim as default editor
export EDITOR=vim

# Set Vim as man pager
# export MANPAGER="vim -M +MANPAGER -"

# --------- Listing files ------------
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lF'
alias lla='ll -a'
alias tree='tree --dirsfirst'

# --------- Listing dirs ------------
alias dirs='dirs -v'

# --------- Open files with vim -------
gvim_() {
    running=$(vim --serverlist | grep GVIM)
    if [[ $# -gt 0 ]]; then
        gvim --remote-silent $@
    elif [[ -z "$running" ]]; then
        gvim
    else
        echo "Server 'GVIM' already running."
    fi
}
alias gvim=gvim_
alias vim-find='_() { find $1 -name $2 -exec vim {} +; }; _'
alias vim-find-re='_() { find $1 -regex $2 -exec vim {} +; }; _'

# --------- Open files with Zathura
alias zathura-find='_() { find $1 -name $2 | xargs zathura &}; _'
alias zathura-find-re='_() { find $1 -regex $2 | xargs zathura & }; _'

# --------- Take a new new with Vim -------
alias vnote="vim -c 'r!date' -c 'normal i# ' -c 'normal o' ~/notes.md"

# Make 'rm' ask for confirmation every time
# Use '\rm' if you know what you are doing
alias rm='rm -i'

# Git branch indicator with colors
NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'

# ------------   PATHS   -------------

# ------------ Brew ----------
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
# eval $($(brew --prefix)/bin/brew shellenv)


# ------------ Snap ----------
[ -n $(which snap) ] && export PATH="/snap/bin/:$PATH"
# Add personal scripts to the path
if [[ -d ~/dotfiles/bin ]]; then
    export PATH="$HOME/dotfiles/bin:$PATH"
fi

# ---------- Java Version ---------
if [[ -z $JAVA_HOME ]]; then
    if [[ -x $(which java) ]]; then
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

# ------------ Exercism ----------
[ -f ~/.config/exercism/exercism_completion.bash ] && source ~/.config/exercism/exercism_completion.bash

# ------------- Bloop --------------
[ -d "$HOME/.bloop" ] && source "$HOME/.bloop/bash/bloop"


# ------------   PROMPT   -----------
function git_unstaged_changes {
    [ -n "$(git diff --shortstat 2> /dev/null | tail -n1)" ]
}

function git_uncommitted_changes {
    [ -n "$(git diff --shortstat --staged 2> /dev/null | tail -n1)" ]
}

function branch_name {
    # git rev-parse --abbrev-ref HEAD 2> /dev/null
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function remote_branch {
    remote=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null) && echo -n "$remote" || echo -n ""
}

function branch_status {
    ahead=$(git status | sed '/ahead/!d')
    behind=$(git status | sed '/behind/!d')
    diverged=$(git status | sed '/diverged/!d')

    if [ -n "$diverged" ]; then
        echo -n "Y"
    elif [ -n "$ahead" ]; then
        echo -n "+"
    elif [ -n "$behind" ]; then
        echo -n "-"
    else
        echo -n "*"
    fi
}

git_branch_indicator() {
    branch=$(branch_name)
    [ -n "$branch" ] || exit 0

    remote=$(remote_branch)
    if [ -n "$remote" ]; then
        remote_name="${remote#*/}"
        status="$(branch_status)"
        if [ "$remote_name" = "$branch" ]; then
            remote_indicator="->$status"
        else
            remote_indicator="->$remote$status"
        fi
    else
        remote_indicator=''
    fi

    if $(git_unstaged_changes); then
        COLOR="${RED}"
    elif $(git_uncommitted_changes); then
        COLOR="${ORANGE}"
    else
        COLOR="${GREEN}"
    fi

    echo -n "["
    echo -en "\001${COLOR}\002"
    echo -n "${branch}"
    echo -en "\001${NC}\002"
    echo -n "${remote_indicator}"
    echo -n "]"
}

PS1="${PS1:0:((${#PS1} - 3))}"'$(git_branch_indicator)\$ '
# PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\\\$ "'
# GIT_PS1_SHOWDIRTYSTATE="yes"
# GIT_PS1_SHOWUPSTREAM="auto"

# Indicate ranger subshell
[ -n "$RANGER_LEVEL" ] && PS1="$PS1"'(in ranger) '

export PS1

# Launch tmux automatically
if [ -z $TMUX ] && which tmux > /dev/null; then
    if [ -z $TMUX ] && [ -z $VIM_TERMINAL ] ; then
        (tmux ls > /dev/null 2>&1 && tmux attach) || tmux
    fi
fi
