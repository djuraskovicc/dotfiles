#
# Petar Dj ZSH configuration
#

### PACKAGE MANAGER ZINIT ###
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source it
source "${ZINIT_HOME}/zinit.zsh"

### PLUGINS ###
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

### EXPORTS ###
[ -f ~/.profile ] && source ~/.profile

### BIND EMACS KEYS ###
bindkey -e

### PROMPT ###
autoload -Uz vcs_info # version control

setopt prompt_subst
zstyle ':vcs_info:*' enable git
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats '%F{yellow}(%b)%f'
PROMPT='%F{green}%n@%m%f:%F{blue}%3~%f ${vcs_info_msg_0_}
$ '

### AUTOCOMPLETE ###
autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Include hidden files

### HISTORY ###
HISTDIR=~/.cache/zsh
HISTFILE=$HISTDIR/histfile
HISTSIZE=1000
SAVEHIST=5000
HISTDUP=erase

if [[ ! -d $HISTDIR ]]; then
    mkdir -p $HISTDIR
fi

if [[ ! -f $HISTFILE ]]; then
    touch $HISTFILE
fi

setopt extended_glob
setopt correct
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

### KEYBINDINGS ###
bindkey '^n' history-search-forward                 # History command search forward
bindkey '^p' history-search-backward                # History command search backward

### ALIASES ###
alias ls='ls -lha --group-directories-first --color=auto --time-style=+"%d/%m/%Y %H:%M"'
alias disk='dysk'
alias grep='grep --color=auto'
alias clock="doas powercfg.sh"
alias die="poweroff"
alias neofetch="fastfetch"
alias sudo="doas"
alias n="nvim_fzf.sh"
alias t="tmux_project.sh"
