# grendel-setup

Bootstrap scripts for Grendel AGI Raspberry Pi nodes. Run on a freshly flashed Pi to install everything needed for a given role.

## Quick Start

On a freshly flashed Pi:

```bash
git clone https://github.com/christopherrehm/grendel-setup.git
cd grendel-setup
chmod +x setup.sh scripts/*.sh
./setup.sh <role>
```

Roles: `brain` · `speaking` · `spare`

Then copy and fill in the `.env`:

```bash
cp templates/<role>.env ~/grendel2026/.env
nano ~/grendel2026/.env
```

## Nodes

| IP                | Role            | Pi Model | Script                |
| ----------------- | --------------- | -------- | --------------------- |
| 192.168.0.106     | Brain + Hearing | Pi 4B    | `./setup.sh brain`    |
| 192.168.0.101     | Speaking        | Pi 3B    | `./setup.sh speaking` |
| 192.168.0.105     | Spare (Trixie)  | —        | `./setup.sh spare`    |
| 192.168.0.102–104 | Spare           | Pi 2B    | `./setup.sh spare`    |

## SSH Mesh

After all nodes are flashed and `setup.sh` has been run on each:

```bash
# Run from your laptop
bash scripts/distribute_keys.sh
```

This collects every node's pubkey and pushes it to all others — every node can then SSH to every other node as `chris` without a password.

## What Each Script Does

**base.sh** (runs on all roles)

- `apt upgrade`
- Installs `git`, `python3-venv`, `python3-pip`
- Creates `~/tmp` for pip installs (RPi `/tmp` tmpfs is too small for torch)
- Clones or updates `grendel2026` repo

**brain.sh**

- Installs `portaudio19-dev`, `pulseaudio`
- Creates and installs `brain/venv` and `hearing/venv`
- Copies `brain.env` template if `.env` is missing

**speaking.sh**

- Installs `espeak-ng`
- Creates and installs `speaking/venv`
- Copies `speaking.env` template if `.env` is missing

## Support

If you find this useful, a small donation helps keep projects like this going:
[Donate via PayPal](https://paypal.me/christopherrehm001)
