{ stdenv, lib, cmake }:

stdenv.mkDerivation {
  name = "libB";

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
