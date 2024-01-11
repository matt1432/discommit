{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    supportedSystems = ["x86_64-linux"];

    perSystem = attrs:
      nixpkgs.lib.genAttrs supportedSystems (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        attrs system pkgs);
  in {
    packages = perSystem (system: pkgs: {
      discommit = pkgs.buildNpmPackage {
        name = "discommit";
        src = ./.;
        npmDepsHash = "sha256-C+6Gsffmc3hov+Ijx63g3+v3kN4AgKtcVy62k1bA/4E=";
        nativeBuildInputs = with pkgs; [
          typescript
          nodejs_20
        ];

        buildPhase = ''
          tsc -p tsconfig.json
        '';

        installPhase = ''
          mkdir -p $out/bin
          mv node_modules package.json $out

          chmod +x ./build/index.js
          cp -a ./build/index.js $out/bin/discommit
        '';
      };
      default = self.packages.${system}.discommit;
    });

    formatter = perSystem (_: pkgs: pkgs.alejandra);

    devShells = perSystem (_: pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          alejandra
          git
          nodejs_20
          typescript
        ];
      };
    });
  };
}
