# Aliases

alias v="nvim"
alias nv="neovide --frame transparent --fork"
alias g="git"
alias grm="g fetch && g reset --hard origin/main"
alias gp="g push"
alias gpf="g push --force"
alias gcm="g checkout main"
alias aliases="v ~/.config/zsh/aliases.zsh"

# Open config
alias zshroot="v ~/.zshrc"
alias zshrc="v ~/.config/zsh/.zshrc"
alias starshiprc="v ~/.config/starship/starship.toml"
alias vimrc="v ~/.config/nvim/init.vim"
alias aerospacerc="v ~/.config/aerospace/aerospace.toml"
alias fdignore="v ~/.config/fd/ignore/.fdignore"

# Goto config
alias vimdir="cd ~/.config/nvim"
alias wezdir="cd ~/.config/wezterm"
alias nvdir="cd ~/.config/neovide"
alias zshdir="cd ~/.config/zsh"
alias starshipdir="cd ~/.config/starship"
alias cfg="cd ~/.config"

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




