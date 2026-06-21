let
  patchLetter =
    oldLetter: newLetter: drv:
    drv.overrideAttrs (old: {
      postPatch = ''
        substituteInPlace main.cpp \
          --replace-fail '"${oldLetter}"' '"${newLetter}"'
      '';
    });
in
final: prev: {
  libA = patchLetter "a" "x" prev.libA;
  libB = patchLetter "b" "y" prev.libB;
  libC = patchLetter "C" "Z" prev.libC;
  libD = patchLetter "d" "w" prev.libD;
}
