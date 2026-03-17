#!/bin/bash

# Clamshell mode: manage laptop screen on lid open/close
# Only disables eDP-1 if an external monitor is connected

LAPTOP="eDP-1"
MONITORS_CONF="$HOME/.config/hypr/monitors.conf"
HYPRLOCK_CONF="$HOME/.config/hypr/hyprlock.conf"

has_external_monitor() {
    hyprctl monitors -j | python3 -c "
import sys, json
monitors = json.load(sys.stdin)
sys.exit(0 if any(m['name'] != '$LAPTOP' for m in monitors) else 1)
"
}

external_monitor() {
    hyprctl monitors -j | python3 -c "
import sys, json
monitors = json.load(sys.stdin)
ext = [m['name'] for m in monitors if m['name'] != '$LAPTOP']
print(ext[0]) if ext else sys.exit(1)
"
}

case "$1" in
    close)
        EXT=$(external_monitor) || exit 0

        # Move workspaces off laptop screen to the external monitor
        for ws in $(hyprctl workspaces -j | python3 -c "
import sys, json
[print(w['id']) for w in json.load(sys.stdin) if w['monitor'] == '$LAPTOP']
"); do
            hyprctl dispatch moveworkspacetomonitor "$ws" "$EXT"
        done

        hyprctl keyword monitor "$LAPTOP, disable"
        sed -i 's/fingerprint:enabled = true/fingerprint:enabled = false/' "$HYPRLOCK_CONF"
        ;;
    open)
        hyprctl keyword monitor "$LAPTOP, preferred, auto, auto"
        sed -i 's/fingerprint:enabled = false/fingerprint:enabled = true/' "$HYPRLOCK_CONF"
        ;;
esac
