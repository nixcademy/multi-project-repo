{ stdenv, lib, cmake, libA, libB }:

stdenv.mkDerivation {
  name = "myapp";

  buildInputs = [ libA libB ];

  nativeBuildInputs = [ cmake ];

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./CMakeLists.txt
      ./main.cpp
    ];
  };
}
