#!/usr/bin/env bash
# Run from your laptop AFTER all Pis are flashed and reachable.
# Collects every node's pubkey and pushes it to all other nodes.
# Result: every node can SSH to every other node without a password.

set -euo pipefail

MESH_NODES=(
    "pi@192.168.0.102"
    "pi@192.168.0.103"
    "pi@192.168.0.104"
    "pi@192.168.0.105"
    "pi@192.168.0.106"
)

SSH_OPTS="-o StrictHostKeyChecking=no -o ConnectTimeout=10"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()  { echo -e "${GREEN}[mesh]${NC} $*"; }
warn()  { echo -e "${YELLOW}[warn]${NC} $*"; }
error() { echo -e "${RED}[error]${NC} $*"; }

# check all nodes are reachable first
info "Checking all nodes are reachable..."
REACHABLE=()
for node in "${MESH_NODES[@]}"; do
    if ssh $SSH_OPTS "$node" "echo ok" &>/dev/null; then
        REACHABLE+=("$node")
        info "  ✓ $node"
    else
        warn "  ✗ $node — unreachable, skipping"
    fi
done

# collect pubkeys from all reachable nodes
info "Collecting pubkeys..."
ALL_KEYS=""
for node in "${REACHABLE[@]}"; do
    key=$(ssh $SSH_OPTS "$node" "cat ~/.ssh/id_ed25519.pub 2>/dev/null || echo ''")
    if [[ -n "$key" ]]; then
        ALL_KEYS+="$key"$'\n'
        info "  got key from $node"
    else
        warn "  no key on $node — run setup.sh first"
    fi
done

if [[ -z "$ALL_KEYS" ]]; then
    error "No keys collected. Run setup.sh on each node first."
    exit 1
fi

# also include laptop's own key
LAPTOP_KEY="$(cat ~/.ssh/id_ed25519.pub 2>/dev/null || cat ~/.ssh/id_rsa.pub 2>/dev/null || echo '')"
if [[ -n "$LAPTOP_KEY" ]]; then
    ALL_KEYS+="$LAPTOP_KEY"$'\n'
fi

# push all keys to all reachable nodes
info "Distributing keys to all nodes..."
for node in "${REACHABLE[@]}"; do
    ssh $SSH_OPTS "$node" "
        mkdir -p ~/.ssh
        chmod 700 ~/.ssh
        touch ~/.ssh/authorized_keys
        chmod 600 ~/.ssh/authorized_keys
    "
    echo "$ALL_KEYS" | ssh $SSH_OPTS "$node" "
        while IFS= read -r key; do
            [[ -z \"\$key\" ]] && continue
            grep -qF \"\$key\" ~/.ssh/authorized_keys 2>/dev/null || echo \"\$key\" >> ~/.ssh/authorized_keys
        done
    "
    info "  ✓ keys pushed to $node"
done

info ""
info "Mesh complete. All nodes can now SSH to each other as chris."
info "Test with: ssh chris@192.168.0.101 hostname"
