# vim: ft=sh

# Disable <ctrl-s> suspending (reactivated with <ctrl-q>)
stty -ixon

# History
HISTSIZE=100000
HISTFILESIZE=200000

# Prefer local binaries
export PATH="$HOME/.local/bin:$PATH"

shopt -s histappend
shopt -s histverify

# Set Vim as default editor
which nvim &>/dev/null && export EDITOR=nvim || export EDITOR=vim
# which nvim &>/dev/null && export MANPAGER='nvim +Man!'

case $OSTYPE in
    linux*) os="linux";;
    darwin*) os="mac";;
esac

# --------------------------------------------------------------------------- #
#                                   Aliases                                   #
# --------------------------------------------------------------------------- #
################
### Safer delete
alias rm='rm -i'

#################
### Listing
# Listing files
[ $os = "linux" ] && alias ls='ls --color=auto --group-directories-first'
[ $os = "mac" ] && alias ls='ls -G'
alias l='ls -CF'
alias la='l -A'
alias ll='ls -lFh'
alias lla='ll -A'
alias tree='tree -CF --dirsfirst --gitignore'

# Listing ports
alias lsop='_() { lsof -i -nP $@ | grep LISTEN; }; _'

# Find my IP on local network
alias lip='_() { ifconfig | grep "inet " | grep -v 127.0.0.1 | grep "broadcast" | cut -d " " -f2 ; }; _'

###################
### Grep with color
alias grep='grep --color=auto'

##############
### Web search
[[ os == linux ]] && opener=xdg-open || opener=open
alias q='_() { q="${@:1}"; '$opener' "https://duckduckgo.com/?q=${q}"; }; _'

###########
### Why not
alias :q='exit'
alias :e='$EDITOR'

#######
### Git
alias g='git status'
alias g-='git switch -'
alias gg='g && echo "git switch ..." \
    && select branch in $(git branch --format="%(refname:strip=2)" | grep -v "HEAD detached"); do break; done \
    && [ -n "$branch" ] \
    && git switch "$branch" \
    || echo "Okay then..."'

########
### Tmux
# t     List sessions or execute tmux commands
# tn    Create a new session named after the directory
# tt    Attach to a session
tmux_ls_or_cmd() {
    if (( $# == 0 )); then
        tmux ls
    else
        tmux $@
    fi
}
tmux_new_session_in_dir() {
    if (( $# == 0 )); then
        tmux new -s "$(basename $PWD)"
    else
        tmux new -s "$(basename $1)" -c $1
    fi
}
tmux_smart_attach() {
    if (( $# == 0 )); then
        tmux attach
    else
        tmux attach -t $@
    fi
}

alias t='tmux_ls_or_cmd'
alias tn='tmux_new_session_in_dir'
alias tt='tmux_smart_attach'
complete -F _complete_tmux t
complete -d tn
complete -F _complete_tt tt
_complete_tt() { COMPREPLY=( $(compgen -W "$(tmux ls -F '#S')" $2) ); }

########
### Dirs
alias d='dirs'
alias p='pushd'
alias pp='popd'
# Go forwards and backwards
alias o='pushd +1'
alias i='pushd -0'

# Read errors from stdin into a scratch buffer and load into quickfix list
alias quickfix='vim +"set bt=nofile" +cbuffer -'

###############
### Note-Taking
alias note='_() { $EDITOR --cmd "cd $NOTES_DIR" $NOTES_DIR/$1 ; }; _'
complete -F _complete_notes note
_complete_notes() { COMPREPLY=( $(compgen -W "$(ls $NOTES_DIR)" $2) ); }
alias journal='nvim +Journal!'
alias todo='nvim +Todo!'
alias zettel='_() { nvim "+Zettel $*"; }; _'

########
### Open
[[ $OSTYPE = linux* ]] && alias open='xdg-open'

#######################
### Syntax highlighting
### (no need for 'bat')
alias hi='highlight -O ansi --force'
alias hil='_() { highlight -O ansi --force $@ | less -R; }; _'


# ---------- Java Version ---------
[[ -z $JAVA_HOME && "$os" == linux && -x $(which java) ]] && JAVA_HOME=$(readlink -f $(which java) | sed "s:/bin/java::")

# -----------   COMPLETIONS   --------------
# [check for executable] && [ensure exists] && [source completions]
[ -d ~/.config/bash-completion ] || mkdir -p ~/.config/bash-completion
[ -r ~/.config/bash-completion/git ] || curl -sS https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > ~/.config/bash-completion/git
[ -r ~/.config/bash-completion/tmuxinator ] || curl -sS https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.bash > ~/.config/bash-completion/tmuxinator
[ -r ~/.config/bash-completion/pandoc ] || pandoc --bash-completion > ~/.config/bash-completion/pandoc

if [ -n "$(ls ~/.config/bash-completion/)" ]; then
    for file in ~/.config/bash-completion/*; do source "$file"; done
fi

_complete_tmux() {
    COMPREPLY=( $(compgen -W "$(tmux list-commands -F#{command_list_name})" $2) )
}
complete -F _complete_tmux tmux

_complete_colorscheme() {
    COMPREPLY=( $(compgen -W "$(colorscheme -l)" $2) )
}
complete -F _complete_colorscheme colorscheme

# ---------------------------------- PROMPT -----------------------------------
starship_prompt=false
fancy_prompt=true
if $starship_prompt && (which starship &>/dev/null); then
    eval "$(starship init bash)"
elif $fancy_prompt; then
    case "$TERM" in
    xterm*|rxvt*|tmux*|screen*|alacritty*)
        PS1='$(tmux-prompt)\[\033[1;34m\]\w\[\033[m\]$(git-prompt)\n\j:\[\033[1;32m\]\$\[\033[m\] '
        ;;
    *)
        ;;
    esac
fi

# --------------------------- Directory Shortcuts -----------------------------
export CDPATH=.:~/Develop # include the explicit '.' to support bash < 4.2
export NOTES_DIR=~/Dropbox/Notes
export ZETTELKASTEN=~/Dropbox/Zettel

# --------------------------- C Compilation ---------------------------------
# export CC=clang
# export CFLAGS="${CFLAGS:+${CFLAGS} }-Wall -Werror -Wextra -pedantic -Weverything -Wno-declaration-after-statement -Wno-strict-prototypes -Wno-shadow -Wno-padded"
# export LDFLAGS="${LDFLAGS:+${LDFLAGS} }"
# export LDLIBS="${LDLIBS:+${LDLIBS} }"

# ---------------------------- Pandoc CSS Styles ------------------------------
export PANDOC_CSS="$HOME/.local/styles/markdown.css"

export PROMPT_COMMAND=bashbot
# --------------------------------- Go Path -----------------------------------
# I don't like go/ cluttering up my home directory
export GOPATH="$HOME/.local/opt/go"
