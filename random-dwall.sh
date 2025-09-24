#!/bin/bash
# random-dwall.sh - openSUSE Tumbleweed KDE Plasma 6 (Wayland)

set -euo pipefail

BASE="$HOME/Pictures/images"
STATE="$HOME/.random-dwall-state"
TODAY=$(date +%F)

# Pick today's theme
if [[ ! -f "$STATE" ]] || ! read -r SAVED_DATE THEME < "$STATE" || [[ "$SAVED_DATE" != "$TODAY" ]]; then
    if [[ ! -d "$BASE" ]] || [[ -z "$(ls -A "$BASE" 2>/dev/null)" ]]; then
        echo "ERROR: No themes in $BASE" >&2
        exit 1
    fi
    THEME=$(ls "$BASE" | shuf -n1)
    echo "$TODAY $THEME" > "$STATE"
fi

HOUR=$(date +%-H)
IMAGE="$BASE/$THEME/$HOUR.jpg"

if [[ ! -f "$IMAGE" ]]; then
    echo "WARN: Image not found: $IMAGE" >&2
    exit 0
fi

# ✅ Use qdbus6 for Plasma 6
qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
    var allDesktops = desktops();
    for (let i = 0; i < allDesktops.length; i++) {
        let d = allDesktops[i];
        d.wallpaperPlugin = 'org.kde.image';
        d.currentConfigGroup = ['Wallpaper', 'org.kde.image', 'General'];
        d.writeConfig('Image', 'file://$IMAGE');
    }
"
