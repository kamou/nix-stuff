#!/usr/bin/env bash

set -e

if ! command -v git &>/dev/null; then
    echo "git could not be found, run \`nix-shell -p git\` prior to running this script"
    exit 1
fi

if [ ! -f /home/ak42/.config/sops/age/keys.txt ]; then
    echo "No age keys found, please create ~/.config/sops/age/keys.txt"
    exit 1
fi

if [ ! -d /etc/nixos/original/ ]; then
    sudo mkdir -p /etc/nixos/original/
    sudo mv /etc/nixos/configuration.nix /etc/nixos/hardware-configuration.nix /etc/nixos/original/
fi

sudo curl -L https://raw.githubusercontent.com/kamou/nix-stuff/main/configuration.nix -o /etc/nixos/configuration.nix
sudo nixos-rebuild switch

# enable home-manager and unstable nixpkgs channels
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager

nix-channel --update
nix-shell '<home-manager>' -A install

# remove the default home-manager home.nix configuration
rm -rf ~/.config/home-manager

# clone the private nixos-home repo in ~/.config/home-manager
git clone git@github.com:kamou/nixos-home.git ~/.config/home-manager

pushd ~/.config/home-manager

# now we can run home-manager switch
home-manager switch

popd
