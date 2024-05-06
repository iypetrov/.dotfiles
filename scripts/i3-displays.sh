#!/bin/bash

function display_main_screen() {
    xrandr --auto
}

function display_second_screen() {
    xrandr --output "eDP-1" --off
    xrandr --output "$1" --auto --primary
}

data="$(xrandr | grep -v -E '^\s' | cut -d ' ' -f1,2 | tail -n +2)" 

if [[ "$(echo "${data}" | grep -E "^HDMI-1-1" | cut -d ' ' -f2)" = 'connected' ]]; then
    display_second_screen "HDMI-1-1"
    exit 0
fi

if [[ "$(echo "${data}" | grep -E "^DP-1-1" | cut -d ' ' -f2)" = 'connected' ]]; then
    display_second_screen "DP-1-1"
    exit 0
fi

if [[ "$(echo "${data}" | grep -E "^DP-1-2" | cut -d ' ' -f2)" = 'connected' ]]; then
    display_second_screen "DP-1-2"
    exit 0
fi


display_main_screen

