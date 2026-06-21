final: prev:

{
  libA = final.callPackage ./a { };
  libB = final.callPackage ./b { };
  libC = final.callPackage ./c { };
  libD = final.callPackage ./d { };
  myapp = final.callPackage ./app { };
}
