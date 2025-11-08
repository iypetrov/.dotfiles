#!/usr/bin/bash

RESOLUTION="$(xrandr | grep -E " \+$" | xargs | cut -d ' ' -f 1)"
xrandr --output Virtual-1 --mode "${RESOLUTION}"