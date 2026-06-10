# Devserver handoff (for Claude running on the remote)

Context for setting up these dotfiles (`github.com/fenghourun/dotfiles`) on a
remote Linux devserver that's accessed over SSH. **Paste this whole file to
Claude on the devserver** to drive the one-time setup.

## Goal

The dev flow is `ssh devserver` → work inside one persistent **tmux** session
(neovim in one window/pane, shells in others). tmux runs **on the devserver**,
so disconnects/laptop-sleep never lose work — reconnect and resume.

## Hard constraint: be non-intrusive

`~/.config` on this devserver may already contain unrelated, pre-existing files
(managed by the environment). **Do not delete or overwrite them.** Adopt the
repo *in place* — `git checkout -f` only touches files this repo tracks and
leaves everything else alone (git never deletes untracked files on checkout).
**Do NOT run `install.sh`** — it is macOS-only (Homebrew, sketchybar, AeroSpace).

## One-time setup

```sh
cd ~/.config
git init -q
git remote add origin https://github.com/fenghourun/dotfiles.git
git fetch origin main -q
git checkout -f -B main origin/main          # overwrites only tracked files; anything else untouched
git branch --set-upstream-to=origin/main main -q
git submodule update --init --recursive      # tmux + zsh plugins

# Hide pre-existing files from `git status` so they're never accidentally
# committed. .git/info/exclude is per-clone and never committed.
git status --porcelain | sed -n 's/^?? //p' >> .git/info/exclude

# Source the repo's zshrc (only if not already wired):
grep -qs 'source ~/.config/zsh/.zshrc' ~/.zshrc || echo 'source ~/.config/zsh/.zshrc' >> ~/.zshrc

exec zsh
```

Prereqs: `tmux` and `git` installed on the devserver. After `exec zsh` (or a
fresh SSH login) you auto-attach into the `main` tmux session.

## Verify

```sh
tmux -V                                                   # tmux present
tmux new -d -s _t \; show-environment -g TMUX_PLUGIN_MANAGER_PATH \; kill-session -t _t
# expect: TMUX_PLUGIN_MANAGER_PATH=/<home>/.config/tmux/plugins/
```

If neovim colors look wrong inside tmux, the `tmux-256color` terminfo entry may
be missing on this host — that's the one likely fixup needed.

## How the setup works

- **Auto-attach:** `zsh/.zshrc` runs `tmux new-session -A -s main` on SSH logins
  only (guarded by `$SSH_CONNECTION` set, `$TMUX` empty, interactive). Local
  shells and nested tmux are unaffected.
- **Prefix `C-a`.** `C-a |` / `C-a -` split, `C-a c` new window, `C-a d` detach
  (leaves everything running), `C-a h/j/k/l` resize, `C-a r` reload,
  `C-a 1/2/…` or `C-a n`/`C-a p` switch windows.
- **`C-h/j/k/l`** (no prefix) moves between neovim splits and tmux panes
  (vim-tmux-navigator).
- **Plugins** are git submodules in `~/.config/tmux/plugins/`; tpm finds them via
  the `TMUX_PLUGIN_MANAGER_PATH` env var set in `tmux/tmux.conf` (no `~/.tmux`
  symlink).
- **Reattach** anytime: `tmux attach -t main`.

## Updating later

```sh
cd ~/.config && git pull && git submodule update --init --recursive
```
