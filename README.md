# dotfiles

My configuration files for MacOS / Linux.

## Methodology
I use [GNU stow](https://www.gnu.org/software/stow/) for symlinking config files in local machine.
This tool enables clean repository structure and makes maintaining config files a lot easier.

Each tool has it's own directory in this repo and after running setup script it is symlinked to `~/.config` directory on local machine.

## Installation

```sh
./setup
```

## Cleanup

Sometimes I would like to cleanup symlinks and make a fresh start.

```sh
./cleanup
```
