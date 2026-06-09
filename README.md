# dotfiles

Personal macOS (Apple Silicon) dotfiles. The repository **is** `~/.config` —
there is no symlink farm or `stow`. Files live where the apps already look for
them (`~/.config/<app>/...`), and the shell is bootstrapped by a one-line
`~/.zshrc` that sources `~/.config/zsh/.zshrc`.

## What's in here

| Path | Tool |
|------|------|
| `zsh/` | zsh config, aliases, vendored plugins (submodules) |
| `starship/` | prompt |
| `tmux/` | tmux config + plugins (tpm, vim-tmux-navigator) |
| `wezterm/` | terminal |
| `aerospace/` | tiling window manager |
| `sketchybar/` + `borders` | status bar + window borders |
| `helix/`, `neovide/`, `fastfetch/`, `htop/`, `yazi`-style configs | misc tools |
| `brew/Brewfile` | the canonical package list (`HOMEBREW_BUNDLE_FILE`) |

Plugins are git **submodules** (`zsh/plugins/*`, `tmux/plugins/*`).

## Install on a new machine

```sh
curl -fsSL https://raw.githubusercontent.com/fenghourun/dotfiles/main/install.sh | bash
```

The script (`install.sh`) is idempotent and:

1. installs Homebrew if missing,
2. makes `~/.config` track this repo (backing up any existing `~/.config` to
   `~/.config.backup-<timestamp>.tar.gz` first),
3. initializes submodules,
4. wires `~/.zshrc` (`source ~/.config/zsh/.zshrc`) and `~/.zprofile`
   (`brew shellenv`),
5. runs `brew bundle`,
6. starts the `sketchybar` and `borders` services.

Then open **AeroSpace.app** and restart the terminal (`exec zsh`).

### Manual install (equivalent)

```sh
# Homebrew first (https://brew.sh), then:
git -C ~/.config init
git -C ~/.config remote add origin https://github.com/fenghourun/dotfiles.git
git -C ~/.config fetch origin main
git -C ~/.config checkout -f -B main origin/main
git -C ~/.config submodule update --init --recursive
echo 'source ~/.config/zsh/.zshrc' >> ~/.zshrc
brew bundle install --file=~/.config/brew/Brewfile
```

## Updating / switching machines

Because `~/.config` is the working tree, day-to-day use is plain git.

**Pull the latest config onto this machine:**

```sh
cd ~/.config
git pull
git submodule update --init --recursive   # in case plugins changed
brew bundle install --file=~/.config/brew/Brewfile   # sync packages
```

(Re-running `bash ~/.config/install.sh` does all of the above too.)

**Push changes you made on this machine:**

```sh
cd ~/.config
git add -p           # review hunks
git commit -m "..."
git push
```

**Capture newly installed Homebrew packages** before switching machines
(optional — review the diff, since `dump` records *every* installed leaf,
including ones intentionally left out of the curated Brewfile):

```sh
brew bundle dump --force --file=~/.config/brew/Brewfile
git -C ~/.config diff brew/Brewfile     # prune anything you don't want, then commit
```

## Notes

- **Local / machine-specific files** are git-ignored and never committed:
  see `.gitignore` (e.g. `gh/hosts.yml` auth, `git/`, `nvim`, work devserver
  artifacts matching `*.ash0`). They stay on disk; git just doesn't track them.
- **Apple Silicon** is assumed (`/opt/homebrew`). On Intel, change
  `BREW_PREFIX` in `install.sh` to `/usr/local`.
- The zsh plugins here are vendored as submodules and sourced from
  `~/.config/zsh/plugins/`; don't rely on the Homebrew `zsh-*` formulae.
