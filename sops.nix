{ config, lib, ... }:
let
  nixStuff = builtins.fetchTarball {
    url = "https://github.com/kamou/nix-stuff/archive/main.tar.gz";
  };
in
{

  sops.defaultSopsFile = "${nixStuff}/.secrets.yaml.enc";

  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  sops.secrets = {
    framework_ssh_key =
      {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
        mode = "0600";
      };
    librewolf_tokenserver_uri = {
      path = "${config.home.homeDirectory}/.librewolf/secret_tokenserver_uri";
      mode = "0400";
    };
    librewolf_firefox_account_username = {
      path = "${config.home.homeDirectory}/.librewolf/secret_username";
      mode = "0400";
    };
  };

}
