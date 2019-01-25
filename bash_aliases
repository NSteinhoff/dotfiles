# Disable <ctrl-s> suspending (reactivated with <ctrl-q>)
stty -ixon

# Set Vim as default editor
export EDITOR=vim

alias ls='ls --color=auto --group-directories-first'

# Make 'rm' ask for confirmation every time
# Use '\rm' if you know what you are doing
alias rm='rm -i'

# ---------- Java Version ---------
if [[ -z $JAVA_HOME ]]; then
    if [[ -x $(which java) ]]; then
        export JAVA_HOME=$(readlink -f $(which java) | sed "s:/bin/java::")
    fi
fi

if [ -f ~/.config/exercism/exercism_completion.bash ]; then
    source ~/.config/exercism/exercism_completion.bash
fi
