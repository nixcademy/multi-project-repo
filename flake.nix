# This flake template is from github.com/applicative-systems/template#default
{
  description = "ABCD Project repo";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      eachSystem =
        systems: f:
        builtins.foldl' (
          a: s: a // builtins.mapAttrs (k: v: (a.${k} or { }) // { ${s} = v; }) (f s)
        ) { } systems;
    in
    eachSystem systems (
      system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            (import ./overlay.nix)
          ];
        };
        inherit (pkgs) lib;
      in
      {
        packages = {
          default = pkgs.myapp;
          inherit (pkgs)
            libA
            libB
            libC
            libD
            myapp
            ;

          myapp-static = pkgs.pkgsStatic.myapp;
          myapp-win64 = pkgs.pkgsCross.mingwW64.myapp;
          myapp-aarch64 = pkgs.pkgsCross.aarch64-multiplatform.myapp;
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = with pkgs; [
            libA
            libB
            libC
            libD
            myapp
          ];
          packages = [
            pkgs.graphviz
            pkgs.nixtamal
            (pkgs.treefmt.withConfig {
              settings = {
                on-unmatched = "info";
                formatter = {
                  nixfmt = {
                    command = lib.getExe pkgs.nixfmt;
                    includes = [ "*.nix" ];
                  };
                  statix = {
                    command = "${lib.getExe pkgs.statix} fix";
                    includes = [ "*.nix" ];
                  };
                  deadnix = {
                    command = lib.getExe pkgs.deadnix;
                    includes = [ "*.nix" ];
                  };
                };
              };
            })
          ];
        };
      }
    )
    // {
      checks = inputs.self.packages;
    };
}
