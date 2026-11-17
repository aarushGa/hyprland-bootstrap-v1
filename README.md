# Aarush's Dotfiles

Personal configuration files for an Arch Linux desktop using **Hyprland**.

The repository is arranged so the paths under `config/` map to `~/.config/`, and the files under `home/` map to `$HOME`.

---

## 📁 Included Configuration

### Requested Desktop and Shell Targets

| Directory / File | Description |
|---|---|
| `config/hypr/` | Hyprland configuration, lock configuration and helper scripts. The current main file is `hyprland.lua`; retain any upstream or generated-file requirements of the installed Hyprland setup when editing it. |
| `config/waybar/` | Waybar JSONC configuration, CSS, power menu helpers and the audio visualizer script/assets. |
| `config/rofi/` | Rofi theme and configuration. |
| `config/dunst/` | Dunst configuration, when present on the source machine. |
| `config/mako/` | Mako notification daemon configuration. |
| `config/wlogout/` | Logout layout, stylesheet and icon assets. |
| `config/hyprlock/` | Standalone Hyprlock configuration, when present. The current machine's lock configuration is in `config/hypr/hyprlock.conf`. |
| `config/cava/` | Cava settings and custom shaders/themes used by the visualizer. |
| `config/kitty/` | Kitty terminal settings. |
| `config/starship/` | Starship configuration, when present. Starship can also be configured through `~/.config/starship.toml`. |
| `config/Thunar/` | Thunar custom actions and keyboard accelerators. |
| `home/.bashrc` | Bash interactive configuration, with any inline Gemini API key removed. Set secrets in the environment or a private, untracked shell file. |

### Additional Useful Configuration Found on This Machine

| Directory / File | Description |
|---|---|
| `home/.bash_profile` and `home/.bash_logout` | Bash login and logout setup. |
| `config/fastfetch/` | System information layout and custom text logo. |
| `config/btop/` | Terminal resource monitor settings. |
| `config/eww/` | Eww widgets and styles, including media status polling. |
| `config/gtk-3.0/` and `config/gtk-4.0/` | GTK appearance settings and custom CSS/assets. |
| `config/hypr-session/` | Application-to-command map for Hyprland session restore. |
| `config/kwybars/`, `config/conky/`, `config/fontconfig/`, `config/nwg-look/`, `config/xsettingsd/`, and `config/xfce4/` | Additional visualizer, monitor, font, GTK appearance, XSettings, and Thunar settings found in use. |
| `config-files/starship.toml`, `config-files/gtkrc`, and `config-files/mimeapps.list` | Single files that live directly in `~/.config/`. |
| `home/.gtkrc-2.0` and `home/.fonts.conf` | GTK 2 and legacy font configuration. |
| `home/.local/bin/` | Custom Hyprland session save/restore utilities. |
| `assets/wallpapers/` | Only the wallpaper and lock screen files directly referenced by the saved Hyprland configs (`arch.png`, `live5.mp4`, and `hyprlock.jpg` when present). |
| `assets/themes/Graphite-Dark/`, `assets/icons/Reversal/`, and `assets/fonts/` | The installed custom GTK theme, icon theme, and local font files used by the appearance settings. |
| `packages/` | Point-in-time lists of explicitly installed pacman packages, foreign packages, Flatpak apps, and enabled user systemd units. |

> **Backup scope:** Only deliberately selected configuration roots and the assets directly referenced by the desktop configs are copied. Application databases, caches, browser state, histories, credentials, and unrelated personal files are not part of the backup. Temporary editor files and `*.save`/`*.bak` files are excluded. Machine-specific package inventories are records for rebuilding the environment; they are not blindly installed by the default installer.

---

## ⚙️ Requirements

- Arch Linux or an Arch based distribution with `pacman`.
- `rsync` to run `backup.sh`.
- `sudo` for package installation when needed.
- `yay` is recommended for AUR packages. The installer uses `yay` when it is available; without it, the installer installs packages available from configured official repositories and reports any AUR packages still needed.

