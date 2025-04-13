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

while getopts ":u:k:" opt; do
    case $opt in
    u) USERNAME="$OPTARG" ;;
    k) KEYNAME="$OPTARG" ;;
    \?) echo "Invalid option -$OPTARG" >&2 ;;
    :) echo "Option -$OPTARG requires an argument." >&2 ;;
    esac
done

if [ -z "$USERNAME" ]; then
    echo "Username not provided, use -u USERNAME"
    exit 1
fi

if [ -z "$KEYNAME" ]; then
    echo "Keyname not provided, use -k KEYNAME"
    exit 1
fi

if [ ! -d /etc/nixos/original/ ]; then
    sudo mkdir -p /etc/nixos/original/
    sudo mv /etc/nixos/configuration.nix /etc/nixos/hardware-configuration.nix /etc/nixos/original/
fi

sudo curl -L https://raw.githubusercontent.com/kamou/nix-stuff/main/configuration.nix -o /etc/nixos/configuration.nix
sudo sed -i "s/USERNAME/$USERNAME/g" /etc/nixos/configuration.nix

sudo nixos-rebuild switch

# enable home-manager and unstable nixpkgs channels
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager

nix-channel --update
nix-shell '<home-manager>' -A install

rm ~/.config/home-manager/home.nix

# download stage1 home.nix to populate ssh keys
curl -L https://raw.githubusercontent.com/kamou/nix-stuff/main/home.nix -o ~/.config/home-manager/home.nix
sed -i "s/USERNAME/$USERNAME/g" ~/.config/home-manager/home.nix
sed -i "s/KEYNAME/$KEYNAME/g" ~/.config/home-manager/home.nix

home-manager switch

rm -rf ~/.config/home-manager

# stage2
git clone git@github.com:kamou/nixos-home.git ~/.config/home-manager
sed -i "s/USERNAME/$USERNAME/g" ~/.config/home-manager/user.nix
sed -i "s/USERNAME/$USERNAME/g" ~/.config/home-manager/sops.nix
sed -i "s/KEYNAME/$KEYNAME/g" ~/.config/home-manager/sops.nix

pushd ~/.config/home-manager

# now we can run home-manager switch
home-manager switch

popd
