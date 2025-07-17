# --------------------------------------------------------------------------- #
#                                 Environment                                 #
# --------------------------------------------------------------------------- #
export LANG="en_US.UTF-8"

# --------------------------------- Homebrew ----------------------------------
# Prefer brewed executables over builtins
export PATH=/opt/homebrew/bin:$PATH
export PATH="${HOMEBREW_PREFIX}/opt/openssl/bin:$PATH"

# ----------------------------------- ASDF ------------------------------------
# Prefer ASDF shims over brewed stuff
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Setup Bash completions
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# ---------------------------------- Cargo ------------------------------------
# Setup cargo environment
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# ----------------------------------- Go --------------------------------------
# Setup Go environment
export PATH="$HOME/go/bin:$PATH"

# ----------------------------------- GPG -------------------------------------
# Inform GPG about the current terminal device
export GPG_TTY=$(tty)

# --------------------------- C Compilation ---------------------------------
# Use clang provided by brewed LLVM
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# Use clang as the C compiler
export CC=clang

# Use brewed headers and libraries
export PKG_CONFIG_PATH="/opt/homebrew/opt/ncurses/lib/pkgconfig"
# export CFLAGS="-I/opt/homebrew/include -I/opt/homebrew/opt/llvm/include"
# export LDFLAGS="-L/opt/homebrew/lib -L/opt/homebrew/opt/llvm/lib -Wl,-rpath,/opt/homebrew/opt/llvm/lib"
# export LDLIBS=
#
# ---------------------------------- Docker -----------------------------------
export DOCKER_HOST="unix://$HOME/.colima/docker.sock"

# --------------------------------------------------------------------------- #
#                                  ~/.bashrc                                  #
# --------------------------------------------------------------------------- #
. "$HOME/.bashrc"
