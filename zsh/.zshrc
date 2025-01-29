setopt no_nomatch

# ~~~~~~~~~~~~~~~ Aliases ~~~~~~~~~~~~~~~~~~~~~~~~
alias sb="~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/Damian"

# ls
alias ls='ls --color=auto'
alias la='ls -lathr'

# git
alias gp='git pull'
alias gs='git status'
alias lg='lazygit'

source "$HOME/.config/slimzsh/slim.zsh"

alias proxy="networksetup -setsocksfirewallproxystate Wi-Fi"


autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc

export LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include"

export PATH="/usr/local/opt/tcl-tk/bin:$PATH"

export PYTHONBREAKPOINT=ipdb.set_trace

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

#pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

export USE_GKE_GCLOUD_AUTH_PLUGIN=True

export EDITOR="vim"

final_cut_trial_again () {
  rm -f "~/Library/Application Support/.ffuserdata"
  if [[ "$?" == 0 ]]; then
    echo "Final Cut's trial period has been extended for the next 90 days"
  elseeval "$(pyenv init -)"
    echo "There was a problem with extending Final Cut's trial period"
  fi
}

GPG_TTY=$(tty)
export GPG_TTY

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#eval $(thefuck --alias)

export PATH=$PATH:~/.local/bin

fpath+=~/.zfunc
autoload -Uz compinit && compinit

#direnv
eval "$(direnv hook zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/damian/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/damian/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/damian/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/damian/google-cloud-sdk/completion.zsh.inc'; fi

# pnpm
export PNPM_HOME="/Users/damian/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
