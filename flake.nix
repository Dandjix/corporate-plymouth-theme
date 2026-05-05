{
  description = "Evangelion UI - A Plymouth boot theme";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          evangelion-ui = pkgs.stdenv.mkDerivation {
            pname = "evangelion-ui-plymouth";
            version = "1.1";
            src = ./.;

            nativeBuildInputs = [ pkgs.gnutar ];

            installPhase = ''
              mkdir -p $out/share/plymouth/themes/evangelion-ui
              cp evangelion-ui.plymouth evangelion-ui.script $out/share/plymouth/themes/evangelion-ui/
              tar -xzf images.tar.gz -C $out/share/plymouth/themes/evangelion-ui/

              # Update the .plymouth file with nix store paths
              substitute $out/share/plymouth/themes/evangelion-ui/evangelion-ui.plymouth \
                $out/share/plymouth/themes/evangelion-ui/evangelion-ui.plymouth \
                --replace "EVANGELION_UI_PATH" "$out"
            '';

            meta = {
              description = "An Evangelion-inspired Plymouth boot theme";
              license = pkgs.lib.licenses.free;
              platforms = pkgs.lib.platforms.linux;
            };
          };

          default = self.packages.${system}.evangelion-ui;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            plymouth
          ];
        };
      }
    );
}
