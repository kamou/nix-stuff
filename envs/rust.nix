{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = [
    pkgs.rustup
    pkgs.pkg-config
    pkgs.rust-analyzer

    # Common build tools
    pkgs.cmake
    pkgs.zlib
    pkgs.gcc
    pkgs.libclang
    pkgs.clang
  ];

  shellHook = ''
    export LIBCLANG_PATH="${pkgs.libclang.lib}/lib"
    export PATH=$PATH:''${CARGO_HOME:-~/.cargo}/bin
  '';
}
