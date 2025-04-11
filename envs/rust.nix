{ pkgs ? import <nixpkgs> { } }:

let
  rustTools = import ./rust-tools.nix { inherit pkgs; };
in

pkgs.mkShell {
  buildInputs = rustTools;

  shellHook = ''
    export LIBCLANG_PATH="${pkgs.libclang.lib}/lib"
    export PATH=$PATH:''${CARGO_HOME:-~/.cargo}/bin
  '';
}
