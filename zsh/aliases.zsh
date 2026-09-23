# Aliases

# Resolve XDG config dir with a fallback so these work across machines.
: "${XDG_CONFIG_HOME:=$HOME/.config}"

alias v="nvim"
alias nv="neovide --frame transparent --fork"
alias g="git"
alias cl="claude --dangerously-skip-permissions"
alias grm="g fetch && g reset --hard origin/main"
alias gp="g push"
alias gpf="g push --force"
alias gcm="g checkout main"
alias aliases="v $XDG_CONFIG_HOME/zsh/aliases.zsh"
alias sine="cd ~/Documents/sine"
alias ssh='kitten ssh'

# Open config
alias zshroot="v ~/.zshrc"
alias zshrc="v $XDG_CONFIG_HOME/zsh/.zshrc"
alias starshiprc="v $XDG_CONFIG_HOME/starship/starship.toml"
alias vimrc="v $XDG_CONFIG_HOME/nvim/init.vim"
alias aerospacerc="v $XDG_CONFIG_HOME/aerospace/aerospace.toml"
alias fdignore="v $XDG_CONFIG_HOME/fd/ignore/.fdignore"

# Goto config
alias vimdir="cd $XDG_CONFIG_HOME/nvim"
alias wezdir="cd $XDG_CONFIG_HOME/wezterm"
alias nvdir="cd $XDG_CONFIG_HOME/neovide"
alias zshdir="cd $XDG_CONFIG_HOME/zsh"
alias starshipdir="cd $XDG_CONFIG_HOME/starship"
alias cfg="cd $XDG_CONFIG_HOME"

# Bring this machine in line with the tracked dotfiles and dependency locks.
# Homebrew Bundle upgrades Brewfile entries by default; Lazy restore keeps
# Neovim plugins reproducible by honoring nvim/lazy-lock.json.
cfg_sync() {
  emulate -L zsh

  local config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"

  if [[ ! -d "$config_dir/.git" ]]; then
    print -u2 "cfg_sync: $config_dir is not a git repository"
    return 1
  fi

  print "==> Updating dotfiles"
  command git -C "$config_dir" pull --ff-only || return 1
  command git -C "$config_dir" submodule sync --recursive || return 1
  command git -C "$config_dir" submodule update --init --recursive || return 1

  if [[ "$(uname -s)" == Darwin ]]; then
    if (( ! $+commands[brew] )); then
      print -u2 "cfg_sync: Homebrew is missing; run $config_dir/install.sh first"
      return 1
    fi

    print "==> Updating Homebrew dependencies"
    command brew update || return 1
    command brew bundle install --file="$config_dir/brew/Brewfile" || return 1

    # One-time migration for machines that previously used jankyborders.
    if command brew list --formula borders >/dev/null 2>&1; then
      print "==> Removing retired jankyborders dependency"
      command brew services stop borders >/dev/null 2>&1 || true
      command brew uninstall borders || return 1
    fi
  fi

  if (( $+commands[nvim] )); then
    print "==> Restoring Neovim plugins"
    command nvim --headless '+Lazy! restore' +qa || return 1
  fi

  if [[ "$(uname -s)" == Darwin ]]; then
    (( $+commands[sketchybar] )) && command sketchybar --reload
    (( $+commands[aerospace] )) && command aerospace reload-config
  fi

  print "==> Config and dependencies are synced"
}

if uname | grep -q "Darwin" ; then
  alias docs="cd ~/Documents"
elif uname | grep -q "Linux" ; then
  alias docs="cd ~/documents"
else
  echo 'Unknown OS!'
fi

# Fns
benchmark () {
   ts '[%Y-%m-%d %H:%M:%S]'
}

# Logs 
alias tailsketchy="tail -f /opt/homebrew/var/log/sketchybar/sketchybar.err.log"


