{
  description = "Gem which does nothin";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    gemfury-cli.url = "github:gemfury/cli";
    gemfury-cli.flake = false;
  };

  outputs = {
    self
  , flake-utils
  , gemfury-cli
  , nixpkgs
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages = rec {
        default = noop-gem;

        noop-gem = pkgs.buildRubyGem {
          gemName = "noop";
          version = "0.1.0";
          src = ./.;
          ruby = pkgs.ruby;
        };
      };

      devShells = let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = let
          gemfury-pkg = pkgs.buildGoModule {
            pname = "gemfury-cli";
            version = "0.1.0"; # lazy lol
            src = gemfury-cli;
            vendorHash = "sha256-3DIRGnBIRS+vlgVnShjAW3JT8XSvPxm9GhnSa6jso+w=";
          };
        in pkgs.mkShell {
          name = "devshell";

          buildInputs = [
            pkgs.bundix
            pkgs.bundler
            gemfury-pkg
          ];
        };
      };
    });
}
