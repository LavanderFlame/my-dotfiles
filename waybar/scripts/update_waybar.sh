#!/bin/bash

# List of themes
themes=("first" "random" "eh" "meh")

# Show menu in rofi
selected=$(printf '%s\n' "${themes[@]}" | rofi -dmenu -p "Choose a theme:")

# Exit if nothing selected
[ -z "$selected" ] && exit

echo "You selected: $selected"

# Copy config files based on selection
cp ~/.config/waybar/"$selected"/config.jsonc ~/.config/waybar/
cp ~/.config/waybar/"$selected"/style.css ~/.config/waybar/

# Restart Waybar to apply the new theme
pkill -x waybar
waybar & disown
