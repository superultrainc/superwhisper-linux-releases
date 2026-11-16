self: { config, lib, pkgs, ... }:
let
  cfg = config.services.superwhisper;
  exe = lib.getExe cfg.package;
in {
  options.services.superwhisper = {
    enable = lib.mkEnableOption "Superwhisper dictation";
    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
      defaultText = lib.literalExpression "superwhisper-linux.packages.\${system}.default";
      description = "The Superwhisper package.";
    };
    gnomeExtension.enable = lib.mkEnableOption ''
      the GNOME Shell extension (recording pill and top-bar menu).
      Replaces `org/gnome/shell` `enabled-extensions` in dconf; if you set that list
      yourself, leave this off and add "superwhisper@superwhisper.com" to it'';
  };

  config = lib.mkIf cfg.enable {
    # Brings the .desktop files, icons, font and GNOME extension into the profile.
    home.packages = [ cfg.package ];
    fonts.fontconfig.enable = lib.mkDefault true;

    # No update timer: the package's updater is off and Nix does the updating.
    systemd.user.services.superwhisper = {
      Unit = {
        Description = "Superwhisper dictation";
        After = [ "graphical-session.target" "pipewire.service" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${exe} daemon";
        ExecStopPost = [ "${exe} playback-restore" "${exe} desktop-release" ];
        Restart = "on-failure";
        RestartSec = 2;
        KillMode = "control-group";
        TimeoutStopSec = 15;
        UMask = "0077";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    dconf.settings = lib.mkIf cfg.gnomeExtension.enable {
      "org/gnome/shell".enabled-extensions = [ "superwhisper@superwhisper.com" ];
    };
  };
}
