#!/bin/bash

command_exists() {
	command -v "$1" >/dev/null 2>&1
}

install_homebrew() {
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

install_packages() {
	brew upgrade "$@"
}

MINIMAL_TOOLS=(
	"stow"
	"tmux"
	"neovim"
	"git"
	"lazygit"
	"docker"
	"lazydocker"
	"yazi"
	"fzf"
	"tree"
	"htop"
	"wget"
	"jq"
	"yq"
)

EXTRAS=(
	"kubectl"
	"k9s"
	"devpod"
	"1password-cli"
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

if ! command_exists brew; then
	echo "Installing Homebrew..."
	install_homebrew
else
	echo "Homebrew is already installed"
fi

echo "Updating Homebrew..."
brew update

INSTALL_EXTRAS=${SKIP_EXTRAS:-0}
echo "Installing packages..."
install_packages "${MINIMAL_TOOLS[@]}"

if [ "$INSTALL_EXTRAS" -eq 0 ]; then
	install_packages "${EXTRAS[@]}"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
	install_packages "${MACOS_ONLY_TOOLS[@]}"
fi

echo "Done"
