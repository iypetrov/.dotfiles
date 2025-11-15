#!/usr/bin/env bash

killall -q polybar
polybar -c /projects/common/.dotfiles/.config/polybar/config.ini example 2>&1 | tee -a /tmp/polybar.log & disown
