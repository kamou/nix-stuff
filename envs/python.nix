{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = [
    pkgs.python312
    pkgs.poetry
    pkgs.pkg-config
    pkgs.python312Packages.setuptools
    pkgs.python312Packages.virtualenv
    pkgs.stdenv.cc.cc.lib
  ];
  LD_LIBRARY_PATH =
    "${pkgs.libGL}/lib/:${pkgs.stdenv.cc.cc.lib}/lib/:${pkgs.glib.out}/lib/";
}
