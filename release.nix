let
  sources = import ./nix/tamal { };
  pkgs = import sources.nixpkgs { };
  inherit (pkgs) lib;

  abcdFrom =
    pkgs:
    lib.makeScope pkgs.newScope (self: {
      libA = self.callPackage ./a { };
      libB = self.callPackage ./b { };
      libC = self.callPackage ./c { };
      libD = self.callPackage ./d { };
      myapp = self.callPackage ./app { };
    });
  abcd = abcdFrom pkgs;
in
{
  inherit (abcd)
    libA
    libB
    libC
    libD
    myapp
    ;

  myapp-static = (abcdFrom pkgs.pkgsStatic).myapp;
  myapp-win64 = (abcdFrom pkgs.pkgsCross.mingwW64).myapp;
  myapp-aarch64 = (abcdFrom pkgs.pkgsCross.aarch64-multiplatform).myapp;

  devShell = pkgs.mkShell {
    inputsFrom = with abcd; [
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
