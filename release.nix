let
  sources = import ./nix/tamal { };
  pkgs = import sources.nixpkgs {
    overlays = [
      (import ./overlay.nix)
    ];
  };
  inherit (pkgs) lib;
in
{
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

  devShell = pkgs.mkShell {
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
