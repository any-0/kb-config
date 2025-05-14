#!/usr/bin/env bash
set -euo pipefail

VARIANT="colemak_dh_iso"

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y console-data kbd console-setup

ARCH=$(dpkg --print-architecture)
KM_DIR="/usr/share/keymaps/$ARCH"
[[ -d "$KM_DIR" ]] || KM_DIR="/usr/share/keymaps/i386"

DEST="$KM_DIR/colemak"
mkdir -p "$DEST"

ckbcomp -layout us -variant "$VARIANT" | gzip > "$DEST/${VARIANT}.kmap.gz"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cp "$SCRIPT_DIR/keyboard" /etc/default/keyboard

update-initramfs -u -k all

loadkeys "colemak/${VARIANT}.kmap.gz"

echo "✅ Colemak-DH (ISO) installed & loaded."

rm -rf "$SCRIPT_DIR"
