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

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

### KEYBINDINGS ###

# Keybinding funcitons
function nvim_fzf(){
    zle -I
    file=$(find . -type f -iname "*" | fzf)
    if [ -n "$file" ]; then
        nvim "$file"
    fi
}
zle -N nvim_fzf         # Create widget

function tmux_project(){
    zle -I
    project_dir=$(find . -type d -iname "*" | fzf)
    session_name=$(basename "$project_dir")
    if [ -n "$project_dir" ]; then
        # Initialize subshell correctly
        (
            exec </dev/tty
            exec <&1
            tmux new-session -c "$project_dir" -s "$session_name"
        )
    fi
}
zle -N tmux_project # Create widget

function zellij_project(){
    zle -I
    project_dir=$(find . -type d -iname "*" | fzf)
    session_name=$(basename "$project_dir")
    if [ -n "$project_dir" ]; then
        # Change to the selected project directory and start zellij
        (
            exec </dev/tty
            exec <&1
            cd "$project_dir"
            exec zellij -s "$session_name" --layout ~/.config/zellij/devlayout.kdl
        )
    fi
}
zle -N zellij_project # Create widget

# Actual keybindings
bindkey '^n' history-search-forward                 # History command search forward
bindkey '^p' history-search-backward                # History command search backward
bindkey '^f' nvim_fzf                               # Search with fzf and open in neovim
bindkey '^t' tmux_project                           # Search with fzf and open in tmux
bindkey '^z' zellij_project                         # Search with fzf and open in zellij

### ALIASES ###
alias ls='eza --group-directories-first -lha'
alias grep='grep --color=auto'
alias cleardirs="while popd >/dev/null 2>&1; do :; done"
alias clock="sudo $HOME/scripts/powercfg.sh"
alias jcompile="$HOME/scripts/compile2j.sh"
alias rec="$HOME/scripts/rec.sh"
alias die="poweroff"
alias reboot="reboot"

### LOOK AND FEEL ###

# Useless ASCII at startup
words=("I use arch btw" "Winter" "GNU/Linux" "This is zsh" "Toxic" "Okay" "Hacker" "Ubuntoo" "FOSS")  	# Define array of strings
random_index=$(( 1 + RANDOM % "${#words[@]}" ))                                                         # Pick random index
figlet -t -c -f ANSI-Shadow $words[$random_index] | lolcat --seed 8                                     # ASCII art at the start

# Starship prompt
eval "$(starship init zsh)"
