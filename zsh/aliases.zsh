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
  alias fpdir="cd ~/Documents/first-principles/"
  alias redir="cd ~/Documents/recommendation-engine/"
  alias dadir="cd ~/Documents/data-analysis/"
  alias redir="cd ~/Documents/recommendation-engine/"
  alias docs="cd ~/Documents"
elif uname | grep -q "Linux" ; then
  alias fpdir="cd ~/documents/first-principles/"
  alias dadir="cd ~/documents/data-analysis/"
  alias docs="cd ~/documents"
else
  echo 'Unknown OS!'
fi


benchmark () {
   ts '[%Y-%m-%d %H:%M:%S]'
}

