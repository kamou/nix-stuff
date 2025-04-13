{ pkgs, config, ... }:
let
  sops-nix = builtins.fetchTarball {
    url = "https://github.com/Mic92/sops-nix/archive/master.tar.gz";
  };

  secretsRepo = builtins.fetchGit {
    url = "https://github.com/kamou/nix-stuff.git";
    ref = "main";
  };
  username = "USERNAME";
  keyname = "KEYNAME";
  homeDir = "/home/${username}";
in
{
  home.username = username;
  home.homeDirectory = homeDir;
  assertions = [
    {
      assertion = builtins.pathExists "${homeDir}/.config/sops/age/keys.txt";
    }
  ];

  imports = [
    (import "${sops-nix}/modules/home-manager/sops.nix")
  ];

  sops.defaultSopsFile = "${secretsRepo}/.secrets.yaml.enc";
  sops.age.keyFile = "${homeDir}/.config/sops/age/keys.txt";

  sops.secrets."${keyname}" = {
    path = "${homeDir}/.ssh/id_ed25519";
    mode = "0600";
  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
