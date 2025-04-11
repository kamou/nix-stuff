{ config, pkgs, lib, ... }:
let
  sops-nix-module = builtins.fetchTarball {
    url = "https://github.com/Mic92/sops-nix/archive/master.tar.gz";
  };
in
{

  imports = [
    (import "${sops-nix-module}/modules/home-manager/sops.nix")
    ./sops.nix
    ./user.nix
    ./packages.nix
    ./environment.nix
    ./files.nix
    ./programs/zsh.nix
    ./programs/fzf.nix
    ./programs/oh-my-posh.nix
    ./programs/librewolf.nix
    ./programs/hyprlock.nix
  ];

  home.file.".dev/nix-envs".source = "${builtins.fetchTarball {
    url = "https://github.com/kamou/nix-stuff/archive/main.tar.gz";
  }}/envs";
  home.sessionVariables.NIX_PATH = "nix-envs=$HOME/.dev/nix-envs:$NIX_PATH";
}
