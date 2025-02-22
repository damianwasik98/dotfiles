setopt no_nomatch

export XDG_CONFIG_HOME="$HOME/.config"

# ~~~~~~~~~~~~~~~ Aliases ~~~~~~~~~~~~~~~~~~~~~~~~
alias sb="~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/Damian"
alias tmux="tmux -f ~/.config/tmux/tmux.conf"

# ls
alias ls='ls --color=auto'
alias la='ls -lathr'

# git
alias gp='git pull'
alias gs='git status'
alias lg='lazygit'

# mac os
alias proxy="networksetup -setsocksfirewallproxystate Wi-Fi"

# locale
export LANG=en_US.UTF-8
export LANGUAGE=en_US
export LC_ALL=en_US.UTF-8

export EDITOR="nvim"

source "$HOME/.config/slimzsh/slim.zsh"


autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc

#export LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib"
#export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include"

# path
export PATH="/usr/local/opt/tcl-tk/bin:$PATH"
export PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
export PATH=$PATH:~/.local/bin

#export PYTHONBREAKPOINT=ipdb.set_trace

source "$HOME/.config/zsh-autosuggestions/zsh-autosuggestions.zsh"

#pyenv
#export PYENV_ROOT="$HOME/.pyenv"
#[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"

#export USE_GKE_GCLOUD_AUTH_PLUGIN=True

#GPG_TTY=$(tty)
#export GPG_TTY

source ~/.config/fzf/.fzf.zsh


fpath+=~/.zfunc
autoload -Uz compinit && compinit

#direnv
#eval "$(direnv hook zsh)"

