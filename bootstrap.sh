#!/usr/bin/env bash

set -e

# enable home-manager and unstable nixpkgs channels
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
nix-channel --update

# remove the default home-manager home.nix configuration
rm -rf ~/.config/home-manager

# clone the private nixos-home repo in ~/.config/home-manager
git clone https://github.com/kamou/nixos-home ~/.config/home-manager

pushd ~/.config/home-manager

# now we can run home-manager switch
home-manager switch

popd
