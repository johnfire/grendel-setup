#!/usr/bin/env bash
# Common base setup for all Grendel nodes

info "Running base setup..."

# system update
sudo apt update -qq
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -q

# common packages
sudo apt install -y git python3-venv python3-pip

# pip install dir — /tmp tmpfs is too small for torch wheels on RPi
mkdir -p "$HOME/tmp"

# clone grendel repo if not present
if [[ ! -d "$GRENDEL_DIR" ]]; then
    info "Cloning grendel2026..."
    git clone "$REPO_URL" "$GRENDEL_DIR"
else
    info "grendel2026 already cloned, pulling latest..."
    git -C "$GRENDEL_DIR" pull
fi

info "Base setup done."
