{ config, pkgs, ... }:
let
  username = "USERNAME";
in
{
  imports = [
    ./original/configuration.nix
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
    libsecret
    keepassxc
  ];

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
    allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
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

  services.udisks2.enable = true;
  services.devmon.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  users.users."${username}".shell = pkgs.zsh;


}
