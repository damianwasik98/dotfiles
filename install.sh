#!/bin/bash

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

install_nix_multiuser() {
  sh <(sudo curl -L https://nixos.org/nix/install) --yes
  # export path globally for all users
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
}

install_nix_singleuser() {
  sh <(sudo curl -L https://nixos.org/nix/install) --yes
  export PATH=$HOME/.nix-profile/bin:$PATH
  export NIX_PATH=/nix/var/nix/profiles/per-user/$USER/channels
}

install_nix() {
  if [[ "$OSTYPE" == "darwin" ]]; then
    install_nix_multiuser
  else
    install_nix_singleuser
  fi
}

prepare_ubuntu_for_installation() {
  sudo apt update && sudo apt install curl xz-utils -y
}

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  prepare_ubuntu_for_installation
fi

if ! command_exists nix; then
  install_nix
fi

if ! command_exists stow; then
  nix-env -iA nixpkgs.stow
fi

if [ -f ~/.zshrc ]; then
  cp ~/.zshrc ~/.zshrc.backup
  rm ~/.zshrc
fi

./setup

nix-env -iA nixpkgs.minimalTools

if [[ "$OSTYPE" == "darwin*" ]]; then
  nix-env -iA nixpkgs.macOSOnly
fi

if ! command_exists zsh; then
  nix-env -iA zsh
fi

exec zsh -l
