# Superwhisper for Linux

Voice dictation for Linux. Speak, and your words are typed into whatever app you're using.

Works on:

- **Omarchy**
- **Hyprland**, **KDE Plasma** or **GNOME** on Arch, CachyOS or EndeavourOS

You need a 64-bit PC (Intel/AMD or ARM) and a Wayland session.

## Install

Open a terminal and paste:

```sh
mkdir -p ~/Downloads/superwhisper && cd ~/Downloads/superwhisper
url=$(curl -fsSL https://api.github.com/repos/superultrainc/superwhisper-linux-releases/releases/latest \
  | grep -o "https://[^\"]*superwhisper-omarchy-$(uname -m)-[^\"]*\.tar\.zst" | head -1)
curl -fLO "$url" && curl -fLO "$url.sha256"
sha256sum -c superwhisper-omarchy-*.tar.zst.sha256
tar --zstd -xf superwhisper-omarchy-*.tar.zst
cd superwhisper-omarchy-*/ && ./install.sh
```

The installer asks for your password to add a few system packages, then starts Superwhisper.
It updates itself from then on.

Prefer to download by hand? Grab the `.tar.zst` for your PC (`x86_64` or `aarch64`)
from the [latest release](https://github.com/superultrainc/superwhisper-linux-releases/releases/latest)
and run the last three lines above.

## First run

1. Open **Superwhisper** from your app launcher.
2. Under **Configuration → Processing**, pick **Cloud** or **Offline**. Offline downloads its models the first time.
3. Click into any text field and dictate.

| Desktop | Dictate | Cancel |
|---|---|---|
| Omarchy, Hyprland | Hold **Right Alt** | **Escape** |
| KDE Plasma, GNOME | **Ctrl+Space** to start and stop | **Shift+Escape** |

On **KDE** and **GNOME**, your desktop asks you to confirm these shortcuts when you
install, and asks once to let Superwhisper "control input devices" so it can paste.
Say yes to both. On GNOME, log out and back in once to see the recording indicator.

On **Hyprland without Omarchy** using `hyprland.conf` instead of `hyprland.lua`, add
these keys yourself: `bind = SUPER, space, exec, superwhisper record` and
`bind = SUPER, escape, exec, superwhisper cancel`.

## Uninstall

```sh
~/.local/share/superwhisper/app/current/uninstall.sh
```

Your settings and history are kept.

> Superwhisper for Linux is in preview. Read the release notes before updating.
