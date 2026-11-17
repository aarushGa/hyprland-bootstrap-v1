#!/usr/bin/env bash
set -Eeuo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

mkdir -p "$DOTFILES_DIR/config" "$DOTFILES_DIR/home"

configs=(
  hypr waybar rofi dunst mako wlogout hyprlock cava kitty starship Thunar
  fastfetch btop eww gtk-3.0 gtk-4.0 hypr-session kwybars fontconfig
  nwg-look xsettingsd xfce4 conky
)

for name in "${configs[@]}"; do
  source="$CONFIG_DIR/$name"
  [[ -e "$source" ]] || continue
  mkdir -p "$DOTFILES_DIR/config/$name"
  rsync -a --delete \
    --exclude='*.save' --exclude='*.bak' --exclude='*.tmp' \
    --exclude='*.swp' --exclude='*.swo' --exclude='*~' \
    "$source/" "$DOTFILES_DIR/config/$name/"
done

mkdir -p "$DOTFILES_DIR/config-files" "$DOTFILES_DIR/home/.local/bin" \
  "$DOTFILES_DIR/assets/wallpapers" "$DOTFILES_DIR/assets/themes" \
  "$DOTFILES_DIR/assets/icons" "$DOTFILES_DIR/assets/fonts" "$DOTFILES_DIR/packages"

for name in starship.toml gtkrc mimeapps.list; do
  [[ -f "$CONFIG_DIR/$name" ]] || continue
  install -m 0644 "$CONFIG_DIR/$name" "$DOTFILES_DIR/config-files/$name"
done

for name in .bashrc .bash_profile .bash_logout .gtkrc-2.0 .fonts.conf; do
  [[ -f "$HOME/$name" ]] || continue
  if [[ "$name" == .bashrc ]]; then
    # Never store an inline API key in this public/shareable configuration repo.
    sed -E '/^[[:space:]]*export[[:space:]]+GEMINI_API_KEY=/c\# Set GEMINI_API_KEY in your environment or a private shell file.' \
      "$HOME/$name" > "$DOTFILES_DIR/home/$name"
  else
    install -m 0644 "$HOME/$name" "$DOTFILES_DIR/home/$name"
  fi
done

for name in hypr-session hypr-session-tray; do
  [[ -f "$HOME/.local/bin/$name" ]] || continue
  install -m 0755 "$HOME/.local/bin/$name" "$DOTFILES_DIR/home/.local/bin/$name"
done

# These files are directly referenced by the saved Hyprland and Hyprlock configs.
for name in arch.png live5.mp4 hyprlock.jpg; do
  [[ -f "$HOME/Downloads/wallpapers/$name" ]] || continue
  install -m 0644 "$HOME/Downloads/wallpapers/$name" "$DOTFILES_DIR/assets/wallpapers/$name"
done

if [[ -d "$HOME/.themes/Graphite-Dark" ]]; then
  rsync -a --delete --exclude='*.cache' "$HOME/.themes/Graphite-Dark/" \
    "$DOTFILES_DIR/assets/themes/Graphite-Dark/"
fi
if [[ -d "$HOME/.local/share/icons/Reversal" ]]; then
  rsync -a --delete --exclude='icon-theme.cache' "$HOME/.local/share/icons/Reversal/" \
    "$DOTFILES_DIR/assets/icons/Reversal/"
fi
if [[ -d "$HOME/.local/share/fonts" ]]; then
  find "$HOME/.local/share/fonts" -maxdepth 1 -type f \
    \( -iname '*.ttf' -o -iname '*.otf' -o -iname '*.woff' -o -iname '*.woff2' \) \
    -exec install -m 0644 -t "$DOTFILES_DIR/assets/fonts" {} +
fi

if command -v pacman >/dev/null 2>&1; then
  pacman -Qqe | sort -u > "$DOTFILES_DIR/packages/pacman-explicit.txt"
  pacman -Qqm | sort -u > "$DOTFILES_DIR/packages/pacman-foreign.txt"
fi
if command -v flatpak >/dev/null 2>&1; then
  flatpak list --app --columns=application 2>/dev/null | sort -u > "$DOTFILES_DIR/packages/flatpak-apps.txt" || true
fi
if command -v systemctl >/dev/null 2>&1; then
  systemctl --user list-unit-files --state=enabled --no-legend 2>/dev/null \
    | awk '{print $1}' | sort -u > "$DOTFILES_DIR/packages/enabled-user-units.txt" || true
fi

printf 'Backed up configuration files to %s\n' "$DOTFILES_DIR"
