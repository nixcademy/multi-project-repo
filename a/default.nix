{
  stdenv,
  lib,
  cmake,
  libC,
  libD,
}:

stdenv.mkDerivation {
  name = "libA";

  # A static archive can't encapsulate its dependencies, so both are propagated:
  # libd is public (exposed in headers), libc is a private implementation dep.
  propagatedBuildInputs = [
    libC
    libD
  ];

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
