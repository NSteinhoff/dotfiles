# vim: ft=sh

# Disable <ctrl-s> suspending (reactivated with <ctrl-q>)
stty -ixon

# History
HISTSIZE=100000
HISTFILESIZE=200000
HISTCONTROL=ignorespace:ignoredups:erasedups

shopt -s histappend
shopt -s histverify

# Prefer local binaries
export PATH="$HOME/.local/bin:$PATH"

export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
export CDPATH=.:~/Develop # include the explicit '.' to support bash < 4.2

##########
### Prompt
prompttype=fancy
case $prompttype in
    starship) eval "$(starship init bash)" ;;
       fancy) eval "$(make-bash-prompt)" ;;
       basic) PS1="\[\e[1;34m\]\w\[\e[1;32m\]\n\j:\$\[\e[m\] " ;;
esac

function has() {
    command -v "$1" &>/dev/null
}

function hasdirectory() {
    [[ -n "$1" ]] && [[ -d "$1" ]]
}

# Set Vim/NeoVim as default editor
export EDITOR="$(has nvim && echo nvim || echo vim)"

case $OSTYPE in
    linux*) os="linux";;
    darwin*) os="mac";;
esac

# --------------------------------------------------------------------------- #
#                                   Aliases                                   #
# --------------------------------------------------------------------------- #
alias v='NVIM_APPNAME=v nvim'
alias yot='toggle-light-dark'
alias mdv='based-markdown-viewer --open'

###########
### History
alias h='history'
alias hg='history | grep '

################
### Safer delete
alias rm='rm -i'

#################
### Listing
# Listing files
if [[ $os == linux ]]; then
    alias ls='ls --color=auto --group-directories-first'
elif [[ $os == mac ]]; then
    alias ls='ls -G'
fi
alias l='ls -CF'
alias la='l -A'
alias ll='ls -lFh'
alias lla='ll -A'
if has tree; then
    alias tree='tree -CF --dirsfirst --gitignore'
fi
# Listing ports
alias lsop='_() { lsof -i -nP $@ | grep LISTEN; }; _'
# Listing my IP on local network
alias lsip='_() { ifconfig | grep "inet " | grep -v 127.0.0.1 | grep "broadcast" | cut -d " " -f2 ; }; _'

###################
### Grep with color
alias grep='grep --color=auto'

##############
### Web search
[[ os == linux ]] && opener=xdg-open || opener=open
_search_web() {
    local name="$1"; shift
    local engine_url="$1"; shift
    local query="$1"; shift
    if [[ -z "$name" ]] || [[ -z "$engine_url" ]]; then echo "Invalid number of arguments"; return 1; fi
    if [[ -z "$query" ]]; then echo "usage: $name <query>"; return 1; fi
    $opener "${engine_url}${query}"
}
q()   { _search_web "${FUNCNAME[0]}" "https://duckduckgo.com/?q="                    "$1"; }
mdn() { _search_web "${FUNCNAME[0]}" "https://developer.mozilla.org/en-US/search?q=" "$1"; }
ai()  { $opener "https://duckduckgo.com/?q=DuckDuckGo+AI+Chat&ia=chat&duckai=1"; }

###########
### Why not
alias :q='exit'
alias :e='$EDITOR'
alias :split='tmux split-window'
alias :vsplit='tmux split-window -h'
alias :tsplit='tmux new-window'

#########
### Debug
alias dbg='lldb --batch --one-line run -- '

