#!/bin/sh

file=$(fzf --preview 'cat {}') && \
    nvim "$file" || \
    echo "No file selected."

