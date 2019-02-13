# Disable <ctrl-s> suspending (reactivated with <ctrl-q>)
stty -ixon

# Set Vim as default editor
export EDITOR=vim

alias ls='ls --color=auto --group-directories-first'

# Make 'rm' ask for confirmation every time
# Use '\rm' if you know what you are doing
alias rm='rm -i'


# Returns "*" if the current git branch is dirty.
function evil_git_dirty {
  [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]] && echo "*"
}

parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1'"$(evil_git_dirty)"']/'
}
export PS1="${PS1:0:((${#PS1} - 3))}"'$(parse_git_branch)\$ '

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

if [ -f ~/.config/exercism/exercism_completion.bash ]; then
    source ~/.config/exercism/exercism_completion.bash
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

# --------- Open files with vim -------
alias vimfind='_() { find $1 -name $2 -exec vim {} +; }; _'
alias vimrefind='_() { find $1 -regex $2 -exec vim {} +; }; _'
