#!/usr/bin/env bash
# Speaking node setup (RPi 3B — .101)

info "Setting up speaking node..."

# system packages
sudo apt install -y espeak-ng

# speaking venv
info "Installing speaking venv..."
if [[ ! -d "$GRENDEL_DIR/speaking/venv" ]]; then
    python3 -m venv "$GRENDEL_DIR/speaking/venv"
fi
TMPDIR="$HOME/tmp" "$GRENDEL_DIR/speaking/venv/bin/pip" install --upgrade pip -q
TMPDIR="$HOME/tmp" "$GRENDEL_DIR/speaking/venv/bin/pip" install -r "$GRENDEL_DIR/speaking/requirements.txt"

# .env
if [[ ! -f "$GRENDEL_DIR/.env" ]]; then
    warn ".env not found — copying template. Fill in secrets before starting services."
    cp "$SETUP_DIR/templates/speaking.env" "$GRENDEL_DIR/.env"
else
    info ".env already exists, skipping."
fi

info "Speaking node setup done."
