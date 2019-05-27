# Disable <ctrl-s> suspending (reactivated with <ctrl-q>)
stty -ixon

# Set Vim as default editor
export EDITOR=vim

# --------- Listing files ------------
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lF'
alias lla='ll -a'
alias tree='tree --dirsfirst'

# --------- Listing dirs ------------
alias dirs='dirs -v'

# --------- Open files with vim -------
alias Vim='_() { if [ $# -gt 0 ]; then vim --servername VIM --remote-silent "$@"; else vim --servername VIM; fi }; _'
alias vimfind='_() { find $1 -name $2 -exec vim {} +; }; _'
alias vimrefind='_() { find $1 -regex $2 -exec vim {} +; }; _'

# --------- Read Man pages with Vim -------
alias vman='_() { vim -c "r !man $1" -c "setlocal buftype=nofile bufhidden=hide noswapfile"; }; _'

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

# ----------- Kubectl && Minikube completion ----------
[ -n "$(which kubectl)" ] && source <(kubectl completion bash)
[ -n "$(which minikube)" ] && source <(minikube completion bash)
[ -n "$(which helm)" ] && source <(helm completion bash)

# ------------ Exercism ----------
if [ -f ~/.config/exercism/exercism_completion.bash ]; then
    source ~/.config/exercism/exercism_completion.bash
fi


# ------------   PROMPT   -----------
function git_unstaged_changes {
    [ -n "$(git diff --shortstat 2> /dev/null | tail -n1)" ]
}

function git_uncommitted_changes {
    [ -n "$(git diff --shortstat --staged 2> /dev/null | tail -n1)" ]
}

function branch_name {
    git rev-parse --abbrev-ref HEAD
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

# Indicate ranger subshell
[ -n "$RANGER_LEVEL" ] && PS1="$PS1"'(in ranger) '

export PS1
