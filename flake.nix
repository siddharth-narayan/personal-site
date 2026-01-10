{
  outputs =
    { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
        ] (system: function nixpkgs.legacyPackages.${system});
    in
    {

      packages = forAllSystems (pkgs: {
        default = pkgs.buildNpmPackage {
          pname = "personal-site";
          version = "0.1.0";
          src = ./.;
          npmDepsHash = "sha256-QpV1LK7U/92Kc4pA+7draUd375Ni5JvfZvX7sWhRH+w=";
          npmBuildScript = "build";
          installPhase = ''
            mkdir -p $out
            cp -r build/* $out
            cp package.json $out
          '';
        };
      });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nodejs_22
            typst
          ];
        };
      });
    };
}
