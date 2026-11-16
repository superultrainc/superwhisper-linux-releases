{ lib, stdenv, fetchurl, zstd, autoPatchelfHook, wrapGAppsHook4, gobject-introspection
, makeWrapper, makeDesktopItem, python3, gtk4, gtk4-layer-shell, at-spi2-core, librsvg
, gdk-pixbuf, pipewire, pulseaudio, libnotify, wl-clipboard, ffmpeg, vulkan-loader
, minisign, libxkbcommon, wayland, wtype, libxcb, fontconfig, graphene, cairo, glib
, gcc, procps, xdg-utils, systemd }:

let
  # Bump with the url and sha256 of https://tux.superwhisper.com/stable.json.
  version = "1.3.1";
  arch = stdenv.hostPlatform.parsed.cpu.name;
  sha256 = {
    x86_64 = "464a732ca6c928d3f2b8bb94687176a75ca2b09c186333d34d94d051ccb5f0e4";
    aarch64 = "a440c85ea31bdb0c3c3b3de971a042402cc698efa27c54dc573c9553fd28f06f";
  }.${arch};
  name = "superwhisper-omarchy-${arch}-${version}";

  pythonEnv = python3.withPackages (p: [ p.pygobject3 p.pycairo ]);
  desktop = makeDesktopItem {
    name = "com.superwhisper.Superwhisper";
    desktopName = "Superwhisper";
    comment = "Fast local and cloud dictation";
    exec = "superwhisper settings --window";
    icon = "superwhisper";
    startupWMClass = "com.superwhisper.Superwhisper";
    categories = [ "Utility" "Accessibility" ];
  };
  deepLink = makeDesktopItem {
    name = "superwhisper-url";
    desktopName = "Superwhisper License Activation";
    exec = "superwhisper open-url %u";
    icon = "superwhisper";
    noDisplay = true;
    mimeTypes = [ "x-scheme-handler/superwhisper" ];
  };
  gnomeUuid = "superwhisper@superwhisper.com";
in
stdenv.mkDerivation {
  pname = "superwhisper";
  inherit version;

  src = fetchurl {
    url = "https://tux.superwhisper.com/${arch}/v${version}/${name}.tar.zst";
    inherit sha256;
  };

  nativeBuildInputs = [ zstd autoPatchelfHook wrapGAppsHook4 gobject-introspection makeWrapper ];
  buildInputs = [
    gtk4 gtk4-layer-shell at-spi2-core librsvg gdk-pixbuf graphene cairo glib
    vulkan-loader libxcb fontconfig libxkbcommon gcc.cc.lib pythonEnv
  ];

  # The fcitx5 addon links fcitx5's own libraries, which fcitx5 provides when it loads it.
  autoPatchelfIgnoreMissingDeps = [ "libFcitx5Core.so.7" "libFcitx5Utils.so.2" ];

  dontWrapGApps = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/superwhisper $out/share/applications $out/share/fonts/truetype \
      $out/share/gnome-shell/extensions
    cp -r app $out/share/superwhisper/app
    app=$out/share/superwhisper/app
    ln -s $app/assets/gnome-extension/${gnomeUuid} $out/share/gnome-shell/extensions/${gnomeUuid}
    ln -s $app/assets/linux-status/SuperwhisperTUI.ttf $out/share/fonts/truetype/
    for png in $app/assets/app-icon/*.png; do
      size=$(basename "$png" .png)
      [[ "$size" =~ ^[0-9]+$ ]] || continue
      install -Dm644 "$png" $out/share/icons/hicolor/''${size}x''${size}/apps/superwhisper.png
    done
    ln -s ${desktop}/share/applications/*.desktop ${deepLink}/share/applications/*.desktop $out/share/applications/
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/share/superwhisper/app/run.sh $out/bin/superwhisper \
      "''${gappsWrapperArgs[@]}" \
      --set SUPERWHISPER_UPDATE_DISABLED 1 \
      --prefix PATH : ${lib.makeBinPath [ pythonEnv pipewire pulseaudio libnotify wl-clipboard ffmpeg minisign wtype ]} \
      --suffix PATH : ${lib.makeBinPath [ procps xdg-utils systemd fontconfig ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader wayland libxkbcommon libxcb fontconfig gtk4-layer-shell ]} \
      --prefix GI_TYPELIB_PATH : ${lib.makeSearchPath "lib/girepository-1.0" [ gtk4 gtk4-layer-shell at-spi2-core ]}
  '';

  meta = {
    description = "Fast local and cloud dictation";
    homepage = "https://superwhisper.com";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "superwhisper";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
