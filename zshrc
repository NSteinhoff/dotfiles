# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.


# Detect OS ##################################################################
case $(uname) in
    'Linux')
        OS='Linux'
        ;;
    'FreeBSD')
        OS='FreeBSD'
        ;;
    'WindowsNT')
        OS='Windows'
        ;;
    'Darwin')
        OS='Mac'
        ;;
    'SunOS')
        OS='Solaris'
        ;;
    'AIX')
        ;;
    *)
        OS=$(uname)
        ;;
esac
##############################################################################


# THEMES #####################################################################
# ZSH_THEME="robbyrussell"
# ZSH_THEME="terminalparty"
if [[ $USER == "gpred" ]]; then
    ZSH_THEME="ys"
elif [[ $USER == "nas" ]]; then
    ZSH_THEME="terminalparty"
else
    ZSH_THEME="gallois"
fi
##############################################################################

# GIT CONFIG #################################################################
if [[ $USER == "gpred" ]] || [[ $USER == "nas" ]]; then
    export GIT_AUTHOR_NAME="Niko Steinhoff"
    export GIT_AUTHOR_EMAIL="nas@gpredictive.de"
    export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
    export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
fi
##############################################################################

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git brew pip python sbt scala tmuxinator)

# User configuration

# export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_MONETARY=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export LC_COLLATE=C

#Preferred editor for local and remote sessions
export EDITOR='vim'
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Vi mode
bindkey -v
export KEYTIMEOUT=1

# Aliases
alias tree='tree -C -F'
alias scalafmt="scalafmt --config ${HOME}/.scalafmt.conf"
if [[ $OS == 'Linux' ]]; then
    alias ll='ls -lhF --group-directories-first'
elif [[ $OS == 'Mac' ]]; then
    alias ll='ls -lhF'
fi
#
export XDG_CONFIG_HOME=~/.config

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
#
# You may add following to ~/.bash_profile to ease starting/stopping kafka
# START of .bash_profile changes for Kafka and ES
export KF_HOME="/opt/kafka/current"
export ES_HOME="/opt/elasticsearch-2.4.3"
alias kstart="nohup ${KF_HOME}/bin/kafka-server-start.sh ${KF_HOME}/config/server.properties > /var/log/kafka.log 2>&1 &"
alias kstop="${KF_HOME}/bin/kafka-server-stop.sh"
alias zkstop="${KF_HOME}/bin/zookeeper-server-stop.sh"
alias zkstart="nohup ${KF_HOME}/bin/zookeeper-server-start.sh ${KF_HOME}/config/zookeeper.properties > /var/log/zookeeper.log 2>&1 &"
alias estart="nohup ${ES_HOME}/bin/elasticsearch > /var/log/elasticsearch.log 2>&1 &"
alias estop="if [[ ! -z \$(es_proc_id) ]] ; then kill -TERM \$(es_proc_id); else echo 'No ES process is running.'; fi"

function es_proc_id() {
   jps | grep Elasticsearch | awk '{print $1}'
}
# END .bash_profile changes for Kafka and ES

# Configure sbt memory settings to avoid OutofMemory error.
export SBT_OPTS="-Xmx4G -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -Xss2M"
