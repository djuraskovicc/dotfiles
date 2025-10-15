#!/bin/sh

project_dir=$(find . -type d -iname "*" | fzf) && \
    tmux new-session -c "$project_dir" -s "$(basename "$project_dir")" || \
    echo "No directory selected."
