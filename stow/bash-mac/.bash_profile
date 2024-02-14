# --------------------------------------------------------------------------- #
#                                 Environment                                 #
# --------------------------------------------------------------------------- #
export LANG="en_US.UTF-8"

# --------------------------------- Homebrew ----------------------------------
# Prefer brewed executables
export PATH=/opt/homebrew/bin:$PATH

# Setup Bash completions
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# ----------------------------------- ASDF ------------------------------------
# Setup ASDF environment
. /opt/homebrew/opt/asdf/libexec/asdf.sh
. /opt/homebrew/opt/asdf/etc/bash_completion.d/asdf.bash

# ---------------------------------- Cargo ------------------------------------
# Setup cargo environment
. "$HOME/.cargo/env"

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
# export CFLAGS="-I/opt/homebrew/include -I/opt/homebrew/opt/llvm/include"
# export LDFLAGS="-L/opt/homebrew/lib -L/opt/homebrew/opt/llvm/lib -Wl,-rpath,/opt/homebrew/opt/llvm/lib"
# export LDLIBS=
# --------------------------------------------------------------------------- #
#                                  ~/.bashrc                                  #
# --------------------------------------------------------------------------- #
. "$HOME/.bashrc"
