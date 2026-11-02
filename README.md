# Superwhisper for Linux

This repository is the public download channel for Superwhisper on Linux.
Release archives, checksums, installation instructions, and update metadata are
published here. Application source and model weights are maintained separately.

## Supported systems

One archive per CPU type runs on every supported desktop. It is named
`superwhisper-omarchy-…` on every system, because the updater relies on that name.

| System | Desktop | Notes |
|---|---|---|
| Omarchy (x86-64) | Hyprland | The main target. |
| Omarchy (ARM, `aarch64`) | Hyprland | Tested on Omarchy ARM in a VM. Not yet tested on Apple or Snapdragon GPUs; Offline falls back to the CPU if the GPU check fails. |
| Arch, CachyOS, EndeavourOS | Hyprland | Shortcuts are set from the app only with a Lua configuration (`hyprland.lua`). With `hyprland.conf`, bind `superwhisper record` (toggle) and `superwhisper cancel` yourself. |
| Arch, CachyOS, EndeavourOS | KDE Plasma 6 (Wayland) | Tested on CachyOS. |
| Arch, CachyOS, EndeavourOS | GNOME (Wayland) | Tested on CachyOS with GNOME 51. Log out and back in once after installing, so the recording pill and top-bar menu load. |

## Install

Download the `.tar.zst` and `.sha256` for your CPU from the latest release, then:

```sh
sha256sum -c superwhisper-omarchy-*.tar.zst.sha256
tar --zstd -xf superwhisper-omarchy-*.tar.zst
cd superwhisper-omarchy-*/
./install.sh
```

Open **Superwhisper** from the application launcher. On KDE and GNOME, the desktop
asks you to confirm the shortcuts (Ctrl+Space to dictate, Shift+Escape to cancel),
and asks once to let Superwhisper control input devices so it can paste.
The archive's `README.md` has the details; `./uninstall.sh` removes the app.

> Superwhisper for Linux is prerelease software. Back up important data and
> review release notes before installing preview builds.
