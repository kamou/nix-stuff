{ config, pkgs, ...}:

let
  sops-nix = builtins.fetchTarball {
    url = "https://github.com/Mic92/sops-nix/archive/master.tar.gz";
  };

  secretsRepo = builtins.fetchGit {
    url = "https://github.com/kamou/nix-stuff.git";
    ref = "main";
  };
in
{
  assertions = [
    {
      assertion = builtins.pathExists "/home/ak42/.config/sops/age/keys.txt";
      message = "AGE key file /home/ak42/.config/sops/age/keys.txt is not present. Aborting!";
    }
  ];

  imports = [
    ./original/configuration.nix
    "${sops-nix}/modules/sops"
  ];

  environment.systemPackages = with pkgs; [
    git
    neovim
    sops
    killall
    cmake
    gnumake
    fd
    ripgrep
    btop
    nerdfetch
    freetube
    librewolf
    wl-clipboard
    kitty
    wofi
    waybar
    hyprpaper
    networkmanagerapplet
    rust-analyzer
    age
    telegram-desktop
    hypridle
    hyprlock
    brightnessctl
    jq
    yq
    bash-language-server
    lua-language-server
    ruff
    shellcheck
    curl
    swaynotificationcenter
    hyprshot
    upower
    power-profiles-daemon
    spotify
  ];
  
  sops.defaultSopsFile = "${secretsRepo}/.secrets.yaml.enc";
  sops.age.keyFile = "/home/ak42/.config/sops/age/keys.txt";

  systemd.tmpfiles.rules = [
    "d /home/ak42/.ssh 0700 ak42 users -"
  ];

  sops.secrets.framework_ssh_key = {
    path = "/home/ak42/.ssh/id_ed25519";
    owner = "ak42";
    mode = "0600";
  };

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  services.printing.enable = true;
  
  # Enable sound with pipewire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.shells = with pkgs; [ zsh ];
  fonts.packages = with pkgs; [ nerdfonts ];

  services.fwupd.enable = true;

  programs.xfconf.enable = true;
  programs.kdeconnect.enable = true;
  programs.zsh.enable = true;

  networking.firewall = rec {
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

    # Enable avahi for .local domains
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  # enable sshd server
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      UseDns = true;
      X11Forwarding = true;
      PermitRootLogin = "prohibit-password";
    };
  };


  users.users.ak42.shell = pkgs.zsh;


}
