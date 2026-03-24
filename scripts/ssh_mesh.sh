#!/usr/bin/env bash
# SSH mesh setup — enables passwordless SSH between all Grendel nodes
#
# Nodes in the mesh:
#   brain    192.168.0.106
#   speaking 192.168.0.101
#   spare1   192.168.0.102
#   spare2   192.168.0.103
#   spare3   192.168.0.104
#   hearing  192.168.0.105 (Trixie, already current)

MESH_NODES=(
    "192.168.0.101"
    "192.168.0.102"
    "192.168.0.103"
    "192.168.0.104"
    "192.168.0.105"
    "192.168.0.106"
)

info "Setting up SSH mesh..."

# generate key if not present
if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
    info "Generating SSH keypair..."
    ssh-keygen -t ed25519 -N "" -f "$HOME/.ssh/id_ed25519"
fi

LOCAL_PUBKEY="$(cat "$HOME/.ssh/id_ed25519.pub")"
info "Local pubkey: $LOCAL_PUBKEY"

# add known_hosts entries to avoid first-connect prompts
for node in "${MESH_NODES[@]}"; do
    ssh-keyscan -H "$node" >> "$HOME/.ssh/known_hosts" 2>/dev/null || true
done
sort -u "$HOME/.ssh/known_hosts" -o "$HOME/.ssh/known_hosts"

info "SSH mesh keypair ready."
info ""
info "To complete the mesh, run this from your laptop:"
info "  bash <path-to-grendel-setup>/scripts/distribute_keys.sh"
info ""
info "Or manually add this node's pubkey to all other nodes:"
info "  $LOCAL_PUBKEY"
