# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load homebbrew, if it is installed
if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]] then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)  
fi
# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k
# Add in zsh plugins
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets / Oh my zsh plugins
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
zinit snippet OMZP::nvm
zinit snippet OMZP::colored-man-pages

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color=always $realpath'

# Misc Environmental variables
export ZSH_AUTOSUGGEST_STRATEGY=(
    history
    completion
)
# Aliases
alias c='clear'
alias apt='sudo apt'

if command -v eza &> /dev/null; then  ## If eza is installed, set an alias for ls --> eza --icons, highlights changes to git. 
  alias ls='eza --icons --git'        
  alias lst='eza --icons --tree --level=2'
  alias lsd='eza --icons --tree -d'
  alias la='eza --icons -a -l'
fi
if command -v code &> /dev/null; then ## If vscode is installed, it will open zshrc in vscode.
  alias zshconfig='code ~/.zshrc'
fi
if [[ -n "$WSL_DISTRO_NAME" ]]; then                                        ## Check if the distro is running on WSL, then enable the following if true. 
  command -v op.exe &> /dev/null && alias ssh="ssh.exe"                     ## If 1password is installed.
  command -v OneCommander.exe &> /dev/null && alias oc="OneCommander.exe ." ## If OneCommander is installed on Windows, open current folder in OneCommander.
fi

# Shell integrations
if command -v fzf &> /dev/null; then                   ## If fzf is installed, initializes fzf and sets up sane fzf defaults. 
  eval "$(fzf --zsh)" 
  export FZF_COMPLETION_TRIGGER='--'                   ## Change the tab-shortcut from ** to --
  command -v bat &> /dev/null && {                     ## If bat is installed, set up fzf to use bat as the previewer.
    export FZF_DEFAULT_OPTS='--preview "bat --color=always --style=numbers --line-range :500 {}"'
  }
  command -v fd &> /dev/null && {                      ## If fd is installed, set up fzf to use fd as the default command.
    export FZF_DEFAULT_COMMAND='fd --type file --hidden'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd -t d . $HOME"
  }
fi

if command -v zoxide &> /dev/null; then ## Checks if zoxide is installed and Initialize zoxide
    export _ZO_DATA_DIR=~/              ## Set zoxide to save db to home folder, so it can be added to dotfile backup easily. 
    eval "$(zoxide init --cmd cd zsh)"

fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh