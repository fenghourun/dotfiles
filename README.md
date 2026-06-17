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
| `tmux/` | tmux config + plugins (tpm) |
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

## Submodules

Plugins and the neovim config are git submodules, each pinned to a specific
commit:

| Submodule | Repo |
|-----------|------|
| `nvim` | `fenghourun/nvim` |
| `zsh/plugins/*` | zsh-autosuggestions, zsh-syntax-highlighting, zsh-vi-mode |
| `tmux/plugins/*` | tpm |

**Get / refresh them** (also part of `install.sh`):

```sh
git -C ~/.config submodule update --init --recursive
```

**Pull the latest upstream commit** for a submodule and bump the pin here:

```sh
git -C ~/.config submodule update --remote nvim   # fast-forward nvim to its latest master
cd ~/.config && git add nvim && git commit -m "bump nvim" && git push
```

**Editing the neovim config** (its own repo lives at `~/.config/nvim`): commit
in the submodule first, then record the new pin in this repo:

```sh
cd ~/.config/nvim && git add -p && git commit -m "..." && git push   # 1. push nvim changes
cd ~/.config && git add nvim && git commit -m "bump nvim" && git push  # 2. bump the pin in dotfiles
```

## Devserver / tmux

The dev flow is `ssh devserver` → work inside one persistent **tmux** session
(neovim in one window/pane, shells in others). The session lives on the
*server*, so disconnects don't lose work — reconnect and you're back where you
left off.

- On an **SSH login** the shell auto-runs `tmux new-session -A -s main`
  (see `zsh/.zshrc`), so you always land in the persistent `main` session. The
  guard only fires over SSH and when not already inside tmux — local macOS
  shells are unaffected.
- Prefix is **`C-a`**. Common keys: `C-a |` / `C-a -` split, `C-a c` new window,
  `C-a d` detach (leaves everything running), `C-a h/j/k/l` switch panes,
  `C-a` + arrows resize, `C-a r` reload. Neovim splits are navigated separately
  with the built-in `C-w h/j/k/l`.
- Reattach manually after a detach/disconnect with `tmux attach -t main`.
- tpm finds its plugins via the `TMUX_PLUGIN_MANAGER_PATH` env var (set in
  `tmux/tmux.conf` to `~/.config/tmux/plugins/`), so **no `~/.tmux` symlink** is
  needed — the in-repo submodules just work.

> Handing this to Claude on the devserver? Paste **[`DEVSERVER.md`](DEVSERVER.md)** —
> it's a self-contained setup + usage brief for the remote.

### Remote / Linux setup (non-intrusive, in-place)

**Don't run `install.sh` here** — it's macOS-only (Homebrew, sketchybar,
AeroSpace). On a remote where `~/.config` may already contain unrelated,
pre-existing files, adopt the repo *in place* instead: this touches only the
files this repo tracks and **leaves everything else alone** (git never deletes
untracked files on checkout).

```sh
cd ~/.config
git init -q
git remote add origin https://github.com/fenghourun/dotfiles.git
git fetch origin main -q
git checkout -f -B main origin/main         # overwrites only tracked files; anything else is untouched
git branch --set-upstream-to=origin/main main -q
git submodule update --init --recursive     # tmux + zsh plugins

# Keep pre-existing files out of `git status` (and out of accidental commits) by
# marking everything currently untracked as locally excluded. .git/info/exclude
# is per-clone and never committed, so the repo itself stays clean.
git status --porcelain | sed -n 's/^?? //p' >> .git/info/exclude

# Wire the shell (only if not already sourced):
grep -qs 'source ~/.config/zsh/.zshrc' ~/.zshrc || echo 'source ~/.config/zsh/.zshrc' >> ~/.zshrc
```

Then `exec zsh` (or reconnect) — the SSH auto-attach drops you into tmux.
To update later: `cd ~/.config && git pull && git submodule update --init --recursive`.

## Notes

- **Local / machine-specific files** are git-ignored and never committed:
  see `.gitignore` (e.g. `gh/hosts.yml` auth, `git/`, work devserver
  artifacts matching `*.ash0`). They stay on disk; git just doesn't track them.
- **Apple Silicon** is assumed (`/opt/homebrew`). On Intel, change
  `BREW_PREFIX` in `install.sh` to `/usr/local`.
- The zsh plugins here are vendored as submodules and sourced from
  `~/.config/zsh/plugins/`; don't rely on the Homebrew `zsh-*` formulae.
