#!/usr/bin/env bash
#
#  Author: Hari Sekhon
#  Date: early 2019
#
#  https://github.com/harisekhon/devops-bash-tools
#
#  License: see accompanying LICENSE file
#
#  https://www.linkedin.com/in/harisekhon
#

# Installs MiniKube on Mac - needs VirtualBox to be installed first

#set -euo pipefail
set -u

#[ -n "${DEBUG:-}" ] &&
set -x

srcdir="$(dirname "$0")"

if [ "$(uname -s)" = Darwin ]; then
    if ! command -v minikube &>/dev/null; then
        if ! command -v brew &>/dev/null; then
            echo "HomeBrew needs to be installed first, trying to install now"
            "$srcdir/install_homebrew.sh"
        fi
        brew update
        brew cask install minikube
        brew install docker-machine-driver-xhyve
    fi
    brew_prefix="$(brew --prefix)"
    sudo chown root:wheel "$brew_prefix"/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
    sudo chmod u+s "$brew_prefix"/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
    if ! minikube status | grep -i started; then
        minikube start
    fi
else
    echo "Only Mac is supported at this time"
    exit 1
fi