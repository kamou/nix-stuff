{ pkgs, ... }:
let
  unstablePkgs = import <nixpkgs-unstable> { config = { }; };
  nixStuff = builtins.fetchTarball {
    url = "https://github.com/kamou/nix-stuff/archive/main.tar.gz";
  };
  rustTools = import "${nixStuff}/envs/rust-tools.nix" { inherit pkgs; };
in
{
  home.packages = [
    pkgs.nodejs
    pkgs.python3
    pkgs.unzip
    unstablePkgs.neovim
  ] ++ rustTools;
}
