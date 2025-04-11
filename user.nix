{ config, ... }:
{
  home.username = "ak42";
  home.homeDirectory = "/home/ak42";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
