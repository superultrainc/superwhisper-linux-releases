{
  description = "Superwhisper for Linux";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      # Unfree is allowed for this package only, so `nix run` and the module work as is.
      forAll = f: nixpkgs.lib.genAttrs systems (s: f (import nixpkgs {
        system = s;
        config.allowUnfreePredicate = p: nixpkgs.lib.getName p == "superwhisper";
      }));
    in {
      packages = forAll (pkgs: rec {
        superwhisper = pkgs.callPackage ./packaging/nix/package.nix { };
        default = superwhisper;
      });

      overlays.default = final: _: {
        superwhisper = final.callPackage ./packaging/nix/package.nix { };
      };

      homeManagerModules.default = import ./packaging/nix/home-manager.nix self;

      checks = forAll (pkgs: { package = self.packages.${pkgs.stdenv.hostPlatform.system}.default; });
    };
}
