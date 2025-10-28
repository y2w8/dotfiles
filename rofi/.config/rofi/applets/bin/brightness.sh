#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Brightness

# Import Current Theme
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"
selected_row=0
show_rofi() {
	# Brightness Info
	backlight="$(printf "%.0f\n" $(brightnessctl get))"
	backlight_percentage=$(($backlight * 100 / $(brightnessctl max)))
	card="$(brightnessctl --list | grep 'backlight' | head -n1)"

	if [[ $backlight_percentage -ge 0 ]] && [[ $backlight_percentage -le 29 ]]; then
		level="Low"
	elif [[ $backlight_percentage -ge 30 ]] && [[ $backlight_percentage -le 49 ]]; then
		level="Optimal"
	elif [[ $backlight_percentage -ge 50 ]] && [[ $backlight_percentage -le 69 ]]; then
		level="High"
	elif [[ $backlight_percentage -ge 70 ]] && [[ $backlight_percentage -le 100 ]]; then
		level="Peak"
	fi

	# Theme Elements
	prompt="${backlight_percentage}%"
	mesg="Device: ${card}, Level: $level"

	if [[ "$theme" == *'type-1'* ]]; then
		list_col='1'
		list_row='4'
		win_width='400px'
	elif [[ "$theme" == *'type-3'* ]]; then
		list_col='1'
		list_row='4'
		win_width='120px'
	elif [[ "$theme" == *'type-5'* ]]; then
		list_col='1'
		list_row='4'
		win_width='425px'
	elif [[ ("$theme" == *'type-2'*) || ("$theme" == *'type-4'*) ]]; then
		list_col='4'
		list_row='1'
		win_width='550px'
	fi
	layout=$(cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2)
	if [[ "$layout" == 'NO' ]]; then
		option_1=" Increase"
		option_2=" Optimal"
		option_3=" Decrease"
		option_4=" Settings"
	else
		option_1=""
		option_2=""
		option_3=""
		option_4=""
	fi
}
rofi_cmd() {
	rofi -theme-str "window {width: $win_width;}" \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-sync \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme} \
		-selected-row $selected_row \
		-no-auto-select \
		-no-custom \
		-normal-window
}
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4" | rofi_cmd
}
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		brightnessctl set +5%
	elif [[ "$1" == '--opt2' ]]; then
		brightnessctl set 25%
	elif [[ "$1" == '--opt3' ]]; then
		brightnessctl set 10%-
	elif [[ "$1" == '--opt4' ]]; then
		systemsettings kcm_kscreen
	fi
}
# Main Loop
while true; do
	show_rofi
	chosen="$(run_rofi)"
	if [[ $? -ne 0 ]]; then
		break # Exit if Escape was pressed
	fi
	case $chosen in
	$option_1)
		run_cmd --opt1 # Increase
		selected_row=0
		;;
	$option_2)
		run_cmd --opt2 # Optimal (set to 25%)
		selected_row=1
		;;
	$option_3)
		run_cmd --opt3 # Decrease
		selected_row=2
		;;
	$option_4)
		run_cmd --opt4 # Settings
		selected_row=3
		break
		;;
	"^[")
		break # Exit
		;;
	esac
done
