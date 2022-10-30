#!/usr/bin/env bash

# https://github.com/pyenv/pyenv


if [ $(which git) ]; then
    git clone https://github.com/pyenv/pyenv.git $HOME/bin/pyenv
    echo 'export PYENV_ROOT="$HOME/bin/pyenv"' >> $HOME/.profile
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> $HOME/.profile
    echo 'eval "$(pyenv init -)"' >> $HOME/.profile
else
    echo "Git not found." && exit 2
fi