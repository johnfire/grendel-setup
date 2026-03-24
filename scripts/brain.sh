#!/usr/bin/env bash
# Brain + Hearing node setup (RPi 4B — .106)

info "Setting up brain + hearing node..."

# system packages
sudo apt install -y portaudio19-dev pulseaudio

# brain venv
info "Installing brain venv..."
if [[ ! -d "$GRENDEL_DIR/brain/venv" ]]; then
    python3 -m venv "$GRENDEL_DIR/brain/venv"
fi
TMPDIR="$HOME/tmp" "$GRENDEL_DIR/brain/venv/bin/pip" install --upgrade pip -q
TMPDIR="$HOME/tmp" "$GRENDEL_DIR/brain/venv/bin/pip" install -r "$GRENDEL_DIR/brain/requirements.txt"

# hearing venv
info "Installing hearing venv (this takes a while — torch + whisper)..."
if [[ ! -d "$GRENDEL_DIR/hearing/venv" ]]; then
    python3 -m venv "$GRENDEL_DIR/hearing/venv"
fi
TMPDIR="$HOME/tmp" "$GRENDEL_DIR/hearing/venv/bin/pip" install --upgrade pip -q
TMPDIR="$HOME/tmp" "$GRENDEL_DIR/hearing/venv/bin/pip" install -r "$GRENDEL_DIR/hearing/requirements.txt"

# .env
if [[ ! -f "$GRENDEL_DIR/.env" ]]; then
    warn ".env not found — copying template. Fill in secrets before starting services."
    cp "$SETUP_DIR/templates/brain.env" "$GRENDEL_DIR/.env"
else
    info ".env already exists, skipping."
fi

info "Brain + hearing node setup done."