The default package list covers Hyprland and its configured session tools, Waybar, Rofi, Dunst/Mako, Wlogout/Hyprlock, Cava, Kitty, Starship, Thunar, PipeWire, network/audio controls, font support, and cursor/icon fonts.

Existing installed packages are skipped. Review/edit the `packages` array in `install.sh` if your distribution uses different package names or you do not want every listed program.

---

## 💾 Backup Current Machine Configuration

Run this before committing local changes or after editing settings in `~/.config`:

```bash
cd ~/dotfiles
./backup.sh
```

The script copies the selected existing config directories, shell files, custom session utilities, referenced wallpaper assets, and package inventories into this repository.

- Missing optional directories are skipped.
- Existing content is updated to match the machine for each present config root.
- The script does not delete repository roots whose corresponding source directory is missing.
- `rsync` is required.

The `.bashrc` is copied with any line assigning `GEMINI_API_KEY` removed.

**Review the resulting diff before sharing or pushing this repository, and do not add tokens, passwords, private keys, or other secrets.**

---

## 🚀 Install on an Arch System

Clone or place this repository at `~/dotfiles`, then run:

```bash
cd ~/dotfiles
chmod +x backup.sh install.sh
./install.sh
```

### What the Installer Does

The default installer:

1. Installs the core desktop package set listed in `install.sh`.
2. Copies each repository config directory into `~/.config/`.
3. Copies each file in `config-files/` into `~/.config/`.
4. Copies files in `home/` into `$HOME`.
5. Restores referenced wallpapers into `~/Downloads/wallpapers/`.
6. Restores the custom theme/icons/fonts into their user-level theme directories.
7. Refreshes the font cache.

Existing destination paths are moved into `backups/YYYYMMDD-HHMMSS/` inside the repository before replacement.

This makes reruns possible and provides a local rollback copy.

> **Note:** Review the `backups/` directory before sharing the repository because it can contain machine-specific prior settings.

### Install All Recorded Packages

Use:

```bash
./install.sh --all-packages
```

This uses the full explicit package inventory in `packages/pacman-explicit.txt`.

Review this machine-specific list first because it includes system, hardware, development, and application packages in addition to the desktop environment.

### After Installation

Restart the relevant applications or log out and back into Hyprland after installation.

Bash changes apply to new shells. Use the following command to apply them to the current interactive shell:

```bash
source ~/.bashrc
```

---

## ↩️ Restore a Prior Destination

Find the appropriate timestamp under:

```text
backups/
```

To manually restore a saved config, move its directory back to `~/.config/`; to restore a home file, move it back to `$HOME`.

The installer intentionally does not automatically roll back or delete backups.

---

## 🛠️ Maintenance Notes

- Keep `config/` paths aligned with their destination under `~/.config/`.
- Run `./backup.sh` after changing settings on the machine, then review the resulting file changes before committing.
- The package inventories and assets include machine-specific details and can make the repository large.
- `backup.sh` requires `rsync`; install it with `sudo pacman -S rsync` if needed.
- Package names and availability can change. Check the Arch repositories/AUR if installation reports a package unavailable.
- `packages/pacman-explicit.txt` records explicitly installed packages. On a matching Arch system, review it and install with:

  ```bash
  mapfile -t pkgs < packages/pacman-explicit.txt && yay -S --needed "${pkgs[@]}"
  ```

  This may include hardware-specific and unrelated applications.

- `packages/pacman-foreign.txt` is a separate record of packages not found in configured sync repositories, and may include debug packages or AUR builds. Review before reinstalling.
- `packages/flatpak-apps.txt` records installed Flatpak application IDs. Restore reviewed entries with `flatpak install flathub APP_ID` after configuring Flathub.
- `packages/enabled-user-units.txt` records enabled user unit names; it does not contain their unit files or enable them automatically.
- The repository records user-level configuration, selected appearance assets, and package inventories, but not other user content, scripts referenced from outside these backed-up directories, or system-wide configuration. Add such dependencies explicitly to the package list and documentation if they become part of the setup.

---

**Aarush's Dotfiles** · Arch Linux · Hyprland