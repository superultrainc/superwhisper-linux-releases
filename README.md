# Superwhisper for Linux

Superwhisper is built for 64-bit Intel/AMD (`x86_64`) and ARM (`aarch64`) PCs;
each archive's file name says which. It is made for Omarchy (Hyprland)
and also runs on KDE Plasma and GNOME on Wayland; see "Other desktops" below.
The ARM build needs an ARMv8.2 CPU with dot product for Offline (Apple M1 and
later under Asahi Linux, Snapdragon X, Raspberry Pi 5); Cloud works on any.
The file is named `superwhisper-omarchy-…` for update compatibility. It uses Vulkan for local
transcription and optional CPU inference for S1 Mini cleanup. Cloud processing is included.
The portable archive downloads checksum-verified models after installation. Offline uses Cohere Transcribe, S1 Mini cleanup, Silero VAD, and acoustic vocabulary.

Install from a terminal:

```sh
curl -fsSL https://tux.superwhisper.com/install.sh | sh
```

It downloads the latest release for your CPU, checks its SHA-256 (and its
minisign signature when `minisign` is installed), then runs the archive's
`install.sh`. For the beta channel, add `-s -- --channel beta` after `sh`; to
see what it would do first, add `--dry-run`. You can
[read the script](https://tux.superwhisper.com/install.sh) before running it.

To install from a downloaded archive by hand:

```sh
sha256sum -c superwhisper-omarchy-*.tar.zst.sha256
tar --zstd -xf superwhisper-omarchy-*.tar.zst
cd superwhisper-omarchy-*/
./install.sh
```

Open **Superwhisper** from the application launcher. Configuration → Processing
lets you select Cloud or Offline. Offline combines Cohere Transcribe with S1 Mini. The installer
enables the user service and applies the default shortcuts.
If a shortcut conflicts, open Configuration and choose another one.

## Other desktops (KDE Plasma, GNOME)

Outside Hyprland, shortcuts are registered through your desktop. Right after
installing, the desktop asks you to confirm them: the defaults are **hold F9**
to dictate and **Escape** to cancel. Escape is only taken while you dictate, so
it still works in other apps. A start/stop shortcut is off by default; set one
in Configuration. A lone modifier such as Right Alt cannot be used as a
shortcut there. Whatever you choose in that dialog, or later in the desktop's
own shortcut settings, is what Superwhisper uses, and its settings show it.
Shortcuts you already set are kept on update.

On GNOME, log out and back in once after installing so the Shell extension
loads. Until then cancel is Shift+Escape, and on GNOME older than 48 hold to
talk does not work yet.

The first time you dictate, the desktop asks to let Superwhisper "control input
devices": that is how it types the paste keystroke. Allow it once; it is
remembered.

On KDE Plasma, Superwhisper can insert text directly through the fcitx5 input
method instead of pasting, which leaves your clipboard alone and works in every
terminal. It offers to set this up once, after a dictation; you can decline.

The installer keeps preferences, vocabulary, history and downloaded models under
the user's normal XDG directories.
`~/.local/share/superwhisper/app/current/uninstall.sh` removes the application
while retaining that data.

Installed prereleases check the signed beta channel for updates every six hours.
Every archive is verified with the embedded Linux release key before installation;
the previous version remains available for automatic rollback if startup fails.
Run `superwhisper update check` to check immediately or
`superwhisper update apply` to install an available update.

Public preview releases and notes are available from
https://github.com/superultrainc/superwhisper-linux-releases.
