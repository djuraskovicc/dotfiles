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

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

### AUTOCOMPLETE ###
autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Include hidden files

### Vim MODE ###
bindkey -v
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init

echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt

### USE VIM KEYS IN AUTOCOMPLETE MENU ###
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -v '^?' backward-delete-char # When in vi mode cursor thing brakes deleting characters backwards. This fixes it.

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
alias ls='eza --group-directories-first -lghao'
alias disk='dysk'
alias grep='grep --color=auto'
alias clock="doas powercfg.sh"
alias die="poweroff"
alias neofetch="fastfetch"
alias sudo="doas"
alias n="nvim_fzf.sh"
alias t="tmux_project.sh"

### EXPORTS ###
[ -f ~/.profile ] && source ~/.profile
export PATH="$HOME/.config/emacs/bin:$PATH"

### LOOK AND FEEL ###

# Useless ASCII at startup
words=("I use arch btw" "Winter" "GNU/Linux" "This is zsh" "Okay" "Hacker" "Ubuntoo" "FOSS")  	# Define array of strings
random_index=$(( 1 + RANDOM % "${#words[@]}" ))                                                 # Pick random index

# seed 8 winter colors
# seed 25 spring
# seed 18 autumn
figlet -t -c -f ANSI-Shadow $words[$random_index] | lolcat --seed 8                             # ASCII art at the start

# Starship prompt
eval "$(starship init zsh)"
