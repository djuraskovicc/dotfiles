#!/bin/bash

POWERLOW="sudo cpupower frequency-set -g powersave"
POWERHIGH="sudo cpupower frequency-set -g performance"
INFO="cpupower frequency-info"

echo -n "Performance (1), Powersave (2): "

read user_input

if [ "$user_input" -eq 1 ]; then
    $POWERHIGH
    $INFO
else
    $POWERLOW
    $INFO
fi
