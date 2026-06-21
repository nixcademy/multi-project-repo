{
  stdenv,
  lib,
  cmake,
}:

stdenv.mkDerivation {
  name = "libC";

  nativeBuildInputs = [ cmake ];

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./CMakeLists.txt
      ./main.cpp
      ./include
    ];
  };
}
