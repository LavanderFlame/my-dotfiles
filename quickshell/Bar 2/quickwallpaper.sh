#!/usr/bin/env bash
set -e

# -----------------------------
# INPUT FROM QML
# -----------------------------
wallpaper="$1"

if [[ -z "$wallpaper" || ! -f "$wallpaper" ]]; then
    echo "Invalid wallpaper path"
    exit 1
fi

ext="${wallpaper##*.}"

# -----------------------------
# STOP OLD VIDEO WALLPAPERS
# -----------------------------
pkill -f mpvpaper 2>/dev/null || true

# -----------------------------
# SET WALLPAPER
# -----------------------------
case "$ext" in
    mp4|webm|mkv)
        nohup mpvpaper -o "--loop --no-audio" ALL "$wallpaper" \
            >/dev/null 2>&1 &
        ;;
    *)
        swww img "$wallpaper" --transition-type any
        ;;
esac

# -----------------------------
# GENERATE PYWAL COLORS
# -----------------------------
wal -i "$wallpaper" -n

# -----------------------------
# ROFI STYLE (style-2)
# -----------------------------
cat > "$HOME/.config/rofi/type-7/style-2.rasi" <<EOF
@import "$HOME/.cache/wal/colors-rofi-dark.rasi"

configuration {
    modi: "drun,run,filebrowser,window";
    show-icons: true;
}

* {
    font: "JetBrains Mono Nerd Font 10";
    background-alt: @selected-normal-background;
}

imagebox {
    background-image: url("$wallpaper", height);
}
EOF

# -----------------------------
# SIMPLE ROFI THEMES
# -----------------------------
for theme in simple simple2; do
cat > "$HOME/.config/rofi/type-7/$theme.rasi" <<EOF
@import "$HOME/.cache/wal/colors-rofi-dark.rasi"

* {
    font: "JetBrains Mono Nerd Font 10";
    background-alt: @selected-normal-background;
}
EOF
done

# -----------------------------
# HYPRLOCK
# -----------------------------
cat > "$HOME/.config/hypr/hyprlock.conf" <<EOF
background {
    path = $wallpaper
    blur_passes = 1
}

source = $HOME/.cache/wal/colors-hyprland.conf
EOF

# -----------------------------
# COPY GENERATED FILES
# -----------------------------
cp -f "$HOME/.cache/wal/gtk-colors.css" "$HOME/.config/gtk-4.0/"
cp -f "$HOME/.cache/wal/gtk-colors.css" "$HOME/.config/gtk-3.0/"
cp -f "$HOME/.cache/wal/midnight-discord.css" \
      "$HOME/.config/vesktop/themes/midnight-discord.css"
cp -f "$HOME/.cache/wal/myconfig.omp.json" \
      "$HOME/.config/oh-my-posh/"
cp -f "$HOME/.cache/wal/colors-waybar.css" \
      "$HOME/.config/waybar/"

# -----------------------------
# RESTART SERVICES
# -----------------------------
pkill vesktop || true
pkill swayosd-server || true
sleep 0.1
swayosd-server & disown

pkill dunst || true
dunst -config "$HOME/.cache/wal/dunstrc" & disown

pkill waybar || true
waybar & disown

# -----------------------------
# NOTIFY
# -----------------------------
notify-send "Wallpaper Changed" "Colors updated to match $(basename "$wallpaper")"
