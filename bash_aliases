# Disable <ctrl-s> suspending (reactivated with <ctrl-q>)
stty -ixon

# Set Vim as default editor
export EDITOR=vim
alias ls='ls --color=auto --group-directories-first'

alias ls='ls --color=auto --group-directories-first'

# --------- Open files with vim -------
alias vimfind='_() { find $1 -name $2 -exec vim {} +; }; _'
alias vimrefind='_() { find $1 -regex $2 -exec vim {} +; }; _'

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

# --------- Pyenv ----------
if [[ -d ~/.pyenv && -d ~/.pyenv/bin ]]; then
    export PATH="$(python -m site --user-base)/bin:$PATH"
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    source "$PYENV_ROOT/completions/pyenv.bash"
    if command -v pyenv 1>/dev/null 2>&1; then
        eval "$(pyenv init -)"
    fi
fi


# -----------   COMPLETIONS   --------------

# ----------- Kubectl && Minikube completion ----------
[ -n $(which kubectl) ] && source <(kubectl completion bash)
[ -n $(which minikube) ] && source <(minikube completion bash)

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
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function remote_branch {
    remote=$(git rev-parse --abbrev-ref --symbolic-full-name @{u}) && echo "$remote" || echo ""
}

function branch_status {
    ahead=$(git status | sed '/ahead/!d')
    behind=$(git status | sed '/behind/!d')
    diverged=$(git status | sed '/diverged/!d')

    if [ -n "$diverged" ]; then
        echo "Y"
    elif [ -n "$ahead" ]; then
        echo "+"
    elif [ -n "$behind" ]; then
        echo "-"
    else
        echo "*"
    fi
}

git_branch_indicator() {
    branch=$(branch_name)
    [ -n "$branch" ] || exit 0

    remote=$(remote_branch)
    if [ -n $remote ]; then
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

    echo -e "[${COLOR}${branch}${NC}${remote_indicator}]"
}

export PS1="${PS1:0:((${#PS1} - 3))}"'$(git_branch_indicator)\$ '

