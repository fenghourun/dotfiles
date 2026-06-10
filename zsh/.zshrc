# Env vars
export PATH=$HOME/.bun/bin:/opt/homebrew/opt/openssl@3/bin:/opt/homebrew/bin:$HOME/.local/bin:$PATH
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export KUBECONFIG_DIR=~/.config/kubernetes/
export XDG_CONFIG_HOME=~/.config/
export PGUSER=feng
export PGDATABASE=main
export HOMEBREW_BUNDLE_FILE=~/.config/brew/Brewfile

# Auto-attach to tmux on remote (devserver) SSH logins only.
# Joins the persistent "main" session, creating it if needed. Detach with C-a d.
# Guards: tmux installed, this is an SSH session, not already inside tmux,
# and the shell is interactive.
if command -v tmux >/dev/null 2>&1 && [ -n "$SSH_CONNECTION" ] && [ -z "$TMUX" ] && [[ $- == *i* ]]; then
  exec tmux new-session -A -s main
fi

# Initialize starship
eval "$(starship init zsh)"

# Aliases
source ~/.config/zsh/aliases.zsh

# Plugins
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# Binds
# bindkey '^I'      autosuggest-accept

# This will separate NPM & NVM between x86 and arm64, to avoid mixing package and dependency architectures (recipe for disaster)
export npm_config_cache="$HOME/.npm/$(arch)"

export NVM_DIR="$HOME/.nvm/$(arch)"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"

# postgres
export PATH="/opt/homebrew/opt/postgresql@14/bin:$PATH"

# rabbitmq
export PATH="$PATH:/opt/homebrew/sbin/"
export PATH="$HOME/.elan/bin:$PATH"

# Python Auto venv
auto_venv() {
    if [ -n "$VIRTUAL_ENV" ]; then
        # Check if we left the venv directory
        if [ "$(dirname "$VIRTUAL_ENV")" != "$PWD" ]; then
            echo "Deactivating venv: $(basename "$VIRTUAL_ENV")"
            deactivate
        fi
    fi

    # If a 'venv' directory exists, activate it
    if [ -d ".venv" ]; then
        echo "Activating venv: $(basename "$PWD")"
        source .venv/bin/activate
    fi
}

# Hook into directory change
autoload -Uz add-zsh-hook
add-zsh-hook chpwd auto_venv

# Run once at shell start
auto_venv

command -v fastfetch >/dev/null 2>&1 && fastfetch
