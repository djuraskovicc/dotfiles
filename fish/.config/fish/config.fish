#
# Fish shell configuration file
#

# My config
set fish_greeting # supresses fish's intro message
set EDITOR "nvim" # set's $EDITOR to neovim

### Default VI or Emacs key bindings ###
function fish_user_key_bindings
    # fish_default_key_bindings
    fish_vi_key_bindings
end


### FUNCTIONS FOR KEYBINDINGS ### 
function nvim-fzf
    set file (fzf)
    if test -n "$file"
        nvim $file
    end
end

function tmux-project
    set project_dir (find . -type d -iname "*" | fzf) 
    set session_name (basename $project_dir)
    if test -n "$project_dir"
        tmux new-session -c $project_dir -s $session_name 
    end
end

### KEY BINDINGS ###
bind \ct 'tmux-project'
bind \cf 'nvim-fzf'

### ALIASES ###
alias power "sudo /home/petar/scripts/./powercfg.sh"
function jcompile
    /home/petar/scripts/./compile2j.sh $argv
end
alias die "poweroff"

# Useless ASCII art
set -l startups "I use arch btw" "GNU/Linux" "This is fish" "Oh hell no" "Okay" "Hacker" "Ubuntu Noob" "FOSS"       # Define array of strings
set random_index (random 1 (count $startups))                                                                       # Pick random index
figlet -t -c -f ANSI-Shadow $startups[$random_index] | lolcat                                                       # ASCII art at the start

# Starship terminal prompt
starship init fish | source
