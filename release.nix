let
  sources = import ./nix/tamal { };
  pkgs = import sources.nixpkgs {
    overlays = [
      (import ./overlay.nix)
    ];
  };
in
{
  inherit (pkgs)
    libA
    libB
    libC
    libD
    myapp;

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
    nativeBuildInputs = [
      pkgs.deadnix
      pkgs.graphviz
      pkgs.nixfmt-tree
      pkgs.nixtamal
      pkgs.statix
    ];
  };
}
