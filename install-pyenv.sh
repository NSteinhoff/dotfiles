#!/bin/bash
if [[ ! -d ~/.pyenv ]]; then
    echo "Installing Pyenv to ~/.pyenv"
    git clone https://github.com/pyenv/pyenv.git "~/.pyenv"
fi

echo "Installing Python dependencies"
apt-get build-dep python3.7
