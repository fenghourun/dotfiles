#!/usr/bin/env bash
#
# Bootstrap these dotfiles on a macOS (Apple Silicon) machine.
#
# The repo IS ~/.config — there is no symlinking/stow. This script makes
# ~/.config track the repo, pulls submodules, installs Homebrew packages,
# and wires up the shell. It is idempotent: safe to re-run to update.
#
#   curl -fsSL https://raw.githubusercontent.com/fenghourun/dotfiles/main/install.sh | bash
#   # or, after cloning anywhere:  bash install.sh
#
set -euo pipefail

REPO="https://github.com/fenghourun/dotfiles.git"
CONFIG="$HOME/.config"
BREW_PREFIX="/opt/homebrew"   # Apple Silicon; use /usr/local for Intel

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

# 1. Homebrew ---------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$("$BREW_PREFIX/bin/brew" shellenv)"

# 2. Put the repo at ~/.config ---------------------------------------------
if [ -d "$CONFIG/.git" ]; then
  log "~/.config is already a git repo — pulling latest"
  git -C "$CONFIG" pull --ff-only
elif [ -d "$CONFIG" ]; then
  backup="$HOME/.config.backup-$(date +%Y%m%d-%H%M%S).tar.gz"
  log "Backing up existing ~/.config -> $backup"
  tar czf "$backup" -C "$HOME" .config
  log "Adopting ~/.config as the dotfiles repo (in place)"
  git -C "$CONFIG" init -q
  git -C "$CONFIG" remote add origin "$REPO" 2>/dev/null || git -C "$CONFIG" remote set-url origin "$REPO"
  git -C "$CONFIG" fetch origin main -q
  git -C "$CONFIG" checkout -f -B main origin/main      # overwrites stale config files; leaves untracked files alone
  git -C "$CONFIG" branch --set-upstream-to=origin/main main -q
else
  log "Cloning into ~/.config"
  git clone "$REPO" "$CONFIG"
fi

# 3. Submodules (zsh + tmux plugins) ---------------------------------------
log "Initializing submodules"
git -C "$CONFIG" submodule update --init --recursive

# 4. Shell bootstrap --------------------------------------------------------
log "Wiring up ~/.zshrc and ~/.zprofile"
if ! grep -qs 'source ~/.config/zsh/.zshrc' "$HOME/.zshrc" 2>/dev/null; then
  echo 'source ~/.config/zsh/.zshrc' >> "$HOME/.zshrc"
fi
if ! grep -qs 'brew shellenv' "$HOME/.zprofile" 2>/dev/null; then
  echo 'eval "$('"$BREW_PREFIX"'/bin/brew shellenv)"' >> "$HOME/.zprofile"
fi

# 5. Packages ---------------------------------------------------------------
log "Installing Homebrew packages"
brew bundle install --file="$CONFIG/brew/Brewfile"

# 6. Services (status bar + window borders) --------------------------------
log "Starting services"
brew services start sketchybar 2>/dev/null || true
brew services start borders   2>/dev/null || true

log "Done. Open AeroSpace.app, then restart your terminal or run: exec zsh"
