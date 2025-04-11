{ pkgs ? import <nixpkgs> { } }:

let
  rustTools = import ./rust-tools.nix { inherit pkgs; };
in
pkgs.mkShell {
  buildInputs = rustTools ++ [
    pkgs.openssl
    pkgs.dbus
    pkgs.pkg-config
  ];

  nativeBuildInputs = [
    pkgs.pkg-config
  ];

  shellHook = ''
    export LIBCLANG_PATH="${pkgs.libclang.lib}/lib"
    export OPENSSL_DIR="${pkgs.openssl.dev}"
    export OPENSSL_LIB_DIR="${pkgs.openssl.out}/lib"
    export OPENSSL_INCLUDE_DIR="${pkgs.openssl.dev}/include"
    export DBUS_INCLUDE_DIR="${pkgs.dbus.dev}/include/dbus-1.0"
    export DBUS_LIB_DIR="${pkgs.dbus.lib}/lib"
    export PATH=$PATH:''${CARGO_HOME:-~/.cargo}/bin
  '';
}
