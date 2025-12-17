# --------------------------------------------------------------------------- #
#                                 Environment                                 #
# --------------------------------------------------------------------------- #
export LANG="en_US.UTF-8"

# --------------------------------- Homebrew ----------------------------------
if command -v brew &>/dev/null; then
    brewed="$(brew --prefix)"

    # Prefer brewed executables over builtins
    export PATH="${brewed}/bin:$PATH"
    export PATH="${brewed}/opt/openssl/bin:$PATH"

    # Setup Bash completions
    if [[ -r "${brewed}/etc/profile.d/bash_completion.sh" ]]; then
        source "${brewed}/etc/profile.d/bash_completion.sh"
    fi

    # Use clang provided by brewed LLVM
    export PATH="${brewed}/opt/llvm/bin:$PATH"
    # Use brewed headers and libraries
    export PKG_CONFIG_PATH="${brewed}/opt/ncurses/lib/pkgconfig"
    # export CFLAGS="-I${brewed}/include -I${brewed}/opt/llvm/include"
    # export LDFLAGS="-L${brewed}/lib -L${brewed}/opt/llvm/lib -Wl,-rpath,${brewed}/opt/llvm/lib"
    # export LDLIBS=

    if [[ -x "${brewed}/bin/bash" ]]; then
        export SHELL="${brewed}/bin/bash"
    fi
fi

# ----------------------------------- ASDF ------------------------------------
# Prefer ASDF shims over brewed stuff
if command -v asdf &>/dev/null; then
    export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fi

# ---------------------------------- Cargo ------------------------------------
# Setup cargo environment
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# ----------------------------------- Go --------------------------------------
# Setup Go environment
if command -v go &>/dev/null; then
    export PATH="$HOME/.local/opt/go/bin:$PATH"
fi

# ----------------------------------- GPG -------------------------------------
# Inform GPG about the current terminal device
export GPG_TTY=$(tty)

# ---------------------------------- Docker -----------------------------------
if command -v colima &>/dev/null; then
    export DOCKER_HOST="unix://$HOME/.colima/docker.sock"
fi

# ---------------------------------- Dotnet -----------------------------------
if command -v dotnet &>/dev/null; then
    export PATH="$HOME/.dotnet/tools:$PATH"
fi

# --------------------------------------------------------------------------- #
#                                  ~/.bashrc                                  #
# --------------------------------------------------------------------------- #
. "$HOME/.bashrc"
