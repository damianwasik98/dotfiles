#!/bin/bash

command_exists() {
	command -v "$1" >/dev/null 2>&1
}

install_homebrew() {
	if command_exists brew; then
		echo "Homebrew is already installed"
		return
	fi

	if [[ "$OSTYPE" == "darwin"* ]]; then
		# macOS
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
		eval "$(/opt/homebrew/bin/brew shellenv)"
	else
		# Linux
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
		test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
		echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >>~/.bashrc
	fi
}

prepare_apt() {
	if [ "$(id -u)" -eq 0 ]; then
		apt update && apt install -y sudo
	else
		sudo apt update
	fi
}

set_timezone() {
	echo "Europe/Warsaw" | sudo tee /etc/timezone
}

prepare_installation() {
	if [[ "$OSTYPE" == "linux-gnu" && $(uname -m) == "aarch64" ]]; then
		prepare_apt
		set_timezone
	else
		install_homebrew
		brew update
	fi
}

install_packages() {
	if [[ "$OSTYPE" == "linux-gnu" && $(uname -m) == "aarch64" ]]; then
		sudo apt install -y "$@"
	else
		brew upgrade "$@"
	fi
}

MINIMAL_TOOLS=(
	"stow"
	"tmux"
	"neovim"
	"git"
	#"lazygit"
	#"docker"
	#"lazydocker"
	#"yazi"
	"fzf"
	"tree"
	"htop"
	"wget"
	"jq"
	"yq"
)

EXTRAS=(
	#"kubectl"
	#"k9s"
	#"devpod"
	#"1password-cli"
	"jsonnet"
)

MACOS_ONLY_TOOLS=(
	"wezterm"
	"aerospace"
	"colima"
	"gnu-getopt"
	"gnu-sed"
	"gnu-tar"
)

echo "Preparing installation..."
prepare_installation

echo "Installing packages..."
install_packages "${MINIMAL_TOOLS[@]}"

INSTALL_EXTRAS=${SKIP_EXTRAS:-0}
if [ "$INSTALL_EXTRAS" -eq 0 ]; then
	install_packages "${EXTRAS[@]}"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
	install_packages "${MACOS_ONLY_TOOLS[@]}"
fi

echo "Done"
