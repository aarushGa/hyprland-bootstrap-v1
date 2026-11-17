#!/usr/bin/env bash
set -Eeuo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d-%H%M%S)"

if ! command -v pacman >/dev/null 2>&1; then
  printf 'This installer supports Arch Linux with pacman and yay.\n' >&2
  exit 1
fi

packages=(
  hyprland waybar rofi dunst mako wlogout hyprlock cava kitty starship thunar
  hyprsession hyprshot hyprpolkitagent mpvpaper-rs swaybg swayosd blueman
  pipewire pipewire-pulse wireplumber networkmanager power-profiles-daemon
  brightnessctl playerctl jq fontconfig nwg-look ttf-jetbrains-mono-nerd
  noto-fonts noto-fonts-emoji ttf-fira-sans breeze-icons breeze-cursors oxygen-cursors
)
case "${1:-}" in
  "") ;;
  --all-packages)
    manifest="$DOTFILES_DIR/packages/pacman-explicit.txt"
    if [[ ! -f "$manifest" ]]; then
      printf 'Package manifest is missing: %s\n' "$manifest" >&2
      exit 1
    fi
    mapfile -t packages < "$manifest"
    ;;
  -h|--help)
    printf 'Usage: %s [--all-packages]\n' "${0##*/}"
    printf '  default         Install the core desktop package set.\n'
    printf '  --all-packages  Install every package in packages/pacman-explicit.txt.\n'
    exit 0
    ;;
  *)
    printf 'Unknown option: %s\nUsage: %s [--all-packages]\n' "$1" "${0##*/}" >&2
    exit 2
    ;;
esac

missing=()
for package in "${packages[@]}"; do
  pacman -Q "$package" >/dev/null 2>&1 || missing+=("$package")
done

if ((${#missing[@]})); then
  if command -v yay >/dev/null 2>&1; then
    yay -S --needed "${missing[@]}"
  else
    # Use official repositories where possible, then install remaining AUR packages with yay.
    official=()
    aur=()
    for package in "${missing[@]}"; do
      if pacman -Si "$package" >/dev/null 2>&1; then
        official+=("$package")
      else
        aur+=("$package")
      fi
    done
    if ((${#official[@]})); then
      sudo pacman -S --needed "${official[@]}"
    fi
    if ((${#aur[@]})); then
      printf 'Missing AUR packages: %s. Install yay, then rerun this script.\n' "${aur[*]}" >&2
      exit 1
    fi
  fi
fi

mkdir -p "$CONFIG_DIR"
shopt -s nullglob dotglob
for source in "$DOTFILES_DIR"/config/*; do
  [[ -d "$source" ]] || continue
  name="${source##*/}"
  target="$CONFIG_DIR/$name"
  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$DOTFILES_DIR/backups/$STAMP/config"
    mv -- "$target" "$DOTFILES_DIR/backups/$STAMP/config/$name"
  fi
  mkdir -p "$target"
  cp -a -- "$source/." "$target/"
done

for source in "$DOTFILES_DIR"/config-files/*; do
  [[ -f "$source" ]] || continue
  target="$CONFIG_DIR/${source##*/}"
  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$DOTFILES_DIR/backups/$STAMP/config-files"
    mv -- "$target" "$DOTFILES_DIR/backups/$STAMP/config-files/${source##*/}"
  fi
  install -m 0644 "$source" "$target"
done

for source in "$DOTFILES_DIR"/home/.*; do
  [[ -f "$source" ]] || continue
  name="${source##*/}"
  target="$HOME/$name"
  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$DOTFILES_DIR/backups/$STAMP/home"
    mv -- "$target" "$DOTFILES_DIR/backups/$STAMP/home/$name"
  fi
  install -m 0644 "$source" "$target"
done

if compgen -G "$DOTFILES_DIR/home/.local/bin/*" >/dev/null; then
  mkdir -p "$HOME/.local/bin"
  for source in "$DOTFILES_DIR"/home/.local/bin/*; do
    [[ -f "$source" ]] || continue
    target="$HOME/.local/bin/${source##*/}"
    if [[ -e "$target" || -L "$target" ]]; then
      mkdir -p "$DOTFILES_DIR/backups/$STAMP/home/.local/bin"
      mv -- "$target" "$DOTFILES_DIR/backups/$STAMP/home/.local/bin/${source##*/}"
    fi
    install -m 0755 "$source" "$target"
  done
fi

if compgen -G "$DOTFILES_DIR/assets/wallpapers/*" >/dev/null; then
  wallpaper_dir="$HOME/Downloads/wallpapers"
  mkdir -p "$wallpaper_dir"
  for source in "$DOTFILES_DIR"/assets/wallpapers/*; do
    [[ -f "$source" ]] || continue
    target="$wallpaper_dir/${source##*/}"
    if [[ -e "$target" || -L "$target" ]]; then
      mkdir -p "$DOTFILES_DIR/backups/$STAMP/assets/wallpapers"
      mv -- "$target" "$DOTFILES_DIR/backups/$STAMP/assets/wallpapers/${source##*/}"
    fi
    install -m 0644 "$source" "$target"
  done
fi

for asset_type in themes icons fonts; do
  source_root="$DOTFILES_DIR/assets/$asset_type"
  [[ -d "$source_root" ]] || continue
  case "$asset_type" in
    themes) target_root="$HOME/.themes" ;;
    icons) target_root="$HOME/.local/share/icons" ;;
    fonts) target_root="$HOME/.local/share/fonts" ;;
  esac
  mkdir -p "$target_root"
  for source in "$source_root"/*; do
    [[ -e "$source" || -L "$source" ]] || continue
    target="$target_root/${source##*/}"
    if [[ -e "$target" || -L "$target" ]]; then
      mkdir -p "$DOTFILES_DIR/backups/$STAMP/assets/$asset_type"
      mv -- "$target" "$DOTFILES_DIR/backups/$STAMP/assets/$asset_type/${source##*/}"
    fi
    if [[ -d "$source" ]]; then
      cp -a -- "$source" "$target"
    else
      install -m 0644 "$source" "$target"
    fi
  done
done

if command -v fc-cache >/dev/null 2>&1 && [[ -d "$HOME/.local/share/fonts" ]]; then
  fc-cache -f "$HOME/.local/share/fonts"
fi

printf 'Installed dotfiles from %s\n' "$DOTFILES_DIR"
printf 'Previous files, if any, are saved under backups/%s\n' "$STAMP"
