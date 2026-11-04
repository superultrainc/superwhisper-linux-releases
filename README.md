# Superwhisper for Linux

Voice dictation for Linux. Speak, and your words are typed into whatever app
you're using. It runs on Hyprland (including Omarchy), KDE Plasma and GNOME on
Wayland.

## Supported distros

- Omarchy, Arch and CachyOS
- Ubuntu 24.04 or newer
- Linux Mint 22 or newer
- Debian 13 (trixie) or newer
- Fedora 40 or newer
- openSUSE Tumbleweed

You need Wayland (Hyprland, KDE Plasma or GNOME), systemd, and a 64-bit
Intel/AMD (`x86_64`) or ARM (`aarch64`) CPU. The installer adds the packages
Superwhisper needs on these distros. Others are not supported yet; if yours is
missing, email support@superwhisper.com.

The ARM build needs an ARMv8.2 CPU with dot product for Offline (Apple M1 and
later under Asahi Linux, Snapdragon X, Raspberry Pi 5); Cloud works on any.
Offline uses Vulkan for transcription (Cohere Transcribe, Silero VAD and
acoustic vocabulary) and the CPU for S1 Mini cleanup. Its models are
downloaded and checksum-verified after installation. Cloud processing is
included.

## Install

Open a terminal and paste:

```sh
curl -fsSL https://tux.superwhisper.com/install.sh | sh
```

It downloads the latest release for your CPU, checks its SHA-256 (and its
minisign signature when `minisign` is installed), then runs the archive's
`install.sh`. The installer asks for your password to add a few system
packages, then starts Superwhisper. For the beta channel, add
`-s -- --channel beta` after `sh`; to see what it would do first, add
`--dry-run`. You can [read the script](https://tux.superwhisper.com/install.sh)
before running it.

To install by hand, download the `.tar.zst` and its `.sha256` for your CPU
from the [latest release](https://github.com/superultrainc/superwhisper-linux-releases/releases/latest),
then:

```sh
sha256sum -c superwhisper-*.tar.zst.sha256
tar --zstd -xf superwhisper-*.tar.zst
cd superwhisper-*/
./install.sh
```

## First run

1. Open **Superwhisper** from your app launcher.
2. Under **Configuration → Processing**, pick **Cloud** or **Offline**. Offline
   downloads its models the first time.
3. Click into any text field and dictate.

| Desktop | Dictate | Cancel |
|---|---|---|
| Omarchy, Hyprland | Hold **Right Alt** | **Escape** |
| KDE Plasma, GNOME | Hold **F9** | **Escape** |

A start/stop shortcut is off by default; set one in Configuration, where you
can change any shortcut. Updating never changes shortcuts you have set.

On Cloud without internet, Superwhisper uses your offline models if you've
downloaded them, and goes back to Cloud when you're online again.

## KDE Plasma and GNOME

Outside Hyprland, shortcuts are registered through your desktop. Right after
installing, the desktop asks you to confirm them. Escape is only taken while
you dictate, so it still works in other apps. A lone modifier such as Right
Alt cannot be used as a shortcut there. Whatever you choose in that dialog, or
later in the desktop's own shortcut settings, is what Superwhisper uses, and
its settings show it.

On GNOME, log out and back in once after installing so the Shell extension
loads. Until then cancel is Shift+Escape, and on GNOME older than 48 hold to
talk does not work yet.

The first time you dictate, the desktop asks to let Superwhisper "control input
devices": that is how it types the paste keystroke. Allow it once; it is
remembered.

On KDE Plasma, Superwhisper can insert text directly through the fcitx5 input
method instead of pasting, which leaves your clipboard alone and works in every
terminal. It offers to set this up once, after a dictation; you can decline.

## Hyprland without Omarchy

Superwhisper writes its shortcuts into Hyprland's Lua configuration
(`hyprland.lua`). If you use `hyprland.conf` instead, add the keys yourself:

```
bind = SUPER, space, exec, superwhisper record
bind = SUPER, escape, exec, superwhisper cancel
```

## Updates

Superwhisper checks for updates every six hours. Every archive is verified
with the embedded Linux release key before installation, and the previous
version stays available for automatic rollback if startup fails. Run
`superwhisper update check` to check now, or `superwhisper update apply` to
install an available update.

## Uninstall

```sh
~/.local/share/superwhisper/app/current/uninstall.sh
```

Your preferences, vocabulary, history and downloaded models are kept, under
your normal XDG directories.

> Superwhisper for Linux is in preview. Read the
> [release notes](https://github.com/superultrainc/superwhisper-linux-releases/releases)
> before updating.