#######
### Git
if has git; then
    _git_branches() {
        git status &>/dev/null || return 1
        echo $(git branch --sort=-committerdate --format="%(refname:strip=2)" | grep -v "HEAD detached")
    }

    _complete_branches() { COMPREPLY=( $(compgen -W "$(_git_branches)" $2) ); }

    _git_switch_select_branch() {
        if (( $# > 0 )); then
            git switch $@
            return
        fi

        git status || return 1
        echo -e "\nSwitch to branch:"
        local branches
        branches=$(_git_branches) || return 1
        select branch in $branches; do break; done
        [[ -n "$branch" ]] || return 1
        git switch "$branch"
    }

    alias g='git status'
    alias gl='git lo'
    alias gd='git diff'
    alias g-='git switch -'
    alias gg='_git_switch_select_branch'
    complete -F _complete_branches gg
fi

########
### Tmux
# t     List sessions or execute tmux commands
# tn    Create a new session named after the directory
# tt    Attach to a session
if has tmux; then
    _tmux_ls_or_cmd() {
        if (( $# == 0 )); then
            tmux ls
        else
            tmux $@
        fi
    }
    _tmux_new_session() {
        if (( $# == 0 )); then
            tmux new -s "$(basename $PWD)"
        else
            tmux new -s "$1"
        fi
    }
    _tmux_smart_attach() {
        if (( $# == 0 )); then
            tmux attach
        else
            tmux attach -t $@
        fi
    }

    alias t='_tmux_ls_or_cmd'
    alias tn='_tmux_new_session'
    alias tt='_tmux_smart_attach'
    alias tm='tmuxinator start --suppress-tmux-version-warning=on'
fi

########
### Dirs
alias d='dirs'
alias p='pushd'
alias pp='popd'
# Go forwards and backwards
alias o='pushd +1'
alias i='pushd -0'

###############
### Note-Taking
if has nvim; then
    # Read errors from stdin into a scratch buffer and load into quickfix list
    alias quickfix='nvim +"set bt=nofile" +cbuffer -'

    export NOTES_DIR=~/Dropbox/Notes
    export ZETTELKASTEN=~/Dropbox/Zettel
    alias note='_() { $EDITOR --cmd "cd $NOTES_DIR" $NOTES_DIR/$1 ; }; _'
    complete -F _complete_notes note
    _complete_notes() { COMPREPLY=( $(compgen -W "$(ls $NOTES_DIR)" $2) ); }
    alias today='note "Daily/$(date +"%Y-%m-%d.md")"'
    alias yesterday='note "Daily/$(date -v-1d +"%Y-%m-%d.md")"'
    alias tomorrow='note "Daily/$(date -v+1d +"%Y-%m-%d.md")"'
    alias journal='nvim +Journal!'
    alias todo='nvim +Todo!'
    alias zettel='_() { nvim "+Zettel $*"; }; _'
fi

########
### Open
[[ $OSTYPE = linux* ]] && alias open='xdg-open'

#######################
### Syntax highlighting (no need for 'bat')
alias hi='highlight -O ansi --force'
alias hil='_() { highlight -O ansi --force $@ | less -R; }; _'

###############
### COMPLETIONS
[ -d ~/.config/bash-completion ] || mkdir -p ~/.config/bash-completion
[ -r ~/.config/bash-completion/git ] || curl -sS https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > ~/.config/bash-completion/git
[ -r ~/.config/bash-completion/tmuxinator ] || curl -sS https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.bash > ~/.config/bash-completion/tmuxinator
[ -r ~/.config/bash-completion/pandoc ] || pandoc --bash-completion > ~/.config/bash-completion/pandoc

# Source all completions
if [ -n "$(ls ~/.config/bash-completion/)" ]; then
    for file in ~/.config/bash-completion/*; do source "$file"; done
fi

# TMUX completions
if has tmux; then
    complete -F _complete_tmux tmux t
    _complete_tmux() { COMPREPLY=( $(compgen -W "$(tmux list-commands -F#{command_list_name})" $2) ); }

    complete -F _complete_tmux_sessions tt
    _complete_tmux_sessions() { COMPREPLY=( $(compgen -W "$(tmux ls -F '#S')" $2) ); }

    complete -F _complete_tmuxinator_projects tm
    _complete_tmuxinator_projects() { COMPREPLY=( $(compgen -W "$(tmuxinator completions start)" $2) ); }
fi

# Colorschem completions (Alacritty)
complete -F _complete_colorscheme colorscheme
_complete_colorscheme() { COMPREPLY=( $(compgen -W "$(colorscheme -l)" $2) ); }


#####################
### Pandoc CSS Styles
export PANDOC_CSS="$HOME/.local/styles/markdown.css"

###########
### Go Path
# I don't like go/ cluttering up my home directory
export GOPATH="$HOME/.local/opt/go"

#####################
### Directory Browser
has based-navigate && eval "$(based-navigate --setup-shell)"

##############
### AWS awsume
alias awsume=". awsume"

############
### BASH Bot
# export PROMPT_COMMAND="bashbot;$PROMPT_COMMAND"
