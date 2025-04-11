#!/usr/bin/env bash

set -e

# check age private key exists in ~/.config/sops/age/keys.txt
if [ ! -f ~/.config/sops/age/keys.txt ]; then
    echo "Error: age private key not found in ~/.config/sops/age/keys.txt, please install it"
    exit 1
fi

# enable home-manager and unstable nixpkgs channels
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
nix-channel --update

# remove the default home-manager home.nix configuration
rm -rf ~/.config/home-manager

# clone the nix-stuff repo in ~/.config/home-manager
git clone https://github.com/kamou/nix-stuff ~/.config/home-manager

pushd ~/.config/home-manager

# decrypt secrets to get the librewolf sync url and ff account username (could not manage to do it from home.nix)
sops -d --input-type yaml --output-type yaml .secrets.yaml.enc >decrypted_secrets.yaml

# get librewolf_tokenserver_uri and librewolf_firefox_account_username fields from the yaml file:
tokenserver_uri=$(yq '.librewolf_tokenserver_uri' decrypted_secrets.yaml)
firefox_account_username=$(yq '.librewolf_firefox_account_username' decrypted_secrets.yaml)

# remove the decrypted secrets file
rm decrypted_secrets.yaml

# replace {{ librewolf_tokenserver_uri }} and {{ librewolf_firefox_account_username }} in program/librewolf.nix with the values from the secrets file
sed -i "s|{{ librewolf_tokenserver_uri }}|$tokenserver_uri|g" programs/librewolf.nix
sed -i "s|{{ librewolf_firefox_account_username }}|$firefox_account_username|g" programs/librewolf.nix

# now we can run home-manager switch
home-manager switch

popd
