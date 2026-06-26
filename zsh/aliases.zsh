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




