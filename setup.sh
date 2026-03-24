#!/usr/bin/env bash
# Grendel node setup — run on a freshly flashed Raspberry Pi
# Usage: ./setup.sh <role>
# Roles: brain, speaking, spare
# Example: ./setup.sh brain

set -euo pipefail

ROLE="${1:-}"
REPO_URL="https://github.com/johnfire/grendel2026.git"
GRENDEL_DIR="$HOME/grendel2026"
SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()    { echo -e "${GREEN}[setup]${NC} $*"; }
warn()    { echo -e "${YELLOW}[warn]${NC}  $*"; }
error()   { echo -e "${RED}[error]${NC} $*"; exit 1; }

[[ -z "$ROLE" ]] && error "Usage: $0 <brain|speaking|spare>"
[[ "$ROLE" =~ ^(brain|speaking|spare)$ ]] || error "Unknown role: $ROLE"

info "Setting up node as: $ROLE"

# ── base ──────────────────────────────────────────────────────────────────────
source "$SETUP_DIR/scripts/base.sh"

# ── role-specific ─────────────────────────────────────────────────────────────
source "$SETUP_DIR/scripts/$ROLE.sh"

# ── ssh mesh ──────────────────────────────────────────────────────────────────
source "$SETUP_DIR/scripts/ssh_mesh.sh"

info "Setup complete for role: $ROLE"
info "Next: copy .env to $GRENDEL_DIR/.env (see templates/$ROLE.env)"
