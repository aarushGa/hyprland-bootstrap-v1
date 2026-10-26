# Hyprland Dotfiles

A personalized, minimal Arch Linux desktop setup built around **Hyprland**, **Waybar**, and **Rofi**. Designed for a clean monochrome aesthetic, practical workflows, and easy installation on a fresh Arch Linux system.

## Features

- **Hyprland** – Dynamic tiling, custom keybindings, animations, and window rules.
- **Waybar** – Minimal system status bar with workspaces, CPU, memory, network, battery, clock, and custom modules.
- **Rofi** – Custom application launcher and menus.
- **Audio visualizer** – Real-time audio visualization using CAVA, with Waybar integration.
- **Minimal styling** – Dark backgrounds, monochrome colors, subtle borders, and consistent spacing.
- **Custom scripts** – Utility scripts for desktop automation and daily workflows.
- **Automated installation** – A single installation script for packages and configuration deployment.
- **Git-friendly structure** – Organized files for easy maintenance, backup, and customization.

## Requirements

- Arch Linux
- A working internet connection
- `sudo` privileges
- Git
- A compatible GPU and working graphics drivers

The installer uses `pacman` to install packages from the official Arch Linux repositories. Additional AUR packages, if required, must be installed separately.

## Installation

### 1. Clone the repository

Replace `YOUR_USERNAME` with your GitHub username.

```bash
git clone https://github.com/YOUR_USERNAME/my-dots.git
cd my-dots
```

### 2. Run the installer

```bash
chmod +x install.sh
./install.sh
```

The installer installs the listed dependencies, backs up existing configurations, deploys the repository's configuration files, and copies custom scripts when present.

Review `install.sh` before running it, especially if you are installing on an existing system.

### 3. Start Hyprland

Log out of your current desktop session and select **Hyprland** from your display manager.

If you use a TTY, start Hyprland with:

```bash
Hyprland
```

Check the official Hyprland documentation if your installed version requires a different configuration format or additional setup.

## Repository Structure

```text
my-dots/
├── config/
│   ├── hypr/
│   ├── waybar/
│   ├── rofi/
│   ├── kitty/
│   └── dunst/
├── scripts/
├── wallpapers/
├── install.sh
└── README.md
```

- `config/` contains application configuration files.
- `scripts/` contains custom utilities and automation.
- `wallpapers/` stores desktop backgrounds.
- `install.sh` installs dependencies and deploys configurations.

The actual directory structure may vary depending on the components included in the repository.

## Dependencies

The installation script may include the following packages:

| Component | Purpose |
|---|---|
| Hyprland | Wayland compositor |
| Waybar | Status bar |
| Rofi | Application launcher |
| Kitty | Terminal emulator |
| Dunst | Notifications |
| Hyprlock | Screen locking |
| Hypridle | Idle management |
| PipeWire | Audio system |
| CAVA | Audio visualizer |
| Playerctl | Media playback controls |
| Grim / Slurp | Screenshots |
| Cliphist | Clipboard history |
| JetBrains Mono Nerd Font | Terminal and UI typography |

Some optional components may require additional packages or services.

## Customization

Configuration files are organized by application to make customization easier.

- **Hyprland:** Modify window rules, animations, workspaces, and keybindings.
- **Waybar:** Edit the module configuration and CSS styles.
- **Rofi:** Customize launcher layouts, colors, and themes.
- **Scripts:** Adapt utilities to your preferred applications and workflow.
- **Wallpapers:** Add your own backgrounds and update the relevant configuration paths.

Keep machine-specific settings, such as monitor names and application paths, separate where practical.

## Updating

Pull the latest repository changes:

```bash
git pull
```

Review configuration changes before deploying them. Updating the repository does not automatically install newly added packages or reload every running application.

## Troubleshooting

**Hyprland fails to start**
- Verify your graphics drivers and session setup.
- Check the installed Hyprland version.
- Review the configuration for deprecated options.

**Waybar modules are missing**
- Confirm that the corresponding packages are installed.
- Check module commands and script paths.
- Inspect Waybar's terminal output for errors.

**Audio visualizer is not working**
- Verify that CAVA, Playerctl, and the required JSON utilities are installed.
- Confirm that your audio server is running.
- Check script permissions and Waybar module configuration.

**Configuration changes do not appear**
- Reload the relevant application or restart your Hyprland session.
- Check that files were copied to the correct directories.

## Backup and Safety

The installer backs up selected existing configuration directories before deployment. Keep an independent backup of your working setup before making major changes.

Never commit passwords, API tokens, private keys, or other sensitive information to a public repository.

## Credits

Built with the Arch Linux ecosystem and the open-source projects that make Wayland customization possible.

- [Arch Linux](https://archlinux.org/)
- [Hyprland](https://hypr.land/)
- [Waybar](https://github.com/Alexays/Waybar)
- [Rofi](https://github.com/davatorium/rofi)
- [CAVA](https://github.com/karlstav/cava)

## License

Choose a license before redistributing these configurations. If you publish this repository, consider including an MIT license or another license that matches your intentions.

---

**Note:** This repository is tailored to my personal desktop workflow. Package availability, hardware compatibility, and configuration requirements may vary between systems.
