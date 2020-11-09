export SHELL=/usr/local/bin/bash
source "$HOME/.bashrc"
export PATH="/usr/local/opt/make/libexec/gnubin:$PATH"

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

export PATH="$HOME/.cargo/bin:$PATH"
