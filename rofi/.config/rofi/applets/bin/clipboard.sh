#!/usr/bin/env bash

theme="${HOME}/.config/rofi/applets/type-1/style-5.rasi"
if ! command -v cliphist &>/dev/null; then
    echo "Error: cliphist is not installed or not in PATH."
    exit 1
fi

if ! command -v wl-copy &>/dev/null; then
    echo "Error: wl-copy is not installed or not in PATH."
    exit 1
fi

CHOICE=$(cliphist list | rofi -dmenu -i -p "Clipboard:" -window-title "Clipboard" -theme ${theme} -normal-window -display-columns 2)

if [[ -n "$CHOICE" ]]; then
    cliphist decode <<< "$CHOICE" | wl-copy
    echo "Copied to clipboard."
fi
