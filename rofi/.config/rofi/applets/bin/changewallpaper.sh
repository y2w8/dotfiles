#!/usr/bin/env bash

WALLPAPER_DIR="${HOME}/Documents/wallpapers/fav"
theme="${HOME}/.config/rofi/applets/type-1/style-5.rasi"
if ! command -v qdbus &>/dev/null; then
	echo "Error: qdbus is not installed or not in PATH."
	exit 1
fi

WALLPAPER_CHOICE=$(find "$WALLPAPER_DIR" -maxdepth 1 \
	-type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) \
	-exec basename {} \; | rofi -dmenu -i -p "Wallpaper:" -window-title "RofiWallpaperPicker" -theme ${theme} -normal-window)

if [[ -n "$WALLPAPER_CHOICE" ]]; then
	FILE_PATH="${WALLPAPER_DIR}/${WALLPAPER_CHOICE}"

	WALLPAPER_URI="file://${FILE_PATH}"

	qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
        var allDesktops = desktops();
        for (var i = 0; i < allDesktops.length; i++) {
            desktop = allDesktops[i];
            desktop.wallpaperPlugin = 'a2n.blur';
            desktop.currentConfigGroup = Array('Wallpaper', 'a2n.blur', 'General');
            desktop.writeConfig('Image', '$WALLPAPER_URI');
        }"

	echo "Wallpaper set to: ${WALLPAPER_CHOICE}"
fi
